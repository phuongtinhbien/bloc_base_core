import 'dart:io';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AppMediaQuery with WidgetsBindingObserver {
  static final AppMediaQuery _singleton = AppMediaQuery._internal();

  AppMediaQuery._internal();

  factory AppMediaQuery() {
    return _singleton;
  }

  /// `init` is a method that is called when the app is first initialized.
  void init(SingletonFlutterWindow window) {
    data = MediaQueryData.fromWindow(window).copyWith(textScaleFactor: 1);
    bottomNavigationHeight.onChange(data.padding.bottom);
  }

  /// `data` is a `MediaQueryData` object that is used to get the size of the
  /// screen, the status bar height, the navigation bar height, and the view insets.
  late MediaQueryData data;

  /// `statusBarHeight` is a getter that returns the height of the status bar.
  double get statusBarHeight => data.padding.top;

  /// `navigationBarHeight` is a getter that returns the height of the navigation
  /// bar.
  double get navigationBarHeight => bottomNavigationHeight.height;

  /// `size` is a getter that returns the size of the screen.
  Size get size => data.size;

  /// `viewInsets` is a property of `MediaQueryData` that returns the view insets.
  EdgeInsets get viewInsets => data.viewInsets;

  /// `isKeyboardVisible` is a getter that returns a boolean value that
  /// indicates whether the keyboard is visible or not.
  bool get isKeyboardVisible => keyboardHeight.height > 0;

  ///Apply for Android Only
  /// `displayType` is a property of `MediaQueryData` that returns the type of
  /// display feature.
  DisplayFeatureType get displayType => data.displayFeatures.first.type;

  /// `keyboardHeight` is a `KeyBoardHeightNotifier` object that is used to
  /// get the height of the keyboard.
  final KeyBoardHeightNotifier keyboardHeight = KeyBoardHeightNotifier();

  /// `bottomNavigationHeight` is a `NavigationBarHeightNotifier` object that is
  /// used to get the height of the navigation bar.
  final NavigationBarHeightNotifier bottomNavigationHeight =
      NavigationBarHeightNotifier();

  @override

  /// > When the metrics of the device change, update the keyboard height and bottom
  /// navigation height, and if the size of the device has changed, update the size
  /// and padding of the device
  void didChangeMetrics() {
    final mediaQuery = MediaQueryData.fromWindow(window);
    keyboardHeight.onChange(mediaQuery.viewInsets.bottom);
    bottomNavigationHeight.onChange(mediaQuery.padding.bottom);
    if (data.size != mediaQuery.size) {
      data = data.copyWith(size: mediaQuery.size, padding: mediaQuery.padding);
    }
  }
}

/// `AndroidNavigationMode` is a class that is used to get the navigation mode of
/// the device.
class AndroidNavigationMode {
  static const MethodChannel _channel =
      MethodChannel('android_navigation_mode');

  /// This method is used to get the navigation mode of the device.
  static Future<DeviceNavigationMode> get getNavigationMode async {
    if (Platform.isIOS) {
      return DeviceNavigationMode.none;
    }
    final int mode = await _channel.invokeMethod('get_navigation_mode');
    switch (mode) {
      case 0:
        return DeviceNavigationMode.threeButton;
      case 1:
        return DeviceNavigationMode.twoButton;
      case 2:
        return DeviceNavigationMode.fullScreenGesture;
      default:
        return DeviceNavigationMode.none;
    }
  }
}

/// This is an enum that is used to get the navigation mode of the device.
enum DeviceNavigationMode { twoButton, threeButton, fullScreenGesture, none }

/// It's a ChangeNotifier that holds the height of the keyboard.
class KeyBoardHeightNotifier extends ChangeNotifier {
  double height = 0;

  void onChange(double height) {
    this.height = height;
    notifyListeners();
  }
}

/// It's a ChangeNotifier that holds the height of the navigation bar
class NavigationBarHeightNotifier extends ChangeNotifier {
  double height = 0;

  void onChange(double height) {
    this.height = height;
    notifyListeners();
  }
}
