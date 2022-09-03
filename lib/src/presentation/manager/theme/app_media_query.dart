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

  void init(SingletonFlutterWindow window) {
    data = MediaQueryData.fromWindow(window).copyWith(textScaleFactor: 1);
    bottomNavigationHeight.onChange(data.padding.bottom);
  }

  late MediaQueryData data;

  double get statusBarHeight => data.padding.top;

  double get navigationBarHeight => bottomNavigationHeight.height;

  Size get size => data.size;

  EdgeInsets get viewInsets => data.viewInsets;

  bool get isKeyboardVisible => keyboardHeight.height > 0;

  ///Apply for Android Only
  DisplayFeatureType get displayType => data.displayFeatures.first.type;

  final KeyBoardHeightNotifier keyboardHeight = KeyBoardHeightNotifier();

  final NavigationBarHeightNotifier bottomNavigationHeight =
      NavigationBarHeightNotifier();

  @override
  void didChangeMetrics() {
    final mediaQuery = MediaQueryData.fromWindow(window);
    keyboardHeight.onChange(mediaQuery.viewInsets.bottom);
    bottomNavigationHeight.onChange(mediaQuery.padding.bottom);
    if (data.size != mediaQuery.size) {
      data = data.copyWith(size: mediaQuery.size, padding: mediaQuery.padding);
    }
  }
}

class AndroidNavigationMode {
  static const MethodChannel _channel =
      MethodChannel('android_navigation_mode');

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

enum DeviceNavigationMode { twoButton, threeButton, fullScreenGesture, none }

class KeyBoardHeightNotifier extends ChangeNotifier {
  double height = 0;

  void onChange(double height) {
    this.height = height;
    notifyListeners();
  }
}

class NavigationBarHeightNotifier extends ChangeNotifier {
  double height = 0;

  void onChange(double height) {
    this.height = height;
    notifyListeners();
  }
}
