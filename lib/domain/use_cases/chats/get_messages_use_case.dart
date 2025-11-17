import '../../../data/models/message_entity.dart';
import '../../repositories/chat_repository.dart';

class GetMessagesUseCase {
  ChatRepository repository;
  GetMessagesUseCase(this.repository);
  Stream<List<MessageEntity>> call(String chatRoomId) {
    return repository.getMessages(chatRoomId);
  }
}
