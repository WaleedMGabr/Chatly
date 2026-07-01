// Defines the abstract ChatRepository interface for the domain layer.
// Declares messaging operations (loading and sending messages) using domain
// entities, keeping the domain free from Firebase dependencies.

import 'package:chat_app/domain/entities/message_entity.dart';

abstract class ChatRepository {
  Stream<List<MessageEntity>> loadMessages(String chatID);

  Future<void> sendMessage({
    required String chatID,
    required String msgText,
    required String currentUserId,
    required String otherUserId,
  });
}
