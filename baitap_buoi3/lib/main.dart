import 'package:flutter/material.dart';

import 'TTSinhVien.dart';
import 'HienThiDeTai.dart';
import 'HienThiSanPham.dart';
import 'GioiThieuKhoaCNTT.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bài tập Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),

      // home: const TTSinhVien(),
      // home: const HienThiDeTai(),
      // home: const HienThiSanPham(),
      home: const GioiThieuKhoaCNTT(),
    );
  }
}
