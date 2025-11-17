import '../../../data/dataSources/data_source.dart';

class GetLanguageUseCase {
  final LocalDataSourceImpl repository;
  GetLanguageUseCase(this.repository);

  Future<String> call() {
    return repository.getSavedLanguage();
  }
}
