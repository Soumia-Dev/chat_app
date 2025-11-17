import '../../../data/models/invitation_model.dart';
import '../../repositories/user_repository.dart';

class SendFRequestUseCase {
  final UserRepository repository;
  SendFRequestUseCase(this.repository);

  Future<void> call(InvitationModel invitationModel) {
    return repository.sendFriendRequest(invitationModel);
  }
}
