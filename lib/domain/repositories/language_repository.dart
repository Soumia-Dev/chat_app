import 'package:flutter/material.dart';

abstract class LanguageRepository {
  Future<void> changeLanguage(Locale locale);
  Future<Locale> getLanguage();
}
