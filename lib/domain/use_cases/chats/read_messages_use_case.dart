import '../../repositories/chat_repository.dart';

class ReadMessagesUseCase {
  ChatRepository repository;
  ReadMessagesUseCase(this.repository);
  void call(String roomId) {
    repository.readMessages(roomId);
  }
}
