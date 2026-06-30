import 'package:chat_app/core/utils/constants.dart';
import 'package:chat_app/data/models/user_model.dart';
import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:chat_app/domain/repositories/profile_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseProfileRepository implements ProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Stream<UserEntity> getProfile() {
    final uid = _auth.currentUser!.uid;
    return _firestore
        .collection(FirestoreCollections.users)
        .doc(uid)
        .snapshots()
        .map((doc) => UserModel.fromFirestore(doc).toEntity());
  }

  @override
  Future<void> updateName(String name) async {
    final uid = _auth.currentUser!.uid;
    await _firestore
        .collection(FirestoreCollections.users)
        .doc(uid)
        .update({'name': name});
  }

  @override
  Future<void> updatePhoto(String base64Image) async {
    final uid = _auth.currentUser!.uid;
    await _firestore
        .collection(FirestoreCollections.users)
        .doc(uid)
        .update({'photoBase64': base64Image});
  }
}
