import '../../repositories/authed_repository.dart';

class GetNumInvitationsUseCase {
  final AuthedRepository authedRepository;
  GetNumInvitationsUseCase(this.authedRepository);
  Stream<int> call() {
    return authedRepository.getNumInvitations();
  }
}
