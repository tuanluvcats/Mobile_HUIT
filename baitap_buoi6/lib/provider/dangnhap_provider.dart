import 'package:flutter/material.dart';
import '../database/db_dangnhap.dart';
import '../model/dangnhap.dart';

class AuthProvider extends ChangeNotifier {
  Future<bool> registerUser(String email, String password) async {
    try {
      await DatabaseHelper().register(User(email: email, password: password));
      return true;
    } catch (e) {
      return false; // Thất bại (ví dụ: trùng email)
    }
  }

  // Hàm xử lý Đăng nhập
  Future<User?> loginUser(String email, String password) async {
    return await DatabaseHelper().login(email, password);
  }
}
