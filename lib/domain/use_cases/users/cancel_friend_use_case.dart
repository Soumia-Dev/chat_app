import '../../../data/models/invitation_model.dart';
import '../../repositories/user_repository.dart';

class CancelFriendUseCase {
  final UserRepository repository;
  CancelFriendUseCase(this.repository);

  Future<void> call(InvitationModel invitationModel) {
    return repository.cancelFriend(invitationModel);
  }
}
