import 'package:bloc_base_core/bloc_base_core.dart';
import 'package:flutter/material.dart';

class AppDialog extends DialogManager {
  void init() {
    registerDialogBuilder({
      'test': (_, config, closePopup) {
        return AlertDialog(
          content: Text(config.request?.description ?? ''),
          actions: [
            ElevatedButton(
                onPressed: () {
                  closePopup();
                },
                child: Text('Close'))
          ],
        );
      }
    });
  }
}
