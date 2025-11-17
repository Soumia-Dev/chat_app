import '../../repositories/authed_repository.dart';

class ResetPasswordUseCase {
  final AuthedRepository authedRepository;
  ResetPasswordUseCase(this.authedRepository);
  Future<void> call(String email) {
    return authedRepository.resetPassword(email);
  }
}
