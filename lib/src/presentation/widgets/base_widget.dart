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

  /// Returning the mobile version of the widget.
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

 /// If the device is in landscape mode, and the device is a mobile device, then
  /// build the landscape mobile widget
  ///
  /// Args:
  ///   context (BuildContext): The context of the widget.
   Widget buildLandscapeMobile(BuildContext context) {
    return buildMobile(context);
  }

  /// If the device is a tablet in landscape orientation, then return the same
  /// widget that is returned for a tablet in portrait orientation
  ///
  /// Args:
  ///   context (BuildContext): The BuildContext of the widget.
  Widget buildLandscapeTablet(BuildContext context) {
    return buildTablet(context);
  }
}
