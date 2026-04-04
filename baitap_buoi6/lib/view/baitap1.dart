import 'package:flutter/material.dart';
import 'package:baitap_buoi6/provider/sinhvien_provider.dart';
import '../model/sinhvien.dart';

void _showAddSinhVienDialog(
  BuildContext context,
  SinhVienProvider sinhVienProvider,
) {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Thêm Sinh Viên"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Tên Sinh Viên"),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () {
              String name = nameController.text.trim();
              String email = emailController.text.trim();
              if (name.isNotEmpty && email.isNotEmpty) {
                sinhVienProvider.addSinhVien(
                  SinhVien(name: name, email: email),
                );
                Navigator.pop(context);
              }
            },
            child: Text("Lưu"),
          ),
        ],
      );
    },
  );
}
