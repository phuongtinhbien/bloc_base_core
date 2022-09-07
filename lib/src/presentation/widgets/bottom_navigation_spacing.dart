import 'package:bloc_base_core/src/presentation/manager/theme/app_media_query.dart';
import 'package:flutter/material.dart';

/// It's a widget that builds a white inkwell with a height that matches the bottom
/// navigation bar
class BottomNavigationSpacing extends StatelessWidget {
  final Color? color;

  const BottomNavigationSpacing({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: AppMediaQuery().bottomNavigationHeight,
        builder: (_, child) {
          return Ink(
            color: color,
            height: AppMediaQuery().bottomNavigationHeight.height,
          );
        });
  }
}
