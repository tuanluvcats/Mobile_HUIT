import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/api_constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passwordCtrl.text != _confirmPassCtrl.text) {
      _showDialog("Lỗi", "Mật khẩu nhập lại không khớp!");
      return;
    }
    setState(() => _isLoading = true);  
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/Auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': _fullNameCtrl.text,
          'username': _usernameCtrl.text,
          'password': _passwordCtrl.text,
          'phoneNumber': _phoneCtrl.text,
          'address': _addressCtrl.text,
          'email': _emailCtrl.text,
          'dateOfBirth': _dobCtrl.text,
        }),
      );
      if (!mounted) return;
      if (response.statusCode == 200) {
        _showDialog("Thành công", "Đăng ký thành công. Vui lòng đăng nhập.", isSuccess: true);
      } else {
        _showDialog("Lỗi", "Tên đăng nhập hoặc email đã tồn tại!");
      }
    } catch (e) {
      if (mounted) _showDialog("Lỗi", "Đã xảy ra lỗi kết nối: $e");
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


  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false, String? Function(String?)? validator, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        readOnly: onTap != null,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue.shade800),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        validator: validator ?? (value) => value == null || value.isEmpty ? "Vui lòng nhập $label" : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng ký', style: TextStyle(color: Colors.white)), backgroundColor: Colors.blue.shade700, iconTheme: const IconThemeData(color: Colors.white)),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.blue.shade700, Colors.blue.shade300])),
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
                  children: [
                    Image.asset('assets/images/logo.jpg', height: 80, width: 80, errorBuilder: (c, e, s) => const Icon(Icons.school, size: 60, color: Colors.blue)),
                    const SizedBox(height: 16),
                    Text("Tạo tài khoản", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue.shade800)),
                    const SizedBox(height: 24),
                    
                    _buildTextField(_fullNameCtrl, "Họ và tên", Icons.person),
                    _buildTextField(_usernameCtrl, "Tên đăng nhập", Icons.person_outline),
                    _buildTextField(_passwordCtrl, "Mật khẩu", Icons.lock, isPassword: true, validator: (v) {
                      if (v == null || v.isEmpty) return "Vui lòng nhập mật khẩu";
                      if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$').hasMatch(v)) {
                        return "Mật khẩu phải chứa chữ cái, số và ký tự đặc biệt";
                      }
                      return null;
                    }),
                    _buildTextField(_confirmPassCtrl, "Nhập lại mật khẩu", Icons.lock_outline, isPassword: true),
                    _buildTextField(_phoneCtrl, "Số điện thoại", Icons.phone, validator: (v) {
                      if (v == null || v.isEmpty) return "Vui lòng nhập số điện thoại";
                      if (!RegExp(r'^[0-9]{10}$').hasMatch(v)) return "Số điện thoại không hợp lệ";
                      return null;
                    }),
                    _buildTextField(_addressCtrl, "Địa chỉ", Icons.home),
                    _buildTextField(_emailCtrl, "Email", Icons.email, validator: (v) {
                      if (v == null || v.isEmpty) return "Vui lòng nhập email";
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return "Email không hợp lệ";
                      return null;
                    }),
                    _buildTextField(_dobCtrl, "Ngày sinh (yyyy-MM-dd)", Icons.calendar_today, onTap: () async {
                      final picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now());

                      if (picked != null) _dobCtrl.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                    }),

                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity, height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _register,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade800, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
                        child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Đăng ký", style: TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity, height: 50,
                      child: ElevatedButton(
                        onPressed: () => _formKey.currentState!.reset(),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade600, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
                        child: const Text("Reset", style: TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}