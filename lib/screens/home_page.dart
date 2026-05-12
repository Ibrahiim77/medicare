import 'package:flutter/material.dart';
import '../main_screen.dart';
import '../appointments_provider.dart';
import '../user_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppointmentProvider.of(context).refreshAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = UserProvider.of(context).user;
    final String loginName = (user?.username ?? "").toLowerCase().trim();
    final allAppointments = AppointmentProvider.of(context).appointments;

    // Filter and Sort Logic
    final List<Appointment> upcoming = allAppointments
        .where((appt) => appt.patientName.toLowerCase().trim() == loginName)
        .toList();

    upcoming.sort((a, b) {
      DateTime dateA = DateTime.tryParse(a.date) ?? DateTime(2099);
      DateTime dateB = DateTime.tryParse(b.date) ?? DateTime(2099);
      return dateA.compareTo(dateB);
    });

    final limited = upcoming.take(2).toList();

    return MainScaffold(
      currentIndex: 0,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
                // --- Modern Header ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Welcome back,", style: TextStyle(color: Colors.blueGrey.shade400, fontSize: 14)),
                        Text(
                          user?.username ?? 'MediCare User',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                      ],
                    ),
                    const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.notifications_none, color: Colors.blue),
                    )
                  ],
                ),

                const SizedBox(height: 25),
                _buildPromoCard(),

                const SizedBox(height: 30),
                const Text("Quick Services", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _serviceItem(Icons.medical_services, "Doctor", Colors.blue),
                    _serviceItem(Icons.science, "Lab", Colors.orange),
                    _serviceItem(Icons.local_hospital, "Clinic", Colors.green),
                    _serviceItem(Icons.healing, "Emergency", Colors.pink),
                  ],
                ),

                const SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Next Appointments", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    if (upcoming.length > 2)
                      TextButton(onPressed: () {}, child: const Text("See All")),
                  ],
                ),
                const SizedBox(height: 10),

                // --- Improved Appointment List ---
                if (limited.isEmpty)
                  _buildEmptyState()
                else
                  ...limited.map((appt) => _buildCompactAppointmentCard(appt)),

                const SizedBox(height: 30), // Bottom breathing room
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPromoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade400],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: const Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Health Insurance", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                SizedBox(height: 5),
                Text("Renew your plan today and get 20% discount on labs.", style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          Icon(Icons.shield, size: 50, color: Colors.white24),
        ],
      ),
    );
  }

  Widget _serviceItem(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.blueGrey)),
      ],
    );
  }

  Widget _buildCompactAppointmentCard(Appointment appt) {
    DateTime dt = DateTime.tryParse(appt.date) ?? DateTime.now();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Colored Status Indicator
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: Colors.blue.shade400,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
              ),
            ),
            // Info Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Dr. ${appt.doctorName}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        Text(appt.time, style: TextStyle(color: Colors.blue.shade700, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Patient: ${appt.patientName}",
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontStyle: FontStyle.italic),
                    ),
                    const Divider(height: 16),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade400),
                        const SizedBox(width: 5),
                        Text("${dt.day} ${_weekday(dt.weekday)}", style: const TextStyle(fontSize: 12, color: Colors.black87)),
                        const SizedBox(width: 15),
                        Icon(Icons.info_outline, size: 14, color: Colors.grey.shade400),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            appt.reason,
                            style: const TextStyle(fontSize: 12, color: Colors.black87),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Icon(Icons.calendar_today_outlined, color: Colors.grey.shade300, size: 40),
          const SizedBox(height: 10),
          const Text("No upcoming schedule", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  String _weekday(int d) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[(d - 1).clamp(0, 6)];
  }
}