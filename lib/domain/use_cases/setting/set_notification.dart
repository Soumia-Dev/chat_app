import '../../../../data/dataSources/data_source.dart';

class SetNotificationUseCase {
  final LocalDataSourceImpl repository;
  SetNotificationUseCase(this.repository);

  Future<void> call(bool value) {
    return repository.setEnabledNotification(value);
  }
}
