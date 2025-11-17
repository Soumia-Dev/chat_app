import 'message_entity.dart';

class ChatPreviewEntity {
  final String chatRoomId;
  final String friendId;
  final String friendFcmToken;
  final String friendFullName;
  final String friendPhotoUrl;
  final bool isOnline;
  final DateTime lastSeen;
  final String lastMessage;
  final DateTime lastMessageTime;
  Stream<List<MessageEntity>>? messages;
  final int noReadFrom;
  final bool isFriend;

  ChatPreviewEntity({
    required this.chatRoomId,
    required this.friendId,
    required this.friendFcmToken,
    required this.friendFullName,
    this.friendPhotoUrl = "",
    required this.isOnline,
    required this.lastSeen,
    required this.lastMessage,
    required this.lastMessageTime,
    this.messages,
    required this.noReadFrom,
    required this.isFriend,
  });

  factory ChatPreviewEntity.fromJson(
    Map<String, dynamic> json,
    Map<String, dynamic> chatData,
    String chatId,
    String friendId,
  ) {
    return ChatPreviewEntity(
      chatRoomId: chatId,
      friendId: friendId,
      friendFcmToken: json["fcmToken"],
      friendFullName: json["fullName"] ?? "Unknown",
      friendPhotoUrl: json["photoUrl"] ?? "",
      isOnline: json["isOnline"],
      lastSeen: json["lastSeen"].toDate(),
      lastMessage: chatData["lastMessage"] ?? "",
      lastMessageTime: DateTime.fromMillisecondsSinceEpoch(
        chatData["lastMessageTime"],
      ),
      noReadFrom: chatData["from"]["id"] == friendId
          ? (chatData["from"]["noReadMess"] ?? 0)
          : 0,
      isFriend: chatData['isFriend'],
    );
  }
}
