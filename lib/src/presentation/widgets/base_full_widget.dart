import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

abstract class BaseFullWidget extends StatefulWidget {
  const BaseFullWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState();
}

abstract class BaseFullWidgetState<T extends StatefulWidget> extends State<T>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
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

  @override
  bool get wantKeepAlive => false;
}
