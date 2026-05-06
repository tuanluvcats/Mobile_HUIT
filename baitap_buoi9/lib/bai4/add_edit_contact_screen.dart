import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'db_helper.dart';

class AddEditContactScreen extends StatefulWidget {
  final Map<String, dynamic>? contact;

  const AddEditContactScreen({super.key, this.contact});

  @override
  State<AddEditContactScreen> createState() => _AddEditContactScreenState();
}

class _AddEditContactScreenState extends State<AddEditContactScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _avatar;
  Uint8List? _existingAvatar;

  bool get _isEdit => widget.contact != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      _nameController.text = widget.contact!['name'] ?? '';
      _phoneController.text = widget.contact!['phone'] ?? '';
      _emailController.text = widget.contact!['email'] ?? '';
      _existingAvatar = widget.contact!['avatar'];
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _avatar = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveContact() async {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ten va so dien thoai khong duoc de trong!'),
        ),
      );
      return;
    }

    Uint8List? avatarBytes;
    if (_avatar != null) {
      avatarBytes = await _avatar!.readAsBytes();
    } else if (_existingAvatar != null) {
      avatarBytes = _existingAvatar;
    }

    final contact = {
      'name': _nameController.text,
      'phone': _phoneController.text,
      'email': _emailController.text,
      'avatar': avatarBytes,
    };

    if (_isEdit) {
      await DBHelper().updateContact(widget.contact!['id'], contact);
    } else {
      await DBHelper().insertContact(contact);
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isEdit ? 'Da cap nhat danh ba!' : 'Da luu danh ba!'),
      ),
    );
    Navigator.pop(context);
  }

  ImageProvider? _avatarImage() {
    if (_avatar != null) return FileImage(_avatar!);
    if (_existingAvatar != null) return MemoryImage(_existingAvatar!);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final hasAvatar = _avatar != null || _existingAvatar != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Sua danh ba' : 'Them danh ba'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _pickImage(ImageSource.gallery),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _avatarImage(),
                child: !hasAvatar
                    ? const Icon(Icons.camera_alt, size: 50)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Ten'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'So dien thoai'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveContact,
              child: const Text('Luu'),
            ),
          ],
        ),
      ),
    );
  }
}
