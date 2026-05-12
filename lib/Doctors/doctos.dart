import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../user_provider.dart';
import '../config/api.dart';
import 'doctorsNav.dart';

class DoctorsPage extends StatefulWidget {
  const DoctorsPage({super.key});

  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  List appointments = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => fetchAppointments());
  }

  String _getMonthName(String dateString) {
    try {
      final parts = dateString.split('-');
      const months = [
        "JAN","FEB","MAR","APR","MAY","JUN",
        "JUL","AUG","SEP","OCT","NOV","DEC"
      ];
      int monthIndex = int.parse(parts[1]);
      return months[monthIndex - 1];
    } catch (e) {
      return "MAY";
    }
  }

  Future<void> fetchAppointments() async {
    try {
      final user = UserProvider.of(context).user;
      if (user == null) return;

      final res = await http.get(Uri.parse("${ApiConfig.baseUrl}/appointments"));
      final data = jsonDecode(res.body);

      if (mounted) {
        setState(() {
          if (data["success"] == true) {
            final List all = data["data"] ?? [];
            appointments = all.where((a) =>
            a["doctor_name"].toString().toLowerCase().trim() ==
                user.username.toLowerCase().trim()
            ).toList();
          }
          loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = UserProvider.of(context).user;

    return DocScaffold(
      currentIndex: 0,
      body: Container(
        color: const Color(0xFFF4F7FE),
        child: loading
            ? const Center(
            child: CircularProgressIndicator(color: Color(0xFF2D31FA)))
            : CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildHeader(user?.username ?? "Doctor"),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStats(),
                    const SizedBox(height: 30),

                    const Text(
                      "Today's Schedule",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B1E57),
                      ),
                    ),
                    const SizedBox(height: 15),

                    appointments.isEmpty
                        ? _emptyState()
                        : Column(
                      children: appointments
                          .map((e) => _appointmentCard(e))
                          .toList(),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader(String name) {
    return SliverAppBar(
      expandedHeight: 180,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1B1E57), Color(0xFF2D31FA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 60, 25, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Welcome back,",
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.7))),
                    Text("Dr. $name",
                        style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(Icons.calendar_today,
                      color: Colors.white),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= STATS =================
  Widget _buildStats() {
    return Row(
      children: [
        Expanded(child: _statCard("Total", appointments.length.toString(), Icons.event, const Color(0xFF2D31FA))),
        const SizedBox(width: 10),
        Expanded(child: _statCard("Confirmed",
            appointments.where((a) => a["status"] == "Confirmed").length.toString(),
            Icons.check_circle, Colors.teal)),
        const SizedBox(width: 10),
        Expanded(child: _statCard("Pending",
            appointments.where((a) => a["status"] == "Pending").length.toString(),
            Icons.access_time, Colors.orange)),
      ],
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 10),
          Text(value,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color)),
          const SizedBox(height: 4),
          Text(title,
              style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  // ================= APPOINTMENT CARD =================
  Widget _appointmentCard(Map appt) {
    String status = appt["status"] ?? "Pending";

    Color statusColor = status == "Confirmed"
        ? Colors.teal
        : (status == "Rejected" ? Colors.redAccent : Colors.orange);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: statusColor.withOpacity(0.1),
            child: Text(
              (appt["patient_name"] ?? "P")[0],
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(appt["patient_name"] ?? "Patient",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B1E57))),
                const SizedBox(height: 4),
                Text(appt["reason"] ?? "Consultation",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade600)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(appt["time"] ?? "09:00",
                        style: const TextStyle(fontSize: 12)),
                  ],
                )
              ],
            ),
          ),

          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // ================= EMPTY =================
  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        children: [
          Icon(Icons.event_busy, size: 70, color: Colors.grey.shade300),
          const SizedBox(height: 20),
          const Text("No Appointments Yet",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey)),
          const SizedBox(height: 6),
          const Text("Your schedule is clear for today",
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}