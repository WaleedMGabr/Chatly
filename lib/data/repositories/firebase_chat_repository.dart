// Firebase implementation of the domain ChatRepository interface.
// Handles loading messages as a real-time stream and sending messages
// to Firestore, converting between MessageModel and MessageEntity.

import 'package:chat_app/core/utils/constants.dart';
import 'package:chat_app/data/models/message_model.dart';
import 'package:chat_app/domain/entities/message_entity.dart';
import 'package:chat_app/domain/repositories/chat_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseChatRepository implements ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<MessageEntity>> loadMessages(String chatID) {
    return _firestore
        .collection(FirestoreCollections.chats)
        .doc(chatID)
        .collection(FirestoreCollections.messages)
        .orderBy('msgTime')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromFirestore(doc).toEntity())
            .toList());
  }

  @override
  Future<void> sendMessage({
    required String chatID,
    required String msgText,
    required String currentUserId,
    required String otherUserId,
  }) async {
    final chatRef =
        _firestore.collection(FirestoreCollections.chats).doc(chatID);
    final chatDoc = await chatRef.get();

    final messageData = {
      'sender': currentUserId,
      'msgText': msgText,
      'msgTime': FieldValue.serverTimestamp(),
    };

    if (!chatDoc.exists) {
      await chatRef.set({
        'participants': [currentUserId, otherUserId],
        'lastMessage': msgText,
        'lastMessageTime': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await chatRef
          .collection(FirestoreCollections.messages)
          .add(messageData);
    } else {
      await chatRef.collection(FirestoreCollections.messages).add(messageData);

      await chatRef.update({
        'lastMessage': msgText,
        'lastMessageTime': FieldValue.serverTimestamp(),
      });
    }
  }
}
