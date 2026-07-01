// Defines the MessageEntity, a pure Dart class representing a single chat message.
// Contains no framework-specific imports and is used by the presentation layer
// to display message data independently of the data source.

class MessageEntity {
  final String sender;
  final String msgText;
  final DateTime? msgTime;

  const MessageEntity({
    required this.sender,
    required this.msgText,
    this.msgTime,
  });
}
