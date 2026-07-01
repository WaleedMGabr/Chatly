// Manages chat message state using LoadMessagesUseCase and SendMessageUseCase.
// Subscribes to a real-time message stream for a given chat and emits
// ChatState changes as messages arrive or errors occur.

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/domain/entities/message_entity.dart';
import 'package:chat_app/domain/usecases/chat/load_messages_use_case.dart';
import 'package:chat_app/domain/usecases/chat/send_message_use_case.dart';
import 'package:meta/meta.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final LoadMessagesUseCase loadMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;
  StreamSubscription? _subscription;

  ChatCubit({
    required this.loadMessagesUseCase,
    required this.sendMessageUseCase,
  }) : super(ChatInitial());

  Future<void> sendMessage({
    required String chatID,
    required String msgText,
    required String currentUserId,
    required String otherUserId,
  }) async {
    try {
      await sendMessageUseCase(
        chatID: chatID,
        msgText: msgText,
        currentUserId: currentUserId,
        otherUserId: otherUserId,
      );
    } catch (e) {
      emit(ChatError(message: e.toString()));
    }
  }

  void loadMessages(String chatID) {
    try {
      _subscription?.cancel();
      _subscription = loadMessagesUseCase(chatID).listen(
        (messages) {
          emit(ChatLoaded(messages: messages));
        },
        onError: (e) {
          emit(ChatError(message: e.toString()));
        },
      );
    } catch (e) {
      emit(ChatError(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
