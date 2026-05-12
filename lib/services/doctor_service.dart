import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api.dart';

class DoctorService {

  // GET DOCTORS
  static Future<Map<String, dynamic>> getDoctors() async {
    final res = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/doctors"),
      headers: {"Content-Type": "application/json"},
    );

    return jsonDecode(res.body);
  }

  // ADD DOCTOR (FIXED FOR YOUR BACKEND)
  static Future<Map<String, dynamic>> addDoctor({
    required String email,
    required String password,
    required String specialty,
  }) async {
    final res = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/doctors"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
        "specialty": specialty,
      }),
    );

    return jsonDecode(res.body);
  }
}