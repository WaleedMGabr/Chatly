// Defines the sealed UserChatState hierarchy used by UserChatCubit.
// States represent the chat list lifecycle: loading, loaded with a list
// of ChatOverviewEntity objects, or error with an error message.

part of 'user_chat_cubit.dart';

@immutable
sealed class UserChatState {}

final class UserChatLoading extends UserChatState {}

final class UserChatLoaded extends UserChatState {
  final List<ChatOverviewEntity> chats;

  UserChatLoaded({required this.chats});
}

final class UserChatError extends UserChatState {
  final String errorMsg;

  UserChatError({required this.errorMsg});
}
