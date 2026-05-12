import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api.dart'; // Ensure this points to your http://10.0.2.2:5000/api
import '../Models/user_model.dart';

class AuthService {
  // Login Function
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final url = Uri.parse("${ApiConfig.baseUrl}/auth/login");
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      ).timeout(const Duration(seconds: 10));

      return jsonDecode(res.body);
    } catch (e) {
      return {"success": false, "message": "Login failed: $e"};
    }
  }

  // Signup Function - THIS SAVES TO YOUR DATABASE
  static Future<Map<String, dynamic>> register(UserModel user) async {
    try {
      final url = Uri.parse("${ApiConfig.baseUrl}/auth/signup");

      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toJson()),
      ).timeout(const Duration(seconds: 10));

      return jsonDecode(res.body);
    } catch (e) {
      print("Network Error: $e");
      return {"success": false, "message": "Could not connect to database server"};
    }
  }
}