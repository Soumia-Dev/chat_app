import '../../repositories/search_repository.dart';

class ClearSearchHistoryUseCase {
  final SearchRepository searchRepository;
  ClearSearchHistoryUseCase({required this.searchRepository});

  Future<void> call() {
    return searchRepository.clearAllHistory();
  }
}
