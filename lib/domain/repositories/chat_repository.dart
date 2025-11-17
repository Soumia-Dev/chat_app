import '../../data/models/chat_preview_entity.dart';
import '../../data/models/message_entity.dart';

abstract class ChatRepository {
  Stream<List<ChatPreviewEntity>> getAllUserChats();
  Stream<List<MessageEntity>> getMessages(String chatRoomId);
  Future<void> sendMessage(
    MessageEntity messageEntity,
    String senderName,
    String senderId,
  );
  Future<void> readMessages(String roomId);
  Future<void> deleteMessages(String chatRoomId, Set<String> messagesId);
}
