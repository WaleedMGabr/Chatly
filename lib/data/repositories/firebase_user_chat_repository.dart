// Firebase implementation of the domain UserChatRepository interface.
// Provides a real-time stream of chat overviews where the user is a participant,
// resolving other participant names from Firestore and converting to ChatOverviewEntity.

import 'package:chat_app/core/utils/constants.dart';
import 'package:chat_app/data/models/chat_overview_model.dart';
import 'package:chat_app/domain/entities/chat_overview_entity.dart';
import 'package:chat_app/domain/repositories/user_chat_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUserChatRepository implements UserChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<ChatOverviewEntity>> loadUserChats(String userId) {
    return _firestore
        .collection(FirestoreCollections.chats)
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      List<ChatOverviewModel> chatList = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final List participants = data['participants'] ?? [];
        String otherUid =
            participants.firstWhere((id) => id != userId, orElse: () => '');

        if (otherUid.isEmpty && participants.isNotEmpty) {
          otherUid = participants[0];
        }

        String otherName = otherUid;
        if (otherUid.isNotEmpty) {
          try {
            final userDoc = await _firestore
                .collection(FirestoreCollections.users)
                .doc(otherUid)
                .get();
            if (userDoc.exists) {
              final userData = userDoc.data()!;
              otherName = userData['name'] ?? otherUid;
            }
          } catch (_) {}
        }

        final timestamp = data['lastMessageTime'] as Timestamp?;

        chatList.add(ChatOverviewModel(
          chatId: doc.id,
          otherUid: otherUid,
          otherName: otherName,
          lastMessage: data['lastMessage'] ?? '',
          lastMessageTime: timestamp?.toDate(),
        ));
      }

      return chatList.map((model) => model.toEntity()).toList();
    });
  }
}
