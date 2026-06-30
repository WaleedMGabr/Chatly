import 'package:chat_app/domain/repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  Future<void> call(String email, String password, String username) {
    return repository.signup(email, password, username);
  }
}
