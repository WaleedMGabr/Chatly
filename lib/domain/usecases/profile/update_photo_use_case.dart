import 'package:chat_app/domain/repositories/profile_repository.dart';

class UpdatePhotoUseCase {
  final ProfileRepository repository;

  UpdatePhotoUseCase(this.repository);

  Future<void> call(String base64Image) {
    return repository.updatePhoto(base64Image);
  }
}
