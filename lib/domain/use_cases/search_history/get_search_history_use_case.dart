import '../../../data/models/search_query_model.dart';
import '../../repositories/search_repository.dart';

class GetSearchHistoryUseCase {
  final SearchRepository searchRepository;
  GetSearchHistoryUseCase({required this.searchRepository});
  Stream<List<SearchQueryModel>> call() {
    return searchRepository.getHistory();
  }
}
