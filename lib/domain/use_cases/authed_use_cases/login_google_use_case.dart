import '../../repositories/authed_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginGoogleUseCase {
  final AuthedRepository authedRepository;
  LoginGoogleUseCase(this.authedRepository);
  Future<UserCredential?> call(String email) {
    return authedRepository.loginWithGoogle(email);
  }
}
