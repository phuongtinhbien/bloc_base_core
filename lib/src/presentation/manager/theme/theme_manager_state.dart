part of 'theme_manager_cubit.dart';

class ThemeManagerState extends Equatable {
  final ThemeMode mode;

  final AppTheme theme;

  const ThemeManagerState({this.mode = ThemeMode.light, required this.theme});

  @override
  List<Object> get props => [mode, theme];

  ThemeManagerState copyWith({ThemeMode? mode, AppTheme? theme}) {
    return ThemeManagerState(
        theme: theme ?? this.theme, mode: mode ?? this.mode);
  }
}
