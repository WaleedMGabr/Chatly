import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:chat_app/domain/usecases/user/get_users_use_case.dart';
import 'package:meta/meta.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  final GetUsersUseCase getUsersUseCase;
  final String? currentUserUid;
  StreamSubscription? _subscription;

  List<UserEntity> _allUsers = [];
  String _currentQuery = '';

  UsersCubit({
    required this.getUsersUseCase,
    this.currentUserUid,
  }) : super(UsersInitial());

  void loadUsers() {
    emit(UsersLoading());
    try {
      _subscription?.cancel();
      _subscription = getUsersUseCase().listen(
        (users) {
          _allUsers = users.where((u) => u.uid != currentUserUid).toList();
          _emitFiltered();
        },
        onError: (e) {
          emit(UsersError(message: e.toString()));
        },
      );
    } catch (e) {
      emit(UsersError(message: e.toString()));
    }
  }

  void searchUsers(String query) {
    _currentQuery = query.toLowerCase();
    _emitFiltered();
  }

  void _emitFiltered() {
    if (_currentQuery.isEmpty) {
      emit(UsersLoaded(users: _allUsers));
    } else {
      final filtered = _allUsers
          .where((u) =>
              u.name.toLowerCase().contains(_currentQuery) ||
              u.email.toLowerCase().contains(_currentQuery))
          .toList();
      emit(UsersLoaded(users: filtered));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
