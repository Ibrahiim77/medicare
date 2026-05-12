import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api.dart';

class AdminService {

  static Future<List<dynamic>> getDoctors() async {
    final res = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/doctors"),
      headers: {"Content-Type": "application/json"},
    );

    final data = jsonDecode(res.body);
    return List<dynamic>.from(data["data"] ?? []);
  }

  static Future<List<dynamic>> getAdmins() async {
    final res = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/admins"),
      headers: {"Content-Type": "application/json"},
    );

    final data = jsonDecode(res.body);
    return List<dynamic>.from(data["data"] ?? []);
  }

  static Future<List<dynamic>> getAppointments() async {
    final res = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/appointments"),
      headers: {"Content-Type": "application/json"},
    );

    final data = jsonDecode(res.body);
    return List<dynamic>.from(data["data"] ?? []);
  }

  // ✅ FIX ADDED HERE
  static Future<Map<String, dynamic>> addAdmin(
      String email,
      String password,
      ) async {
    final res = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/admins"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    return jsonDecode(res.body);
  }
}