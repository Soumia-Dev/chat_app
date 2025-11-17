import '../../../data/models/user_model.dart';
import '../../repositories/user_repository.dart';

class GetUsersUseCase {
  final UserRepository repository;
  GetUsersUseCase(this.repository);

  Stream<List<UserModel>> call() {
    return repository.getAllUsers();
  }
}
