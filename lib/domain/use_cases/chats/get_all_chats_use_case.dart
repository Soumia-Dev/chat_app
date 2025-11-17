import '../../../data/models/chat_preview_entity.dart';
import '../../repositories/chat_repository.dart';

class GetAllChatsUseCase {
  ChatRepository repository;
  GetAllChatsUseCase(this.repository);
  Stream<List<ChatPreviewEntity>> call() {
    return repository.getAllUserChats();
  }
}
