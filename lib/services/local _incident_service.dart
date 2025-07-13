import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/location_service.dart';

class LocalIncidentService {
  Future<void> reportIncident({
    required String type,
    required String description,
    bool isAnonymous = true,
  }) async {
    try {
      final Position? location = await LocationService.getCurrentLocation();
      if (location == null) throw Exception("Location not available");

      final incident = {
        'type': type,
        'description': description,
        'anonymous': isAnonymous,
        'latitude': location.latitude,
        'longitude': location.longitude,
        'timestamp': DateTime.now().toIso8601String(),
      };

      final prefs = await SharedPreferences.getInstance();
      final incidents = prefs.getStringList('incidents') ?? [];
      incidents.add(jsonEncode(incident));
      await prefs.setStringList('incidents', incidents);

      print("Incident saved locally.");
    } catch (e) {
      print("Error saving incident locally: $e");
    }
  }
}
