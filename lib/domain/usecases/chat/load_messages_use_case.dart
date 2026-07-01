// Encapsulates the load messages business operation.
// Delegates to ChatRepository.loadMessages() to provide a real-time stream
// of MessageEntity objects for a given chat.

import 'package:chat_app/domain/entities/message_entity.dart';
import 'package:chat_app/domain/repositories/chat_repository.dart';

class LoadMessagesUseCase {
  final ChatRepository repository;

  LoadMessagesUseCase(this.repository);

  Stream<List<MessageEntity>> call(String chatID) {
    return repository.loadMessages(chatID);
  }
}
