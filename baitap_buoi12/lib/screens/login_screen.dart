import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/api_constants.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/Auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameController.text,
          'password': _passwordController.text,
        }),
      );
      if (!mounted) return;
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(userID: responseData['userID'])),
        );
      } else {
        _showErrorDialog("Tên đăng nhập hoặc mật khẩu không đúng");
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog("Lỗi kết nối máy chủ: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Lỗi"),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("OK"))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.blue.shade700, Colors.blue.shade300])),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8.0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/logo.jpg', height: 100, width: 100, errorBuilder: (c, e, s) => const Icon(Icons.school, size: 80, color: Colors.blue)),
                      const SizedBox(height: 16.0),
                      Text("Đăng nhập", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue.shade800)),
                      const SizedBox(height: 24.0),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(labelText: "Tên đăng nhập", prefixIcon: Icon(Icons.person, color: Colors.blue.shade800), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0))),
                        validator: (value) => value == null || value.isEmpty ? "Vui lòng nhập tên đăng nhập" : null,
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(labelText: "Mật khẩu", prefixIcon: Icon(Icons.lock, color: Colors.blue.shade800), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0))),
                        validator: (value) => value == null || value.isEmpty ? "Vui lòng nhập mật khẩu" : null,
                      ),
                      const SizedBox(height: 24.0),
                      SizedBox(
                        width: double.infinity, height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade800, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
                          child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Đăng nhập", style: TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(onPressed: () => Navigator.pushNamed(context, '/forgot-password'), child: Text("Quên mật khẩu?", style: TextStyle(color: Colors.blue.shade800))),
                          TextButton(onPressed: () => Navigator.pushNamed(context, '/register'), child: Text("Đăng ký", style: TextStyle(color: Colors.blue.shade800))),
                        ],
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