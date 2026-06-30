import 'package:chat_app/core/utils/constants.dart';
import 'package:chat_app/domain/repositories/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _firestore
        .collection(FirestoreCollections.users)
        .doc(_auth.currentUser!.uid)
        .update({'isOnline': true});
  }

  @override
  Future<void> signup(String email, String password, String username) async {
    final userCred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = userCred.user!.uid;

    await _firestore.collection(FirestoreCollections.users).doc(uid).set({
      'email': email,
      'name': username,
      'photoBase64': '',
      'isOnline': false,
    });
  }

  @override
  Future<void> logout() async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      await _firestore
          .collection(FirestoreCollections.users)
          .doc(uid)
          .update({'isOnline': false});
    }
    await _auth.signOut();
  }
}
