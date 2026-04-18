import 'package:flutter/material.dart';
import 'bai1/bai1.dart';
import 'bai2/bai2.dart';
import 'bai3/bai3.dart';
import 'bai4/bai4.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tổng hợp bài tập',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildMenuButton(
              context: context,
              title: 'Bài 1: Media Picker App',
              targetScreen: const MediaPickerApp(),
            ),
            const SizedBox(height: 15),
            _buildMenuButton(
              context: context,
              title: 'Bài 2: Photo Capture & Preview',
              targetScreen: const PhotoCaptureApp(),
            ),
            const SizedBox(height: 15),
            _buildMenuButton(
              context: context,
              title: 'Bài 3: Video Recorder & Playback',
              targetScreen: const VideoRecorderApp(),
            ),
            const SizedBox(height: 15),
            _buildMenuButton(
              context: context,
              title: 'Bài 4: Simple Audio Player',
              targetScreen: const SimpleAudioPlayer(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required BuildContext context,
    required String title,
    required Widget targetScreen,
  }) {
    return SizedBox(
      width: 280,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 3,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetScreen),
          );
        },
        child: Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
