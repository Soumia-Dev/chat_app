import '../../repositories/authed_repository.dart';

class ChangeUserInformationUseCase {
  late final AuthedRepository authedRepository;
  ChangeUserInformationUseCase(this.authedRepository);
  Future<void> call(String type, String value) {
    return authedRepository.changeUserInformation(type, value);
  }
}
