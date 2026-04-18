import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/dangnhap_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Email",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(hintText: "Value"),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Password",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: _passController,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: "Value"),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Nút Đăng nhập
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                      ),
                      onPressed: () async {
                        final user = await context
                            .read<AuthProvider>()
                            .loginUser(
                              _emailController.text,
                              _passController.text,
                            );
                        if (user != null) {
                          _showMessage("Đăng nhập thành công!");
                        } else {
                          _showMessage("Sai Email hoặc Mật khẩu!");
                        }
                      },
                      child: const Text(
                        "Sign in",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                      ),
                      onPressed: () async {
                        bool ok = await context
                            .read<AuthProvider>()
                            .registerUser(
                              _emailController.text,
                              _passController.text,
                            );
                        if (ok)
                          _showMessage("Đăng ký tài khoản thành công!");
                        else
                          _showMessage("Email đã tồn tại!");
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
