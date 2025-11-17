import 'package:cloud_firestore/cloud_firestore.dart';

class MessageEntity {
  final String? id;
  final String senderId;
  final String receiverId;
  final String friendFcmToken;
  final String text;
  final DateTime dateTime;

  const MessageEntity({
    this.id,
    required this.senderId,
    required this.receiverId,
    required this.friendFcmToken,
    required this.text,
    required this.dateTime,
  });

  factory MessageEntity.fromJson(Map<String, dynamic> json, String docId) {
    return MessageEntity(
      id: docId,
      senderId: json["senderId"],
      receiverId: json["receiverId"],
      friendFcmToken: json["friendFcmToken"],
      text: json["text"],
      dateTime: (json["createdAt"] as Timestamp).toDate(),
    );
  }
  static Map<String, dynamic> toJson(MessageEntity messageEntity) {
    return {
      "senderId": messageEntity.senderId,
      "receiverId": messageEntity.receiverId,
      "friendFcmToken": messageEntity.friendFcmToken,
      "text": messageEntity.text,
      "createdAt": Timestamp.fromDate(messageEntity.dateTime),
    };
  }
}
