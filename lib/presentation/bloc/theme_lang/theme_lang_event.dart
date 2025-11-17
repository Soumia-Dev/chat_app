part of 'theme_lang_bloc.dart';

@immutable
sealed class ThemeLanguageEvent {}

class ChangeLanguageEvent extends ThemeLanguageEvent {
  final String code;
  ChangeLanguageEvent({required this.code});
}

class ChangeThemeEvent extends ThemeLanguageEvent {
  final ThemeMode themeMode;
  ChangeThemeEvent({required this.themeMode});
}

class ChangeNotificationEvent extends ThemeLanguageEvent {
  final bool value;
  ChangeNotificationEvent({required this.value});
}
