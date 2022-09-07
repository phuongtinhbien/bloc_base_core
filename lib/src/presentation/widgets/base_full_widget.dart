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

  /// If the device is a mobile, return the mobile version of the widget
  ///
  /// Args:
  ///   context (BuildContext): The context of the widget.
  ///
  /// Returns:
  ///   A widget.
  Widget buildMobile(BuildContext context);

  /// If the device is a tablet, return the tablet version of the widget
  ///
  /// Args:
  ///   context (BuildContext): The context of the widget.
  ///
  /// Returns:
  ///   A widget.
  Widget buildTablet(BuildContext context) {
    return buildMobile(context);
  }

  /// If the device is in landscape mode, return the mobile version of the app
  ///
  /// Args:
  ///   context (BuildContext): The BuildContext for the widget.
  ///
  /// Returns:
  ///   A widget.
  Widget buildLandscapeMobile(BuildContext context) {
    return buildMobile(context);
  }

  /// If the device is a tablet in landscape orientation, then return the same
  /// widget that is returned for a tablet in portrait orientation
  ///
  /// Args:
  ///   context (BuildContext): The BuildContext of the widget.
  ///
  /// Returns:
  ///   A widget that is a Scaffold with a body that is a ListView with a Column
  /// that has a Text widget and a ListView widget.
  Widget buildLandscapeTablet(BuildContext context) {
    return buildTablet(context);
  }

  @override
  bool get wantKeepAlive => false;
}
