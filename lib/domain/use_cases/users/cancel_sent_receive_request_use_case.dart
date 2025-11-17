import '../../../data/models/invitation_model.dart';
import '../../repositories/user_repository.dart';

class CancelSentReceiveRequestUseCase {
  final UserRepository repository;
  CancelSentReceiveRequestUseCase(this.repository);

  Future<void> call(InvitationModel invitationModel) {
    return repository.cancelSentReceiveRequest(invitationModel);
  }
}
