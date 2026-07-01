// Encapsulates the send message business operation.
// Delegates to ChatRepository.sendMessage() to send a text message within
// a chat, creating the chat document if it does not exist.

import 'package:chat_app/domain/repositories/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  Future<void> call({
    required String chatID,
    required String msgText,
    required String currentUserId,
    required String otherUserId,
  }) {
    return repository.sendMessage(
      chatID: chatID,
      msgText: msgText,
      currentUserId: currentUserId,
      otherUserId: otherUserId,
    );
  }
}
