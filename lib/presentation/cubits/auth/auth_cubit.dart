import 'package:bloc/bloc.dart';
import 'package:chat_app/domain/usecases/auth/login_use_case.dart';
import 'package:chat_app/domain/usecases/auth/logout_use_case.dart';
import 'package:chat_app/domain/usecases/auth/signup_use_case.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;
  final LogoutUseCase logoutUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.signupUseCase,
    required this.logoutUseCase,
  }) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      await loginUseCase(email, password);
      emit(AuthSuccess("Successful Login."));
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-credential") {
        emit(AuthFailed("Wrong Password or Email"));
      } else {
        emit(AuthFailed(e.message ?? "Login Failed"));
      }
    } catch (e) {
      emit(AuthFailed(e.toString()));
    }
  }

  Future<void> signup(String email, String password, String username) async {
    emit(AuthLoading());
    try {
      await signupUseCase(email, password, username);
      emit(AuthSuccess("Successful Sign Up"));
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-credential") {
        emit(AuthFailed("Wrong Password or Email"));
      } else {
        emit(AuthFailed(e.message ?? "Sign Up Failed"));
      }
    } catch (e) {
      emit(AuthFailed(e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      await logoutUseCase();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailed(e.toString()));
    }
  }
}
