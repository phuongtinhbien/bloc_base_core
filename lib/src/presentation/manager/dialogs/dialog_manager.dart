import 'dart:async';
import 'dart:collection';

import 'package:bloc_base_core/src/utils/logger/logger_tool.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

typedef ListenDialog = Function(DialogRequest);

typedef DialogBuilder = Widget Function(
    BuildContext, DialogConfig, VoidCallback closePopup);

class DialogManager {
  /// Creating a queue of waiting dialogs.
  final Queue<Tuple2<BuildContext, DialogConfig>> _queue = Queue();

  /// `_dialogProcess` is a BehaviorSubject that is used to show a dialog orderly
  final BehaviorSubject<Tuple2<BuildContext, DialogConfig>> _dialogProcess =
      BehaviorSubject();

  /// A map of dynamic keys to DialogBuilder values.
  final Map<String, DialogBuilder> _dialogsBuilder = {};

  DialogManager();

  /// It takes a map of dynamic keys to DialogBuilder values and adds them to the
  /// _dialogsBuilder map
  ///
  /// Args:
  ///   builders (Map<dynamic, DialogBuilder>): A map of dialog builders. The key is
  /// the type of the dialog, and the value is the builder.
  void registerDialogBuilder(Map<String, DialogBuilder> builders) {
    _dialogsBuilder.addAll(builders);
    _dialogProcess
        .delay(const Duration(milliseconds: 500))
        .distinct((previous, next) => previous.item2 != next.item2)
        .listen((dialog) {
      _showDialog(dialog.item1, dialog.item2);
    });
  }

  /// If the queue is empty, show the dialog. If the queue is not empty, show the
  /// dialog and add the dialog to the queue
  ///
  /// Args:
  ///   context (BuildContext): The context of the widget that is calling the show
  /// method.
  ///   type (dynamic): The type of dialog to show.
  ///   config (DialogConfig): The configuration of the dialog. Defaults to const
  /// DialogConfig()
  void show(BuildContext context, {required DialogConfig config}) {
    final packDialog = Tuple2(context, config);
    if (!_queue.any((element) => element.item2 == packDialog.item2)) {
      _queue.addLast(packDialog);
    }

    if (!_dialogProcess.hasValue ||
        _dialogProcess.value.item2.completer.isCompleted) {
      Log.d('_queue.isEmpty');
      _dialogProcess.add(_queue.removeFirst());
    }

    config.completer.future.whenComplete(() {
      Log.d('Dialog: isCompleted');
      if (_queue.isNotEmpty) {
        _dialogProcess.add(_queue.removeFirst());
      }
    });
  }

  /// `_showDialog` is a function that is used to show a dialog. It takes a
  /// `BuildContext` and a `DialogConfig` object as parameters. It then uses the
  /// `type`
  /// property of the `DialogConfig` object to determine which dialog to show.
  void _showDialog(BuildContext context, DialogConfig config) {
    final dialog = _dialogsBuilder[config.type];
    final closePopup = () => _onPopupClose(context, config.completer);
    if (dialog != null) {
      showDialog(
          context: context,
          barrierDismissible: config.barrierDismissible,
          barrierColor: config.barrierColor,
          builder: (_) => WillPopScope(
              onWillPop: () async {
                config.request?.onClose?.call();
                closePopup.call();
                return config.barrierDismissible;
              },
              child: dialog.call(context, config, closePopup)));
    }
  }

  /// _onPopupClose() is a function that pops the current context and completes the
  /// completer
  ///
  /// Args:
  ///   context (BuildContext): The context of the widget that is calling the popup.
  ///   completer (Completer): This is a Completer object that is used to notify the
  /// caller that the popup has been closed.
  void _onPopupClose(BuildContext context, Completer completer) {
    Navigator.pop(context);
    if (!completer.isCompleted) {
      completer.complete();
    }
  }

  /// Used to close the `_dialogProcess` stream and the queue of dialog.
  void close() {
    _queue.clear();
    _dialogProcess.close();
  }
}

/// > A class that represents a request to show a dialog
class DialogRequest<T> extends Equatable {
  /// Used to show a title on the dialog.
  final String? title;

  /// A property of the DialogRequest class. It is used to show a description on the
  /// dialog.
  final String description;

  /// Used to show an icon on the dialog.
  final Widget? icon;

  /// A property of the DialogRequest class. It is used to show a main button on the
  /// dialog.
  final String mainButtonTitle;

  /// Used to show a secondary button on the dialog.
  final String? secondaryButtonTitle;

  /// A function that is called when the main button is tapped.
  final VoidCallback onMainButtonTap;

  /// A function that is called when the secondary button is tapped.
  final VoidCallback? onSecondaryButtonTap;

  /// A function that is called when the dialog is closed.
  final VoidCallback? onClose;

  /// `data` is a generic type that is used to pass data to the dialog.
  final T? data;

  const DialogRequest({
    required this.description,
    required this.onMainButtonTap,
    required this.mainButtonTitle,
    this.secondaryButtonTitle,
    this.onSecondaryButtonTap,
    this.onClose,
    this.title,
    this.icon,
    this.data,
  });

  @override
  List get props => [
        description,
        onMainButtonTap,
        mainButtonTitle,
        secondaryButtonTitle,
        onSecondaryButtonTap,
        onClose,
        title,
        icon,
        data,
      ];
}

class DialogConfig extends Equatable {
  /// A property of the DialogConfig class. It is used to determine if the dialog
  /// can be dismissed by tapping outside of the dialog.
  final bool barrierDismissible;

  /// A property of the DialogConfig class. It is used to pass a DialogRequest
  /// object to the dialog.
  final DialogRequest? request;

  /// The `late` keyword is used to tell the compiler that the `completer` property
  /// will be initialized after the constructor is called.
  late final Completer completer;

  /// The `type` property is used to determine which dialog to show.
  final String type;

  /// The `barrierColor` property is used to set the color of the barrier that
  /// covers the screen when the dialog is shown.
  final Color? barrierColor;

  DialogConfig({
    required this.type,
    this.barrierDismissible = true,
    this.request,
    this.barrierColor = Colors.black38,
  }) {
    completer = Completer();
  }

  @override
  List get props =>
      [barrierDismissible, request, completer, type, barrierColor];
}
