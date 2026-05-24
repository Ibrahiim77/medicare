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
      ).timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
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
  static Future<Map<String, dynamic>> bookAppointment(Map<String, dynamic> data) async {
    try {
      final res = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/appointments"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 10));
      return jsonDecode(res.body);
    } catch (e) {
      print("Service Error (POST): $e");
      return {"success": false, "message": "Booking failed"};
    }
  }

  // UPDATE STATUS
  static Future<Map<String, dynamic>> updateStatus(int id, String status) async {
    try {
      final url = Uri.parse("${ApiConfig.baseUrl}/appointments/$id");
      print("Sending PUT Request to: $url with status: $status");

      final res = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"status": status}),
      ).timeout(const Duration(seconds: 10));

      return jsonDecode(res.body);
    } catch (e) {
      print("Service Error (PUT): $e");
      return {"success": false, "message": "Network error updating status"};
    }
  }
}