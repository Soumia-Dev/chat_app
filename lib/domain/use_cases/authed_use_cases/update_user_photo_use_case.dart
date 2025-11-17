import '../../repositories/authed_repository.dart';

class UpdateUserPhotoUseCase {
  final AuthedRepository authedRepository;

  UpdateUserPhotoUseCase(this.authedRepository);

  Future<void> call(String userId, String base64Image) async {
    return authedRepository.updateUserPhoto(userId, base64Image);
  }
}
