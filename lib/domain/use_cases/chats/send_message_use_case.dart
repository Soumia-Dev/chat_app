import '../../../data/models/message_entity.dart';
import '../../repositories/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository repository;
  SendMessageUseCase(this.repository);

  Future<void> call(
    MessageEntity messageEntity,
    String senderName,
    String senderId,
  ) {
    return repository.sendMessage(messageEntity, senderName, senderId);
  }
}
