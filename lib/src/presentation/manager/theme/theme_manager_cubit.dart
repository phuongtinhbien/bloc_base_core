import 'package:bloc_base_core/src/presentation/manager/theme/app_theme.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part './theme_manager_state.dart';

class ThemeManagerCubit extends Cubit<ThemeManagerState> {
  /// A getter that returns the light theme.
  final AppTheme light;
  /// A getter that returns the dark theme.
  final AppTheme dark;

  ThemeManagerCubit({required this.light, required this.dark})
      : super(ThemeManagerState(theme: light));

  /// > It emits a new state with the theme mode and the theme that corresponds to
  /// the theme mode
  ///
  /// Args:
  ///   mode (ThemeMode): The current theme mode.
  void changeThemeMode(ThemeMode mode) {
    emit(state.copyWith(mode: mode, theme: getThemByMode(mode)));
  }

  /// If the mode is light, return the light theme, otherwise return the dark theme
  ///
  /// Args:
  ///   mode (ThemeMode): The current theme mode.
  ///
  /// Returns:
  ///   The light or dark theme depending on the mode.
  AppTheme getThemByMode(ThemeMode mode) {
    return mode == ThemeMode.light ? light : dark;
  }

  /// A getter that returns the current theme.
  AppTheme get currentTheme => state.theme;
}
