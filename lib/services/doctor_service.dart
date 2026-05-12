import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api.dart';

class DoctorService {
  // GET DOCTORS
  // Keep this exactly as is, but added a try-catch for safety
  static Future<Map<String, dynamic>> getDoctors() async {
    try {
      final res = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/api/doctors"),
        headers: {"Content-Type": "application/json"},
      );
      return jsonDecode(res.body);
    } catch (e) {
      return {"success": false, "message": "Error fetching doctors: $e"};
    }
  }

  // ADD DOCTOR (UPDATED)
  static Future<Map<String, dynamic>> addDoctor({
    required String name,      // New parameter
    required String email,
    required String password,
    required String specialty,
  }) async {
    try {
      final res = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/doctors"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": name,    // Mapping 'name' to 'username' for the backend
          "email": email,
          "password": password,
          "specialty": specialty,
        }),
      );

      return jsonDecode(res.body);
    } catch (e) {
      return {"success": false, "message": "Connection failed: $e"};
    }
  }
}