import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/appointment_service.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAppointments();
    });
  }

  Future<void> fetchAppointments() async {
    try {
      final user = UserProvider.of(context).user;

      if (user == null) {
        debugPrint("ERROR: No user found in Provider");
        if (mounted) setState(() => loading = false);
        return;
      }

      final res = await AppointmentService.getAppointments();

      if (mounted) {
        setState(() {
          if (res["success"] == true) {
            final List allData = res["data"] ?? [];

            // FILTER: Case-insensitive match for incoming doctors
            appointments = allData.where((appt) {
              final dbDoc = (appt["doctor_name"] ?? "").toString().toLowerCase().trim();
              final loginDoc = user.username.toLowerCase().trim();
              return dbDoc == loginDoc;
            }).toList();
          }
          loading = false;
        });
      }
    } catch (e) {
      debugPrint("Fetch Appointments Error: $e");
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> handleUpdateStatus(dynamic appt, String status) async {
    try {
      debugPrint("Full Row Map Target Payload: $appt");

      // Fallback extraction check: handles both 'id' and 'appointment_id'
      final dynamic rawId = appt["id"] ?? appt["appointment_id"];

      if (rawId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error: ID field missing in database payload structure")),
        );
        return;
      }

      final int parsedId = int.parse(rawId.toString());
      setState(() => loading = true);

      // Calls the service layer which handles network delivery
      final res = await AppointmentService.updateStatus(parsedId, status);

      if (res["success"] == true) {
        await fetchAppointments(); // Reload list to instantly reflect change
      } else {
        if (mounted) {
          setState(() => loading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to update status: ${res['message'] ?? 'Database error'}")),
          );
        }
      }
    } catch (e) {
      debugPrint("Update Flow Crash Catch: $e");
      if (mounted) setState(() => loading = false);
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
    Color statusColor = Colors.orange; // Pending status color
    if (appt["status"] == "Confirmed") statusColor = Colors.green;
    if (appt["status"] == "Cancelled") statusColor = Colors.red;

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
                      onPressed: () => handleUpdateStatus(appt, "Confirmed"),
                      child: const Text("Confirm", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      // Sending "Cancelled" directly aligns with your MySQL Enum allowed properties!
                      onPressed: () => handleUpdateStatus(appt, "Cancelled"),
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