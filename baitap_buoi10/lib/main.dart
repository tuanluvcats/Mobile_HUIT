import 'package:flutter/material.dart';
import 'bai1/bai1.dart';
import 'bai2/bai2.dart';
import 'bai3/bai3.dart';
import 'bai4/bai4.dart';
import 'bai5/bai5.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bai tap buoi 10',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
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
          'Tong hop bai tap - Buoi 10',
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
              title: 'Bai 1: Map + Vi tri hien tai',
              targetScreen: const Bai1App(),
            ),
            const SizedBox(height: 15),
            _buildMenuButton(
              context: context,
              title: 'Bai 2: Route Finder (lat, lng)',
              targetScreen: const Bai2App(),
            ),
            const SizedBox(height: 15),
            _buildMenuButton(
              context: context,
              title: 'Bai 3: Tap-pick + Distance/Time',
              targetScreen: const Bai3App(),
            ),
            const SizedBox(height: 15),
            _buildMenuButton(
              context: context,
              title: 'Bai 4: Geocoding + Phuong tien',
              targetScreen: const Bai4App(),
            ),
            const SizedBox(height: 15),
            _buildMenuButton(
              context: context,
              title: 'Bai 5: Tuyen duong yeu thich (SQLite)',
              targetScreen: const Bai5App(),
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
      width: 320,
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
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
