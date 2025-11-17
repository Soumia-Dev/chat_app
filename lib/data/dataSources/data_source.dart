import 'package:chatting_app/data/dataSources/repositories/language_theme_repository_data.dart';
import 'package:hive/hive.dart';

class LocalDataSourceImpl implements LocalRepositoryData {
  final Box box = Hive.box('settings');
  @override
  Future<void> changeLanguage(String code) async {
    await box.put('language_code', code);
  }

  @override
  Future<String> getSavedLanguage() async {
    return await box.get('language_code', defaultValue: 'en');
  }

  @override
  Future<void> setEnabledNotification(bool value) async {
    await box.put('notifications_enabled', value);
  }

  @override
  Future<bool> getNotificationValue() async {
    return await box.get('notifications_enabled', defaultValue: true);
  }
}
