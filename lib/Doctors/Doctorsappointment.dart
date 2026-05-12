import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/api.dart';
import '../user_provider.dart';
import 'doctorsNav.dart';

class DocAppointmentsPage extends StatefulWidget {
  const DocAppointmentsPage({super.key});

  @override
  State<DocAppointmentsPage> createState() => _DocAppointmentsPageState();
}

class _DocAppointmentsPageState extends State<DocAppointmentsPage> {
  List appointments = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    // Use post-frame callback to ensure UserProvider is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAppointments();
    });
  }

  Future<void> fetchAppointments() async {
    try {
      final user = UserProvider.of(context).user;

      // SAFETY: If user is not logged in, stop loading immediately
      if (user == null) {
        debugPrint("ERROR: No user found in Provider");
        if (mounted) setState(() => loading = false);
        return;
      }

      final res = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/appointments"),
      ).timeout(const Duration(seconds: 10)); // Timeout prevent infinite hang

      final data = jsonDecode(res.body);

      if (mounted) {
        setState(() {
          if (data["success"] == true) {
            final List allData = data["data"] ?? [];

            // FILTER: Case-insensitive comparison of doctor_name
            appointments = allData.where((appt) {
              final dbDoc = (appt["doctor_name"] ?? "").toString().toLowerCase().trim();
              final loginDoc = user.username.toLowerCase().trim();
              return dbDoc == loginDoc;
            }).toList();
          }
          loading = false; // Successfully stop loading
        });
      }
    } catch (e) {
      debugPrint("Fetch Appointments Error: $e");
      if (mounted) {
        setState(() => loading = false); // Stop loading even if there's an error
      }
    }
  }

  Future<void> updateStatus(String id, String status) async {
    try {
      final res = await http.put(
        Uri.parse("${ApiConfig.baseUrl}/appointments/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"status": status}),
      );

      if (jsonDecode(res.body)["success"] == true) {
        fetchAppointments(); // Refresh data
      }
    } catch (e) {
      debugPrint("Update Status Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DocScaffold(
      currentIndex: 1,
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: fetchAppointments,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Appointments for ${UserProvider.of(context).user?.username ?? 'Doctor'}",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (appointments.isEmpty)
                const Expanded(
                  child: Center(child: Text("No appointments scheduled for you.")),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: appointments.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final appt = appointments[index];
                      return _buildAppointmentCard(appt);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(dynamic appt) {
    // Determine color based on status
    Color statusColor = Colors.orange;
    if (appt["status"] == "Confirmed") statusColor = Colors.green;
    if (appt["status"] == "Rejected") statusColor = Colors.red;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Text((appt["patient_name"] ?? "P")[0].toUpperCase()),
            ),
            title: Text(appt["patient_name"] ?? "Unknown Patient",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("${appt["date"]} • ${appt["time"]}\nReason: ${appt["reason"]}"),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(appt["status"], style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ),
          if (appt["status"] == "Pending")
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: () => updateStatus(appt["id"].toString(), "Confirmed"),
                      child: const Text("Confirm", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () => updateStatus(appt["id"].toString(), "Rejected"),
                      child: const Text("Reject", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}