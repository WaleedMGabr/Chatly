// Defines the ChatOverviewEntity, a pure Dart class representing a chat summary
// shown in the home screen's chat list. Contains the other participant's info
// and the last message preview without any framework-specific dependencies.

class ChatOverviewEntity {
  final String chatId;
  final String otherUid;
  final String otherName;
  final String lastMessage;
  final DateTime? lastMessageTime;

  const ChatOverviewEntity({
    required this.chatId,
    required this.otherUid,
    required this.otherName,
    required this.lastMessage,
    this.lastMessageTime,
  });
}
