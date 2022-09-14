import 'dart:async';
import 'dart:isolate';

import 'package:bloc_base_core/src/domain/domain.dart';
import 'package:bloc_base_core/src/utils/logger/logger_tool.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

enum BackgroundUseCaseState { idle, loading, calculating }

/// Data structure sent from the isolate back to the main isolate
class BackgroundUseCaseResponse<T> {
  T? data;
  Error? error;
  bool? done;

  BackgroundUseCaseResponse({this.data, this.error, this.done = false});
}

/// Data structure sent from the main isolate to the other isolate
class BackgroundUseCaseParams<T> extends UseCaseParam {
  T? params;
  SendPort port;

  BackgroundUseCaseParams(this.port, {this.params});
}

abstract class BackgroundUseCase<T, P extends UseCaseParam>
    extends BaseUseCase<BackgroundUseCaseParams, void> {
  BackgroundUseCaseState _state = BackgroundUseCaseState.idle;
  late Isolate? _isolate;
  final BehaviorSubject<T> _subject = BehaviorSubject();
  final ReceivePort _receivePort = ReceivePort();

  BackgroundUseCase()
      : assert(!kIsWeb, '''
        [BackgroundUseCase] is not supported on web due to dart:isolate limitations.
      '''),
        super() {
    _receivePort.listen(_handleMessage);
  }

  BackgroundUseCaseState get state => _state;

  bool get isRunning => _state != BackgroundUseCaseState.idle;


  @nonVirtual
  void execute(Observer<T> observer, [P? params]) {
    if (!isRunning) {
      _state = BackgroundUseCaseState.loading;
      _subject.listen(observer.onNext,
          onError: observer.onError, onDone: observer.onComplete);
      Isolate.spawn<BackgroundUseCaseParams>(call,
              BackgroundUseCaseParams(_receivePort.sendPort, params: params))
          .then<void>((Isolate isolate) {
        if (!isRunning) {
          Log.i('Killing background isolate.');
          isolate.kill(priority: Isolate.immediate);
        } else {
          _state = BackgroundUseCaseState.calculating;
          _isolate = isolate;
        }
      });
    }
  }

  @override
  @visibleForOverriding
  Future<void> call([BackgroundUseCaseParams? params]);

  @override
  FutureOr<void> onDispose() {
    _subject.close();
    _stop();
  }

  /// Killing the isolate.
  void _stop() {
    if (isRunning) {
      _state = BackgroundUseCaseState.idle;
      if (_isolate != null) {
        Log.i('Killing background isolate.');
        _isolate!.kill(priority: Isolate.immediate);
        _isolate = null;
      }
    }
  }

  /// Receiving data from the isolate and sending it to the stream.
  void _handleMessage(dynamic message) {
    assert(message is BackgroundUseCaseResponse,
        '''All data and errors sent from the isolate in the static method provided by the user must be
    wrapped inside a `BackgroundUseCaseMessage` object.''');
    var msg = message as BackgroundUseCaseResponse;
    if (msg.data != null) {
      assert(msg.data is T);
      _subject.add(msg.data);
    } else if (msg.error != null) {
      _subject.addError(msg.error!);
      _subject.close();
    }

    if (msg.done!) {
      _subject.close();
    }
  }
}

abstract class Observer<T> {
  void onNext(T? response);

  void onComplete();

  void onError(e);
}
