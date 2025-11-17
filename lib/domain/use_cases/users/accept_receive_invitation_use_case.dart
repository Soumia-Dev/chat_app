import '../../../data/models/invitation_model.dart';
import '../../repositories/user_repository.dart';

class AcceptReceiveInvitationUseCase {
  final UserRepository repository;
  AcceptReceiveInvitationUseCase(this.repository);

  Future<void> call(InvitationModel invitationModel) {
    return repository.acceptReceiveInvitation(invitationModel);
  }
}
