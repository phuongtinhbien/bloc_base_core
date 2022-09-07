part of 'theme_manager_cubit.dart';

/// It's a class that holds the current theme mode and the current theme
class ThemeManagerState extends Equatable {
  /// It's a property that holds the current theme mode.
  final ThemeMode mode;

  /// It's a property that holds the current theme.
  final AppTheme theme;

  const ThemeManagerState({this.mode = ThemeMode.light, required this.theme});

  @override
  List<Object> get props => [mode, theme];

  ThemeManagerState copyWith({ThemeMode? mode, AppTheme? theme}) {
    return ThemeManagerState(
        theme: theme ?? this.theme, mode: mode ?? this.mode);
  }
}
