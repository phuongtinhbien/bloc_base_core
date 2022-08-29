import 'package:bloc_base_core/src/presentation/manager/theme/app_theme.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part './theme_manager_state.dart';

class ThemeManagerCubit extends Cubit<ThemeManagerState> {
  final AppTheme light;
  final AppTheme dark;

  ThemeManagerCubit({required this.light, required this.dark})
      : super(ThemeManagerState(theme: light));

  void changeThemeMode(ThemeMode mode) {
    emit(state.copyWith(mode: mode, theme: getThemByMode(mode)));
  }

  AppTheme getThemByMode(ThemeMode mode) {
    return mode == ThemeMode.light ? light : dark;
  }

  AppTheme get currentTheme => state.theme;
}
