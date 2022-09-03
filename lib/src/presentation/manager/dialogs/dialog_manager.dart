import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

typedef ListenDialog = Function(DialogRequest);

typedef DialogBuilder = Widget Function(
    BuildContext, DialogConfig, VoidCallback closePopup);

class DialogManager {
  final Queue<Tuple2<dynamic, DialogConfig>> _queue = Queue();

  final Map<dynamic, DialogBuilder> _dialogsBuilder = {};

  DialogManager();

  void registerDialogBuilder(Map<dynamic, DialogBuilder> builders) {
    _dialogsBuilder.addAll(builders);
  }

  void show(BuildContext context, dynamic type,
      {DialogConfig config = const DialogConfig()}) {
    final completer = Completer();

    if (_queue.isEmpty) {
      _showDialog(context, type, completer, config);
    } else {
      _showDialog(context, type, completer, _queue.first.item2);
      _queue
        ..removeFirst()
        ..addLast(Tuple2(type, config));
    }
    completer.future.whenComplete(() {
      if (_queue.isNotEmpty) {
        show(_queue.first.item1, _queue.first.item2);
        _queue.removeFirst();
      }
    });
  }

  void _showDialog(BuildContext context, dynamic type, Completer completer,
      DialogConfig config) {
    final dialog = _dialogsBuilder[type];
    final closePopup = () => _onPopupClose(context, completer);
    if (dialog != null) {
      showDialog(
          context: context,
          barrierDismissible: config.barrierDismissible,
          builder: (_) => WillPopScope(
              onWillPop: () async {
                config.request?.onClose?.call();
                return config.barrierDismissible;
              },
              child: dialog.call(context, config, closePopup)));
    }
  }

  void _onPopupClose(BuildContext context, Completer completer) {
    Navigator.pop(context);
    completer.complete();
  }

  void close() {
    _queue.clear();
  }
}

class DialogRequest<T> {
  final String? title;

  final String description;

  final Widget? icon;

  final String mainButtonTitle;

  final String? secondaryButtonTitle;

  final VoidCallback onMainButtonTap;

  final VoidCallback? onSecondaryButtonTap;

  final VoidCallback? onClose;

  final T? data;

  DialogRequest({
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
}

class DialogConfig {
  final bool barrierDismissible;
  final DialogRequest? request;

  const DialogConfig({
    this.request,
    this.barrierDismissible = true,
  });
}
