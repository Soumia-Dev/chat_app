import 'package:cloud_firestore/cloud_firestore.dart';

class InvitationModel {
  final String fromId;
  final String toId;
  final Timestamp? createdAt;

  InvitationModel({
    required this.fromId,
    required this.toId,
    this.createdAt,
  });

  factory InvitationModel.fromMap(
      String fromId, String toId, Map<String, dynamic> map) {
    return InvitationModel(
      fromId: fromId,
      toId: toId,
      createdAt: map['createdAt'] as Timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "createdAt": FieldValue.serverTimestamp(),
    };
  }
}
