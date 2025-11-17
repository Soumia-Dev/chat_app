import '../../../data/dataSources/data_source.dart';

class GetNotificationUseCase {
  final LocalDataSourceImpl repository;
  GetNotificationUseCase(this.repository);

  Future<bool> call() {
    return repository.getNotificationValue();
  }
}
