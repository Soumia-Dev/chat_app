import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import '../../core/service/notification_service.dart';
import '../../domain/repositories/chat_repository.dart';
import '../models/chat_preview_entity.dart';
import '../models/message_entity.dart';

class ChatRepositoryImpl extends ChatRepository {
  @override
  Stream<List<ChatPreviewEntity>> getAllUserChats() {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    final chatRoomsStream = FirebaseFirestore.instance
        .collection("chatsRoom")
        .where("memberIds", arrayContains: currentUser)
        .orderBy("lastMessageTime", descending: true)
        .snapshots();
    return chatRoomsStream.switchMap((snapshot) {
      if (snapshot.docs.isEmpty) {
        return Stream.value([]);
      }
      final chatStreams = snapshot.docs.map((chatDoc) {
        final chatData = chatDoc.data();
        final memberIds = (chatData["memberIds"] as List);
        final friendId = memberIds.firstWhere((m) => m != currentUser);
        final friendStream = FirebaseFirestore.instance
            .collection("users")
            .doc(friendId)
            .snapshots();
        return friendStream.map((friendSnapshot) {
          final friendData = friendSnapshot.data() ?? {};
          return ChatPreviewEntity.fromJson(
            friendData,
            chatData,
            chatDoc.id,
            friendId,
          );
        });
      }).toList();

      return CombineLatestStream.list(chatStreams);
    });
  }

  @override
  Stream<List<MessageEntity>> getMessages(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection("chatsRoom")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) {
            return <MessageEntity>[];
          }
          return snapshot.docs
              .map((doc) => MessageEntity.fromJson(doc.data(), doc.id))
              .toList();
        });
  }

  @override
  Future<void> sendMessage(
    MessageEntity messageEntity,
    String senderName,
    String senderId,
  ) async {
    final ids = [messageEntity.senderId, messageEntity.receiverId];
    ids.sort();
    final chatRoomId = ids.join("_");
    final roomRef = FirebaseFirestore.instance
        .collection("chatsRoom")
        .doc(chatRoomId);
    final roomInfoGet = await roomRef.get();
    final roomInfoData = roomInfoGet.data() as Map<String, dynamic>;
    await roomRef
        .collection("messages")
        .add(MessageEntity.toJson(messageEntity));
    await roomRef.update({
      "lastMessage": messageEntity.text,
      "lastMessageTime": DateTime.now().millisecondsSinceEpoch,
      "from": {
        "id": messageEntity.senderId,
        "noReadMess": roomInfoData["from"]["noReadMess"] + 1,
      },
    });
    try {
      await NotificationService.sendNotification(
        token: messageEntity.friendFcmToken,
        senderId: senderId,
        title: senderName,
        body: messageEntity.text,
      );
    } catch (e) {
      //to do
    }
  }

  @override
  Future<void> readMessages(String roomId) async {
    final chatRoom = FirebaseFirestore.instance
        .collection("chatsRoom")
        .doc(roomId);
    await chatRoom.update({
      "from": {"noReadMess": 0},
    });
  }

  @override
  Future<void> deleteMessages(String chatRoomId, Set<String> messagesId) async {
    try {
      for (String id in messagesId) {
        await FirebaseFirestore.instance
            .collection("chatsRoom")
            .doc(chatRoomId)
            .collection("messages")
            .doc(id)
            .delete();
      }
    } catch (e) {
      //
    }
  }
}
