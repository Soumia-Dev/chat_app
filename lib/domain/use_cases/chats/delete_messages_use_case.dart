import '../../repositories/chat_repository.dart';

class DeleteMessagesUseCase {
  ChatRepository repository;
  DeleteMessagesUseCase(this.repository);
  Future<void> call(String chatRoomId, Set<String> messagesId) {
    return repository.deleteMessages(chatRoomId, messagesId);
  }
}
