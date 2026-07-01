// Encapsulates the load user chats business operation.
// Delegates to UserChatRepository.loadUserChats() to provide a real-time
// stream of ChatOverviewEntity objects for chats the user participates in.

import 'package:chat_app/domain/entities/chat_overview_entity.dart';
import 'package:chat_app/domain/repositories/user_chat_repository.dart';

class LoadUserChatsUseCase {
  final UserChatRepository repository;

  LoadUserChatsUseCase(this.repository);

  Stream<List<ChatOverviewEntity>> call(String userId) {
    return repository.loadUserChats(userId);
  }
}
