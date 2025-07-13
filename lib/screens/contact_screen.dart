// contact_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef Contact = Map<String, String>;

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final List<Contact> _contacts = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactList = prefs.getStringList('trusted_contacts_data') ?? [];
    setState(() {
      _contacts.clear();
      for (String entry in contactList) {
        final parts = entry.split('|');
        if (parts.length == 2) {
          _contacts.add({'name': parts[0], 'phone': parts[1]});
        }
      }
    });
  }

  Future<void> _saveContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactList = _contacts.map((e) => '${e['name']}|${e['phone']}').toList();
    await prefs.setStringList('trusted_contacts_data', contactList);
    await prefs.setStringList('trusted_contacts', _contacts.map((e) => e['phone']!).toList());
  }

  void _addContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Trusted Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _nameController.clear();
              _phoneController.clear();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_nameController.text.isNotEmpty && _phoneController.text.isNotEmpty) {
                setState(() {
                  _contacts.add({
                    'name': _nameController.text.trim(),
                    'phone': _phoneController.text.trim(),
                  });
                });
                await _saveContacts();
                Navigator.pop(context);
                _nameController.clear();
                _phoneController.clear();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _deleteContact(int index) async {
    setState(() {
      _contacts.removeAt(index);
    });
    await _saveContacts();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trusted Contacts')),
      body: _contacts.isEmpty
          ? const Center(child: Text("No contacts added yet."))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          final contact = _contacts[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.contact_phone),
              title: Text(contact['name']!),
              subtitle: Text(contact['phone']!),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteContact(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addContactDialog,
        child: const Icon(Icons.add),
        tooltip: 'Add Contact',
      ),
    );
  }
}