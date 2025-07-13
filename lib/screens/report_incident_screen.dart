import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';

class ReportIncidentScreen extends StatefulWidget {
  const ReportIncidentScreen({super.key});

  @override
  State<ReportIncidentScreen> createState() => _ReportIncidentScreenState();
}

class _ReportIncidentScreenState extends State<ReportIncidentScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedType = 'Harassment';
  bool _isAnonymous = true;

  final List<String> _incidentTypes = [
    'Harassment',
    'Stalking',
    'Assault',
    'Eve Teasing',
    'Other'
  ];

  Future<void> _submitIncident() async {
    final description = _descriptionController.text.trim();
    if (description.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final List<String> existingData = prefs.getStringList('incidents') ?? [];

    Position? position;
    try {
      bool locationService = await Geolocator.isLocationServiceEnabled();
      if (locationService) {
        final permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.denied) {
          position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );
        }
      }
    } catch (_) {}

    final incident = {
      'type': _selectedType,
      'description': description,
      'anonymous': _isAnonymous,
      'timestamp': DateTime.now().toIso8601String(),
      'latitude': position?.latitude,
      'longitude': position?.longitude,
    };

    existingData.add(json.encode(incident));
    await prefs.setStringList('incidents', existingData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Incident reported successfully.')),
    );

    _descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report Incident')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedType,
              items: _incidentTypes.map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) => setState(() => _selectedType = value!),
              decoration: const InputDecoration(labelText: 'Incident Type'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Describe the incident',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: _isAnonymous,
                  onChanged: (val) => setState(() => _isAnonymous = val!),
                ),
                const Text('Report anonymously'),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: ElevatedButton(
                onPressed: _submitIncident,
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
