import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:baitap_buoi6/provider/sinhvien_provider.dart';
import 'package:baitap_buoi6/view/v_sinhvien.dart';
import 'package:baitap_buoi6/provider/todo_provider.dart';
import 'package:baitap_buoi6/view/v_todo.dart';
import 'package:baitap_buoi6/provider/sanpham_provider.dart';
import 'package:baitap_buoi6/view/v_sanpham.dart';
import 'package:baitap_buoi6/provider/chitieu_provider.dart';
import 'package:baitap_buoi6/view/v_chitieu.dart';
import 'package:baitap_buoi6/provider/dangnhap_provider.dart';
import 'package:baitap_buoi6/view/v_dangnhap.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthScreen(),
      ),
    ),
  );
}
