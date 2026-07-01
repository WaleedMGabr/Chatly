// Manages the user's chat list state using LoadUserChatsUseCase.
// Subscribes to a real-time stream of ChatOverviewEntity objects and
// supports client-side search filtering by chat name or last message.

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/domain/entities/chat_overview_entity.dart';
import 'package:chat_app/domain/usecases/user_chat/load_user_chats_use_case.dart';
import 'package:meta/meta.dart';

part 'user_chat_state.dart';

class UserChatCubit extends Cubit<UserChatState> {
  final LoadUserChatsUseCase loadUserChatsUseCase;
  StreamSubscription? _subscription;

  List<ChatOverviewEntity> _allChats = [];
  String _currentQuery = '';

  UserChatCubit({required this.loadUserChatsUseCase})
      : super(UserChatLoading());

  void loadUserChats(String userId) {
    try {
      _subscription?.cancel();
      _subscription = loadUserChatsUseCase(userId).listen(
        (chats) {
          _allChats = chats;
          _emitFiltered();
        },
        onError: (e) {
          emit(UserChatError(errorMsg: e.toString()));
        },
      );
    } catch (e) {
      emit(UserChatError(errorMsg: e.toString()));
    }
  }

  void searchChats(String query) {
    _currentQuery = query.toLowerCase();
    _emitFiltered();
  }

  void _emitFiltered() {
    if (_currentQuery.isEmpty) {
      emit(UserChatLoaded(chats: _allChats));
    } else {
      final filtered = _allChats
          .where((c) =>
              c.otherName.toLowerCase().contains(_currentQuery) ||
              c.lastMessage.toLowerCase().contains(_currentQuery))
          .toList();
      emit(UserChatLoaded(chats: filtered));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
