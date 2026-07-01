import 'package:chat_app/data/repositories/firebase_auth_repository.dart';
import 'package:chat_app/data/repositories/firebase_profile_repository.dart';
import 'package:chat_app/data/repositories/firebase_user_chat_repository.dart';
import 'package:chat_app/data/repositories/firebase_user_repository.dart';
import 'package:chat_app/domain/usecases/auth/logout_use_case.dart';
import 'package:chat_app/domain/usecases/profile/get_profile_use_case.dart';
import 'package:chat_app/domain/usecases/profile/update_name_use_case.dart';
import 'package:chat_app/domain/usecases/profile/update_photo_use_case.dart';
import 'package:chat_app/domain/usecases/user/get_users_use_case.dart';
import 'package:chat_app/domain/usecases/user_chat/load_user_chats_use_case.dart';
import 'package:chat_app/presentation/cubits/profile/profile_cubit.dart';
import 'package:chat_app/presentation/cubits/user_chat/user_chat_cubit.dart';
import 'package:chat_app/presentation/cubits/users/users_cubit.dart';
import 'package:chat_app/presentation/screens/home/home_screen.dart';
import 'package:chat_app/presentation/screens/profile/profile_screen.dart';
import 'package:chat_app/presentation/screens/users/users_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  final _titles = ['Chatly', 'People', 'Profile'];

  late final LogoutUseCase _logoutUseCase;

  @override
  void initState() {
    super.initState();
    final authRepo = FirebaseAuthRepository();
    _logoutUseCase = LogoutUseCase(authRepo);
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userChatRepo = FirebaseUserChatRepository();
    final userRepo = FirebaseUserRepository();
    final profileRepo = FirebaseProfileRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final cubit = UserChatCubit(loadUserChatsUseCase: LoadUserChatsUseCase(userChatRepo));
            cubit.loadUserChats(uid);
            return cubit;
          },
        ),
        BlocProvider(
          create: (_) => UsersCubit(getUsersUseCase: GetUsersUseCase(userRepo), currentUserUid: uid)..loadUsers(),
        ),
        BlocProvider(
          create: (_) => ProfileCubit(
            getProfileUseCase: GetProfileUseCase(profileRepo),
            updateNameUseCase: UpdateNameUseCase(profileRepo),
            updatePhotoUseCase: UpdatePhotoUseCase(profileRepo),
          )..loadProfile(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Image.asset("assets/photos/Chatly.png", width: 36, height: 36),
              const SizedBox(width: 8),
              Text(_titles[_currentIndex]),
            ],
          ),
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            const HomeScreen(),
            const UsersScreen(),
            ProfileScreen(logoutUseCase: _logoutUseCase),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.chat_rounded), activeIcon: Icon(Icons.chat), label: 'Chats'),
            BottomNavigationBarItem(icon: Icon(Icons.people_outline_rounded), activeIcon: Icon(Icons.people), label: 'People'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), activeIcon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
