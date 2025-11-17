import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../domain/use_cases/setting/change_language.dart';
import '../../../domain/use_cases/setting/set_notification.dart';

part 'theme_lang_event.dart';
part 'theme_lang_state.dart';

class ThemeLanguageBloc extends Bloc<ThemeLanguageEvent, ThemeLanguageState> {
  final ChangeLanguageUseCase changeLanguageUseCase;
  final SetNotificationUseCase setNotificationUseCase;
  ThemeLanguageBloc({
    required this.changeLanguageUseCase,
    required this.setNotificationUseCase,
    required ThemeMode initialMode,
    required Locale initialLanguage,
    required bool initialNotification,
  }) : super(
         ThemeLanguageState(
           language: initialLanguage,
           themeMode: initialMode,
           isEnabledNotification: initialNotification,
         ),
       ) {
    on<ChangeLanguageEvent>((event, emit) async {
      await changeLanguageUseCase(event.code);
      emit(state.copyWith(language: Locale(event.code)));
    });

    on<ChangeThemeEvent>((event, emit) {
      if (event.themeMode == ThemeMode.light) {
        emit(state.copyWith(themeMode: ThemeMode.dark));
      } else {
        emit(state.copyWith(themeMode: ThemeMode.light));
      }
    });

    on<ChangeNotificationEvent>((event, emit) async {
      await setNotificationUseCase(event.value);
      emit(state.copyWith(isEnabledNotification: event.value));
    });
  }
}
