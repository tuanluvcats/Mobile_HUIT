import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/api_constants.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/Auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': _emailController.text}),
      );

      if (!mounted) return;
      if (response.statusCode == 200) {
        _showDialog("Thành công", "Vui lòng kiểm tra email để lấy lại mật khẩu", isSuccess: true);
      } else {
        _showDialog("Lỗi", "Email không tồn tại trong hệ thống!");
      }
    } catch (e) {
      if (mounted) _showDialog("Lỗi", "Đã xảy ra lỗi: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showDialog(String title, String message, {bool isSuccess = false}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              if (isSuccess) Navigator.pop(context);
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quên mật khẩu', style: TextStyle(color: Colors.white)), backgroundColor: Colors.blue.shade700, iconTheme: const IconThemeData(color: Colors.white)),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.blue.shade700, Colors.blue.shade300])),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/logo.png', height: 80, width: 80, errorBuilder: (c, e, s) => const Icon(Icons.school, size: 60, color: Colors.blue)),
                      const SizedBox(height: 16),
                      Text("Quên mật khẩu", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue.shade800)),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(labelText: "Nhập Email đăng ký", prefixIcon: Icon(Icons.email, color: Colors.blue.shade800), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0))),
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Vui lòng nhập email";
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return "Email không hợp lệ";
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity, height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _resetPassword,
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade800, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
                          child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Lấy lại mật khẩu", style: TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}