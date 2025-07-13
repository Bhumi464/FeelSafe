import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'location_service.dart';

class SMSService {
  static Future<void> sendSOSMessage() async {
    final prefs = await SharedPreferences.getInstance();
    final contacts = prefs.getStringList('trusted_contacts') ?? [];

    if (contacts.isEmpty) {
      print("No trusted contacts found.");
      return;
    }

    final locationLink = await LocationService.getLocationLink();
    final message = Uri.encodeComponent("🚨 I need help! Here's my location: $locationLink");

    for (String contact in contacts) {
      final smsUri = Uri.parse('sms:$contact?body=$message');
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      } else {
        print("Could not launch SMS intent for $contact");
      }
    }
  }
}
