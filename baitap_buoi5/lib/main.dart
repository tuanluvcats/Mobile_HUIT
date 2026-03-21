import 'package:flutter/material.dart';

import 'listdemo.dart';
import 'layoutmomo.dart';
import 'layoutqua.dart';
import 'muabandienthoai.dart';

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
          'Tổng hợp Bài tập Flutter',
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
              title: 'Bài 1: ListView Demo',
              targetScreen: const Listdemo(),
            ),
            const SizedBox(height: 15),

            _buildMenuButton(
              context: context,
              title: 'Bài 2: Layout MoMo',
              targetScreen: const LayoutMoMo(),
            ),
            const SizedBox(height: 15),

            _buildMenuButton(
              context: context,
              title: 'Bài 3: Quà của Tuấn',
              targetScreen: const Layoutqua(),
            ),
            const SizedBox(height: 15),

            _buildMenuButton(
              context: context,
              title: 'Bài 4: Mua bán điện thoại',
              targetScreen: const WelcomeScreen(),
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
      width: 250,
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
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
