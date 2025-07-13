import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static Future<Position?> getCurrentLocation() async {
    final status = await Permission.location.request();

    if (status.isDenied || status.isPermanentlyDenied) {
      return Future.error('Location permission denied');
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  static Future<String> getLocationLink() async {
    try {
      final pos = await getCurrentLocation();
      if (pos == null) return "Location unavailable";

      return "https://maps.google.com/?q=${pos.latitude},${pos.longitude}";
    } catch (e) {
      return "Unable to retrieve location: $e";
    }
  }
}
