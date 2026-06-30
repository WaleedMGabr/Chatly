// Defines the abstract UserChatRepository interface for the domain layer.
// Declares the operation for loading a user's chat list using domain entities,
// keeping the domain free from Firebase dependencies.

import 'package:chat_app/domain/entities/chat_overview_entity.dart';

abstract class UserChatRepository {
  Stream<List<ChatOverviewEntity>> loadUserChats(String userId);
}
