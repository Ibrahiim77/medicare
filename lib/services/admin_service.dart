import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api.dart';

class AdminService {
  // ✅ FIXED: Returns Map so UI can read res["data"]
  static Future<Map<String, dynamic>> getDoctors() async {
    try {
      final res = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/doctors"),
        headers: {"Content-Type": "application/json"},
      );
      return jsonDecode(res.body);
    } catch (e) {
      return {"success": false, "data": [], "message": e.toString()};
    }
  }

  static Future<Map<String, dynamic>> getAdmins() async {
    try {
      final res = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/admins"),
        headers: {"Content-Type": "application/json"},
      );
      return jsonDecode(res.body);
    } catch (e) {
      return {"success": false, "data": []};
    }
  }

  static Future<Map<String, dynamic>> getAppointments() async {
    try {
      final res = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/appointments"),
        headers: {"Content-Type": "application/json"},
      );
      return jsonDecode(res.body);
    } catch (e) {
      return {"success": false, "data": []};
    }
  }

  static Future<Map<String, dynamic>> addAdmin(
      String name,
      String email,
      String password,
      ) async {
    try {
      final res = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/admins"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": name,
          "email": email,
          "password": password,
          "role": "admin",
        }),
      );
      return jsonDecode(res.body);
    } catch (e) {
      return {"success": false, "message": "Network error"};
    }
  }
}