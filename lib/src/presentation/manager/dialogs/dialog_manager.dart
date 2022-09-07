import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

typedef ListenDialog = Function(DialogRequest);

typedef DialogBuilder = Widget Function(
    BuildContext, DialogConfig, VoidCallback closePopup);

class DialogManager {
  /// Creating a queue of dialogs.
  final Queue<Tuple2<dynamic, DialogConfig>> _queue = Queue();

  /// A map of dynamic keys to DialogBuilder values.
  final Map<dynamic, DialogBuilder> _dialogsBuilder = {};

  DialogManager();

  /// It takes a map of dynamic keys to DialogBuilder values and adds them to the
  /// _dialogsBuilder map
  ///
  /// Args:
  ///   builders (Map<dynamic, DialogBuilder>): A map of dialog builders. The key is
  /// the type of the dialog, and the value is the builder.
  void registerDialogBuilder(Map<dynamic, DialogBuilder> builders) {
    _dialogsBuilder.addAll(builders);
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

  /// It shows a dialog
  ///
  /// Args:
  ///   context (BuildContext): The context of the widget that called the showDialog
  /// method.
  ///   type (dynamic): The type of dialog to show.
  ///   completer (Completer): This is a Completer object that is used to notify the
  /// caller that the dialog has been closed.
  ///   config (DialogConfig): The configuration object that is passed to the
  /// dialog.
  ///
  /// Returns:
  ///   A function that takes a context and a config and returns a dialog.
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

  /// _onPopupClose() is a function that pops the current context and completes the
  /// completer
  ///
  /// Args:
  ///   context (BuildContext): The context of the widget that is calling the popup.
  ///   completer (Completer): This is a Completer object that is used to notify the
  /// caller that the popup has been closed.
  void _onPopupClose(BuildContext context, Completer completer) {
    Navigator.pop(context);
    completer.complete();
  }

  /// `close()` clears the queue
  void close() {
    _queue.clear();
  }
}

/// > A class that represents a request to show a dialog
class DialogRequest<T> {
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
  /// A property of the DialogConfig class. It is used to determine if the dialog
  /// can be dismissed by tapping outside of the dialog.
  final bool barrierDismissible;

  /// A property of the DialogConfig class. It is used to pass a DialogRequest
  /// object to the dialog.
  final DialogRequest? request;

  const DialogConfig({
    this.request,
    this.barrierDismissible = true,
  });
}
