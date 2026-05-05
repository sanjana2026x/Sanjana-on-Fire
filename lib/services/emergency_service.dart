import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmergencyService {
  static const String _contactKey = 'emergency_contact';

  Future<void> saveContact(String number) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_contactKey, number);
  }

  Future<String?> getContact() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_contactKey);
  }

  Future<void> makeCall(String number) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: number,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> sendSMS(String number, String message) async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: number,
      queryParameters: <String, String>{
        'body': message,
      },
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }
  
  Future<void> launchEmergencyServices() async {
    // Default emergency number for Bangladesh is 999
    final Uri launchUri = Uri(scheme: 'tel', path: '999');
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }
}
