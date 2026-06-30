import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String photoBase64;
  final bool isOnline;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoBase64 = '',
    this.isOnline = false,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photoBase64: data['photoBase64'] ?? '',
      isOnline: data['isOnline'] ?? false,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      name: name,
      email: email,
      photoBase64: photoBase64,
      isOnline: isOnline,
    );
  }
}
