import 'package:cloud_firestore/cloud_firestore.dart';

class SearchQueryModel {
  final String id;
  final String query;
  final DateTime createdAt;

  SearchQueryModel({
    required this.id,
    required this.query,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "query": query,
      "createdAt": createdAt,
    };
  }

  factory SearchQueryModel.fromMap(Map<String, dynamic> map, String id) {
    return SearchQueryModel(
      id: id,
      query: map["query"] ?? "",
      createdAt: (map["createdAt"] as Timestamp).toDate(),
    );
  }
}
