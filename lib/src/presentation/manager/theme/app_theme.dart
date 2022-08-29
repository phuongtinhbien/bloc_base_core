import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  final SystemUiOverlayStyle? systemUiOverlayStyle;

  final ThemeData data;

  final AppThemeOptions? options;

  const AppTheme({required this.data, this.options, this.systemUiOverlayStyle});

  factory AppTheme.light() {
    return AppTheme(
        data: ThemeData.light(),
        systemUiOverlayStyle: const SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
            statusBarColor: Colors.transparent));
  }

  factory AppTheme.dark() {
    return AppTheme(
        data: ThemeData.dark(),
        systemUiOverlayStyle: const SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
            statusBarColor: Colors.transparent));
  }
}

/// Interface to use when creating an app theme option class.
abstract class AppThemeOptions {}
