import '../../repositories/search_repository.dart';

class ClearOneUseCase {
  final SearchRepository searchRepository;
  ClearOneUseCase({required this.searchRepository});
  Future<void> call(String docId) {
    return searchRepository.clearOne(docId);
  }
}
