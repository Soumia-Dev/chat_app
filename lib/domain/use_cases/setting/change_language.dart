import '../../../../data/dataSources/data_source.dart';

class ChangeLanguageUseCase {
  final LocalDataSourceImpl repository;
  ChangeLanguageUseCase(this.repository);

  Future<void> call(String code) {
    return repository.changeLanguage(code);
  }
}
