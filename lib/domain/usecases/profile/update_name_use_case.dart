import 'package:chat_app/domain/repositories/profile_repository.dart';

class UpdateNameUseCase {
  final ProfileRepository repository;

  UpdateNameUseCase(this.repository);

  Future<void> call(String name) {
    return repository.updateName(name);
  }
}
