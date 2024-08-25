import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<DocumentSnapshot<Object?>> getUsername({
  required username,
}) async {
  DocumentReference user = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid);
  DocumentSnapshot _username = await user.get();
  username = _username;
  return username;
}

Future<DocumentSnapshot<Object?>> getDisplayName({
  required displayName,
}) async {
  DocumentReference user = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid);
  DocumentSnapshot _displayName = await user.get();
  displayName = _displayName;
  return displayName;
}
