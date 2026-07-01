// Firestore-specific data model for a chat message document.
// Handles serialization (fromFirestore/toMap) and provides toEntity()
// to convert to the domain-layer MessageEntity for use in business logic.

import 'package:chat_app/domain/entities/message_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String sender;
  final String msgText;
  final DateTime? msgTime;

  const MessageModel({
    required this.sender,
    required this.msgText,
    this.msgTime,
  });

  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final timestamp = data['msgTime'] as Timestamp?;
    return MessageModel(
      sender: data['sender'] ?? '',
      msgText: data['msgText'] ?? '',
      msgTime: timestamp?.toDate(),
    );
  }

  MessageEntity toEntity() {
    return MessageEntity(
      sender: sender,
      msgText: msgText,
      msgTime: msgTime,
    );
  }
}
