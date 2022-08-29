import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

abstract class BaseWidget extends StatelessWidget {
  const BaseWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrientationLayoutBuilder(portrait: (_) {
      return ScreenTypeLayout.builder(
        mobile: buildMobile,
        tablet: buildTablet,
      );
    }, landscape: (_) {
      return ScreenTypeLayout.builder(
        mobile: buildLandscapeMobile,
        tablet: buildLandscapeTablet,
      );
    });
  }

  Widget buildMobile(BuildContext context);

  Widget buildTablet(BuildContext context) {
    return buildMobile(context);
  }

  Widget buildLandscapeMobile(BuildContext context) {
    return buildMobile(context);
  }

  Widget buildLandscapeTablet(BuildContext context) {
    return buildTablet(context);
  }
}
