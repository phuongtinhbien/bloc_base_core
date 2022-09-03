import 'package:bloc_base_core/src/presentation/manager/theme/app_media_query.dart';
import 'package:flutter/material.dart';

class KeyboardSpacing extends StatelessWidget {
  const KeyboardSpacing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: AppMediaQuery().keyboardHeight,
        builder: (_, child) {
          return Ink(
            color: Colors.white,
            height: AppMediaQuery().keyboardHeight.height,
          );
        });
  }
}
