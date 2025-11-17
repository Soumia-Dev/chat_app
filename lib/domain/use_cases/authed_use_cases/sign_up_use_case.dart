import '../../repositories/authed_repository.dart';

import '../../../data/models/user_model.dart';

class SignUpUseCase {
  final AuthedRepository authedRepository;
  SignUpUseCase(this.authedRepository);

  Future<void> call(UserModel userModel, String password) {
    return authedRepository.signUp(userModel, password);
  }
}
