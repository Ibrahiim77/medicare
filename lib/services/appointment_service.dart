import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api.dart';

class AppointmentService {
  // GET ALL APPOINTMENTS
  static Future<Map<String, dynamic>> getAppointments() async {
    try {
      final res = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/appointments"),
        headers: {"Content-Type": "application/json"},
      );

      if (res.statusCode == 200) {
        // This decodes the { "success": true, "data": [...] } structure
        return jsonDecode(res.body);
      } else {
        return {"success": false, "message": "Server error", "data": []};
      }
    } catch (e) {
      print("Service Error (GET): $e");
      return {"success": false, "message": "Connection failed", "data": []};
    }
  }

  // BOOK APPOINTMENT
  static Future<Map<String, dynamic>> bookAppointment(
      Map<String, dynamic> data) async {
    try {
      final res = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/appointments"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      return jsonDecode(res.body);
    } catch (e) {
      print("Service Error (POST): $e");
      return {"success": false, "message": "Booking failed"};
    }
  }

  // UPDATE STATUS
  static Future<Map<String, dynamic>> updateStatus(int id, String status) async {
    try {
      final res = await http.put(
        Uri.parse("${ApiConfig.baseUrl}/appointments/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"status": status}),
      );
      return jsonDecode(res.body);
    } catch (e) {
      return {"success": false, "message": "Update failed"};
    }
  }
}