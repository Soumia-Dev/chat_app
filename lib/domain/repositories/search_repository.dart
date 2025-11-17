import '../../data/models/search_query_model.dart';

abstract class SearchRepository {
  Future<void> saveQuery(String query);
  Stream<List<SearchQueryModel>> getHistory();
  Future<void> clearAllHistory();
  Future<void> clearOne(String docId);
}
