import 'package:flutter/material.dart';
import '../main_screen.dart';
import '../services/appointment_service.dart';
import '../user_provider.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  List appointments = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadAppointments());
  }

  Future<void> loadAppointments() async {
    if (!mounted) return;
    setState(() => loading = true);

    try {
      final user = UserProvider.of(context).user;
      final String loginName = (user?.username ?? "").toLowerCase().trim();
      final res = await AppointmentService.getAppointments();

      if (mounted) {
        setState(() {
          final List allData = res["data"] ?? [];
          appointments = allData.where((appt) {
            final String dbPatient = (appt["patient_name"] ?? "").toString().toLowerCase().trim();
            return dbPatient == loginName;
          }).toList();
          loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() { loading = false; appointments = []; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 2,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: loading
            ? const Center(child: CircularProgressIndicator(strokeWidth: 3))
            : RefreshIndicator(
          onRefresh: loadAppointments,
          displacement: 40,
          color: Colors.blue.shade700,
          child: CustomScrollView(
            // 1. AUTO-SCROLL ENABLED: BouncingScrollPhysics handles long lists beautifully
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              _buildHeader(),

              // 2. SCROLLABLE CONTENT AREA
              appointments.isEmpty
                  ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildEmptyState()
              )
                  : SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 120), // Bottom padding for FAB/Navbar
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => _appointmentCard(appointments[index]),
                    childCount: appointments.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Schedule",
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, letterSpacing: -1.2, color: Colors.black87),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.event_note_rounded, size: 16, color: Colors.blue.shade400),
                const SizedBox(width: 6),
                Text(
                  "${appointments.length} Appointments Found",
                  style: TextStyle(fontSize: 15, color: Colors.blueGrey.shade400, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _appointmentCard(dynamic appt) {
    // Dynamic logic for colors based on status
    final String status = appt["status"] ?? "Pending";
    Color themeColor = Colors.blue.shade700;
    if (status == "Cancelled") themeColor = Colors.redAccent;
    if (status == "Completed") themeColor = Colors.green.shade600;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: themeColor.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // User Info & Status
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: themeColor.withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(Icons.person_rounded, color: themeColor, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appt["patient_name"] ?? "Patient", style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87)),
                      Text("View medical record", style: TextStyle(fontSize: 12, color: Colors.blue.shade400, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                _statusBadge(status, themeColor),
              ],
            ),
          ),

          // Glassmorphic Time Section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _infoIconText(Icons.calendar_today_rounded, appt["date"]),
                Container(height: 20, width: 1, color: Colors.grey.shade300),
                _infoIconText(Icons.access_time_rounded, appt["time"]),
              ],
            ),
          ),

          // Doctor & Footer
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Row(
              children: [
                CircleAvatar(radius: 12, backgroundColor: Colors.blueGrey.shade50, child: const Icon(Icons.medical_services_rounded, size: 14, color: Colors.blueGrey)),
                const SizedBox(width: 8),
                Text("Dr. ${appt["doctor_name"]}", style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.blueGrey)),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.blueGrey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(30)),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11)),
    );
  }

  Widget _infoIconText(IconData icon, String? val) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.blueGrey.shade400),
        const SizedBox(width: 8),
        Text(val ?? "--", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 14)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.calendar_today_rounded, size: 80, color: Colors.blue.withOpacity(0.1)),
        const SizedBox(height: 20),
        const Text("No appointments yet", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
        const SizedBox(height: 8),
        const Text("Your schedule is clear!", style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  String _weekday(int d) {
    const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return days[(d - 1).clamp(0, 6)];
  }
}