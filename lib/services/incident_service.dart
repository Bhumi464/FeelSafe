import 'package:geolocator/geolocator.dart';
import 'location_service.dart';

class IncidentService {
  Future<void> reportIncident({
    required String type,
    required String description,
    bool isAnonymous = true,
  }) async {
    try {
      final Position? location = await LocationService.getCurrentLocation();
      if (location == null) throw Exception("Location not available");

      // Log or save the incident locally or remotely
      print("Incident reported:");
      print("Type: \$type");
      print("Description: \$description");
      print("Anonymous: \$isAnonymous");
      print("Latitude: \${location.latitude}");
      print("Longitude: \${location.longitude}");
      print("Timestamp: \${DateTime.now()}");

      // Optional: Save to local DB or send to backend

    } catch (e) {
      print("Error reporting incident: \$e");
    }
  }
}
