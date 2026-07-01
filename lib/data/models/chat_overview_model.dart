// Data model for a chat overview used to display chat list items.
// Provides toEntity() to convert to the domain-layer ChatOverviewEntity
// for use in business logic and presentation.

import 'package:chat_app/domain/entities/chat_overview_entity.dart';

class ChatOverviewModel {
  final String chatId;
  final String otherUid;
  final String otherName;
  final String lastMessage;
  final DateTime? lastMessageTime;

  ChatOverviewModel({
    required this.chatId,
    required this.otherUid,
    required this.otherName,
    required this.lastMessage,
    this.lastMessageTime,
  });

  ChatOverviewEntity toEntity() {
    return ChatOverviewEntity(
      chatId: chatId,
      otherUid: otherUid,
      otherName: otherName,
      lastMessage: lastMessage,
      lastMessageTime: lastMessageTime,
    );
  }
}
