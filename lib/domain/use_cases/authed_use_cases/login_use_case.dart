import '../../repositories/authed_repository.dart';

class LoginUseCase {
  final AuthedRepository authedRepository;
  LoginUseCase(this.authedRepository);
  Future<void> call(String email, String password) {
    return authedRepository.login(email, password);
  }
}
