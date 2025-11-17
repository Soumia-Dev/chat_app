import '../../../data/models/user_model.dart';
import '../../repositories/authed_repository.dart';

class GetCurrentUserUserCase {
  late final AuthedRepository authedRepository;
  GetCurrentUserUserCase(this.authedRepository);
  Stream<UserModel> call() {
    return authedRepository.getCurrentUser();
  }
}
