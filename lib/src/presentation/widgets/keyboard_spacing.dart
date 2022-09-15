import 'package:bloc_base_core/src/presentation/manager/theme/app_media_query.dart';
import 'package:flutter/widgets.dart';

/// A widget that is used to fill the space between the keyboard and the bottom of
/// the screen.
class KeyboardSpacing extends StatelessWidget {
  final Color? color;

  const KeyboardSpacing({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: AppMediaQuery().keyboardHeight,
        builder: (_, child) {
          return Container(
            color: color ?? const Color(0x00000000),
            height: AppMediaQuery().keyboardHeight.height,
          );
        });
  }
}
