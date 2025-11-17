import '../../repositories/authed_repository.dart';

class LogoutUseCase {
  final AuthedRepository authedRepository;
  LogoutUseCase(this.authedRepository);
  Future<void> call() {
    return authedRepository.logout();
  }
}
