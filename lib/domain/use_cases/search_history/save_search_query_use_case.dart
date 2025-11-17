import '../../repositories/search_repository.dart';

class SaveSearchQueryUseCase {
  final SearchRepository searchRepository;
  SaveSearchQueryUseCase({required this.searchRepository});
  Future<void> call(String query) {
    return searchRepository.saveQuery(query);
  }
}
