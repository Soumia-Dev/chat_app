part of 'theme_lang_bloc.dart';

class ThemeLanguageState {
  final Locale language;
  final ThemeMode themeMode;
  final bool isEnabledNotification;
  const ThemeLanguageState({
    required this.language,
    required this.themeMode,
    required this.isEnabledNotification,
  });

  ThemeLanguageState copyWith({
    Locale? language,
    ThemeMode? themeMode,
    bool? isEnabledNotification,
  }) {
    return ThemeLanguageState(
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
      isEnabledNotification:
          isEnabledNotification ?? this.isEnabledNotification,
    );
  }
}
