import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:chat_app/domain/repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Stream<UserEntity> call() {
    return repository.getProfile();
  }
}
