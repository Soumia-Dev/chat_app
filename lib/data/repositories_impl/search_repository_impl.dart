import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/repositories/search_repository.dart';
import '../models/search_query_model.dart';

class SearchRepositoryImpl implements SearchRepository {
  final FirebaseFirestore firestore;
  final String uId;
  SearchRepositoryImpl({required this.firestore, required this.uId});

  @override
  Future<void> saveQuery(String query) async {
    final historyRef = firestore
        .collection("users")
        .doc(uId)
        .collection("searchHistory");

    final existing = await historyRef.where("query", isEqualTo: query).get();

    if (existing.docs.isEmpty) {
      await historyRef.add({
        "query": query,
        "createdAt": FieldValue.serverTimestamp(),
      });
    } else {
      await existing.docs.first.reference.update({
        "createdAt": FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Stream<List<SearchQueryModel>> getHistory() {
    return firestore
        .collection("users")
        .doc(uId)
        .collection("searchHistory")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => SearchQueryModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  @override
  Future<void> clearAllHistory() async {
    final data = await firestore
        .collection("users")
        .doc(uId)
        .collection("searchHistory")
        .get();
    for (var doc in data.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Future<void> clearOne(String docId) {
    return firestore
        .collection("users")
        .doc(uId)
        .collection("searchHistory")
        .doc(docId)
        .delete();
  }
}
