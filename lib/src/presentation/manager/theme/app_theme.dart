import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  /// Setting the status bar color to transparent.
  final SystemUiOverlayStyle? systemUiOverlayStyle;

  /// A property of the AppTheme class.
  final ThemeData data;

  /// A way to pass in an optional class that can be used to customize the theme.
  final AppThemeOptions? options;

  const AppTheme({required this.data, this.options, this.systemUiOverlayStyle});

  /// `AppTheme.light()` returns a new instance of `AppTheme` with a `ThemeData`
  /// object that has a light theme and a `SystemUiOverlayStyle` object that has a
  /// transparent navigation bar and status bar
  ///
  /// Returns:
  ///   A new instance of the AppTheme class.
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

  /// `AppTheme.dark()` returns a new `AppTheme` object with a `ThemeData` object
  /// that is dark, and a `SystemUiOverlayStyle` object that is transparent
  ///
  /// Returns:
  ///   A new instance of the AppTheme class.
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
