import 'package:chat_app/core/theme/app_theme.dart';
import 'package:chat_app/core/utils/constants.dart';
import 'package:chat_app/data/repositories/firebase_auth_repository.dart';
import 'package:chat_app/domain/usecases/auth/login_use_case.dart';
import 'package:chat_app/domain/usecases/auth/logout_use_case.dart';
import 'package:chat_app/domain/usecases/auth/signup_use_case.dart';
import 'package:chat_app/presentation/cubits/auth/auth_cubit.dart';
import 'package:chat_app/presentation/cubits/theme/theme_cubit.dart';
import 'package:chat_app/presentation/screens/auth/login_screen.dart';
import 'package:chat_app/presentation/screens/auth/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authRepo = FirebaseAuthRepository();

  final loginUseCase = LoginUseCase(authRepo);
  final signupUseCase = SignupUseCase(authRepo);
  final logoutUseCase = LogoutUseCase(authRepo);

  runApp(
    BlocProvider(
      create: (_) => ThemeCubit(),
      child: MyApp(
        loginUseCase: loginUseCase,
        signupUseCase: signupUseCase,
        logoutUseCase: logoutUseCase,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;
  final LogoutUseCase logoutUseCase;

  const MyApp({
    super.key,
    required this.loginUseCase,
    required this.signupUseCase,
    required this.logoutUseCase,
  });

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;

    return MaterialApp(
      title: 'Chatly',
      debugShowCheckedModeBanner: false,
      routes: {
        AppRoutes.login: (context) => BlocProvider(
              create: (_) => AuthCubit(loginUseCase: loginUseCase, signupUseCase: signupUseCase, logoutUseCase: logoutUseCase),
              child: const LoginScreen(),
            ),
        AppRoutes.signup: (context) => BlocProvider(
              create: (_) => AuthCubit(loginUseCase: loginUseCase, signupUseCase: signupUseCase, logoutUseCase: logoutUseCase),
              child: const SignupScreen(),
            ),
      },
      initialRoute: AppRoutes.login,
      theme: ChatAppTheme.lightTheme,
      darkTheme: ChatAppTheme.darkTheme,
      themeMode: themeMode,
    );
  }
}
