import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'pick_file.dart';
import 'package:firebase_core/firebase_core.dart';
import 'save_video.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAu23ybVDhJ53wssEkZ0EYBoM1ZzqkCdbU",
          appId: "1:769166688892:android:1816b86eac0018c4913ff9",
          projectId: "task1-6467b",
          messagingSenderId: "69166688892",
          storageBucket: "task1-6467b.appspot.com"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Myhomepage(),
    );
  }
}

class Myhomepage extends StatefulWidget {
  const Myhomepage({super.key});

  @override
  State<Myhomepage> createState() => _MyhomepageState();
}

class _MyhomepageState extends State<Myhomepage> {
  String? _errorMessage;
  String? _videoURL;
  VideoPlayerController? _controller;
  String? _downloadURL;
   
  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("video upload"),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      body: Center(
          child: _videoURL != null
              ? _videoPreviewWidget()
              : const Text("Select The Video")),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickVideo,
        child: const Icon(Icons.video_library),
      ),
    );
  }

  void _pickVideo() async {
    _videoURL = await pickVideo();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.file(File(_videoURL!))
      ..initialize().then((_) {
        setState(() {});
        _controller!.play();
      });
  }

  Widget _videoPreviewWidget() {
    if (_controller != null) {
      return Column(
        children: [
          AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!),
          ),
          ElevatedButton(
            onPressed: () {
              if (_isVideoSizeValid()) {
                _uploadVideo();
              } else {
                setState(() {
                  _errorMessage = "Error: Video size exceeds 10MB limit";
                });
              }
            },
            child: const Text("Upload"),
          ),
          if (_errorMessage != null)
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
        ],
      );
    } else {
      return const CircularProgressIndicator();
    }
  }
   bool _isVideoSizeValid() {
    if (_videoURL != null) {
      File videoFile = File(_videoURL!);
      int fileSizeInBytes = videoFile.lengthSync();
      int fileSizeInMB = fileSizeInBytes ~/ (1024 * 1024);
      return fileSizeInMB <= 10;
    } else {
      print("Error: No video selected");
      return false;
    }
  }

  void _uploadVideo() async {
    if (_videoURL != null) {
      _downloadURL = await StoreData().uploadVideo(_videoURL!);
      await StoreData().saveVideoData(_downloadURL!);
      setState(() {
        _videoURL = null;
        _errorMessage = null; 
      });
    } else {
      setState(() {
        _errorMessage = "Error: No video selected";
      });
    }
  }
}

 

