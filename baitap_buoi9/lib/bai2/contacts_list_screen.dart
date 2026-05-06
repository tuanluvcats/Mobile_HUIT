import 'package:flutter/material.dart';
import 'package:flutter_contacts_service/flutter_contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'add_contact_screen.dart';

class ContactsListScreen extends StatefulWidget {
  const ContactsListScreen({super.key});

  @override
  State<ContactsListScreen> createState() => _ContactsListScreenState();
}

class _ContactsListScreenState extends State<ContactsListScreen> {
  List<ContactInfo> _contacts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initPermissionsAndLoad();
  }

  Future<void> _initPermissionsAndLoad() async {
    final statuses = await [Permission.contacts].request();
    if (statuses[Permission.contacts]!.isGranted) {
      _loadContacts();
    } else {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui long cap quyen danh ba!')),
      );
    }
  }

  Future<void> _loadContacts() async {
    setState(() {
      _isLoading = true;
    });

    List<ContactInfo> contacts = await FlutterContactsService.getContacts();
    setState(() {
      _contacts = contacts;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh ba'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddContactScreen(),
                ),
              );
              _loadContacts();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _contacts.isEmpty
          ? const Center(child: Text('Khong co danh ba nao.'))
          : ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                ContactInfo contact = _contacts[index];
                return ListTile(
                  leading: contact.avatar != null
                      ? CircleAvatar(
                          backgroundImage: MemoryImage(contact.avatar!),
                        )
                      : const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(contact.displayName ?? 'Khong co ten'),
                  subtitle: Text(
                    '${(contact.phones != null && contact.phones!.isNotEmpty) ? contact.phones!.first.value ?? 'Khong co so' : 'Khong co so'}\n'
                    '${(contact.emails != null && contact.emails!.isNotEmpty) ? contact.emails!.first.value ?? 'Khong co email' : 'Khong co email'}',
                  ),
                );
              },
            ),
    );
  }
}
