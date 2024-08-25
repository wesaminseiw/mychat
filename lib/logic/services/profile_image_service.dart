import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

Future<void> pickImageService({
  required ImagePicker picker,
  required FirebaseAuth auth,
  required Function(String?) onImageUrlChanged,
}) async {
  try {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File image = File(pickedFile.path);
      await uploadImageService(
        auth: auth,
        image: image,
        onImageUrlChanged: onImageUrlChanged,
      );
    }
  } catch (e) {
    print('Error picking image: $e');
  }
}

Future<void> uploadImageService({
  required File image,
  required FirebaseAuth auth,
  required Function(String?) onImageUrlChanged,
}) async {
  try {
    final User? user = auth.currentUser;
    if (user == null) return;

    final String uid = user.uid;
    final storageRef = FirebaseStorage.instance.ref().child(
          'uploads/$uid/profile_image_${DateTime.now().toIso8601String()}',
        );

    final uploadTask = storageRef.putFile(image);
    final snapshot = await uploadTask.whenComplete(() {});

    final downloadUrl = await snapshot.ref.getDownloadURL();

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'profileImageUrl': downloadUrl,
    }, SetOptions(merge: true));

    onImageUrlChanged(downloadUrl);

    print('Uploaded image URL: $downloadUrl');
  } catch (e) {
    print('Error uploading image: $e');
  }
}

Future<void> loadProfileImage({
  required FirebaseAuth auth,
  required Function(String?) onImageUrlLoaded,
}) async {
  final User? user = auth.currentUser;
  if (user != null) {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    if (doc.exists && doc.data()!.containsKey('profileImageUrl')) {
      onImageUrlLoaded(doc['profileImageUrl']);
    } else {
      onImageUrlLoaded(null);
    }
  }
}
