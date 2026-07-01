// Defines the sealed ChatState hierarchy used by ChatCubit.
// States represent the chat lifecycle: initial, loaded with a list
// of MessageEntity objects, or error with an error message.

part of 'chat_cubit.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatLoaded extends ChatState {
  final List<MessageEntity> messages;

  ChatLoaded({required this.messages});
}

final class ChatError extends ChatState {
  final String message;

  ChatError({required this.message});
}
