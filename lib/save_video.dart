import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

class StoreData {
  Future<String> uploadVideo(String videoURL) async {
    Reference ref = _storage.ref().child('videos/${DateTime.now()}.mp4');
    await ref.putFile(File(videoURL));
    String downloadURl = await ref.getDownloadURL();
    return downloadURl;
  }

  Future<void> saveVideoData(String videoDownloadUrl) async {
    await _fireStore.collection('video').add({
      'url': videoDownloadUrl,
      'timeStamp': FieldValue.serverTimestamp(),
      'name': 'user video'
    });
  }
}
