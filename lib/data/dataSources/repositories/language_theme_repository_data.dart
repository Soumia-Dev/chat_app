abstract class LocalRepositoryData {
  Future<void> changeLanguage(String code);
  Future<String> getSavedLanguage();
  Future<void> setEnabledNotification(bool value);
  Future<bool> getNotificationValue();
}
