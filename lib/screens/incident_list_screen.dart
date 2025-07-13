// incident_list_screen.dart (Firebase removed, using SharedPreferences)
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class IncidentListScreen extends StatefulWidget {
  const IncidentListScreen({super.key});

  @override
  State<IncidentListScreen> createState() => _IncidentListScreenState();
}

class _IncidentListScreenState extends State<IncidentListScreen> {
  List<Map<String, dynamic>> _incidents = [];

  @override
  void initState() {
    super.initState();
    _loadIncidents();
  }

  Future<void> _loadIncidents() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList('incidents') ?? [];
    setState(() {
      _incidents = rawList.map((e) => json.decode(e) as Map<String, dynamic>).toList();
    });
  }

  Future<void> _saveIncidents() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = _incidents.map((e) => json.encode(e)).toList();
    await prefs.setStringList('incidents', encoded);
  }

  void _showEditDialog(int index) {
    final incident = _incidents[index];
    final TextEditingController typeController = TextEditingController(text: incident['type']);
    final TextEditingController descController = TextEditingController(text: incident['description']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Incident"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: typeController,
              decoration: const InputDecoration(labelText: 'Type'),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                _incidents[index]['type'] = typeController.text.trim();
                _incidents[index]['description'] = descController.text.trim();
              });
              await _saveIncidents();
              Navigator.pop(context);
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  void _deleteIncident(int index) async {
    setState(() {
      _incidents.removeAt(index);
    });
    await _saveIncidents();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Incident deleted")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reported Incidents')),
      body: _incidents.isEmpty
          ? const Center(child: Text("No incidents reported."))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _incidents.length,
        itemBuilder: (context, index) {
          final incident = _incidents[index];
          final timestamp = DateTime.tryParse(incident['timestamp'] ?? '') ?? DateTime.now();
          final formattedTime = DateFormat.yMMMd().add_jm().format(timestamp);

          return Card(
            child: ListTile(
              title: Text(incident['type'] ?? 'Unknown Type'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(incident['description'] ?? 'No description'),
                  const SizedBox(height: 4),
                  Text(formattedTime, style: const TextStyle(fontSize: 12)),
                ],
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    _showEditDialog(index);
                  } else if (value == 'delete') {
                    _deleteIncident(index);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
