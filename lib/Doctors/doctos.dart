import 'package:flutter/material.dart';
import '../appointments_provider.dart';
import 'doctorsNav.dart';

class DoctorsPage extends StatefulWidget {
  const DoctorsPage({super.key});

  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  @override
  Widget build(BuildContext context) {
    final appointments = AppointmentProvider.of(context).appointments;


    final pendingCount = appointments.length;

    return DocScaffold(
      currentIndex: 0,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),


              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[700],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Welcome back,",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Doctor",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "$pendingCount Appointments Today",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white24,
                      child: Icon(
                        Icons.medical_services,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),


              Row(
                children: [
                  _statCard(
                    icon: Icons.pending_actions,
                    label: "Pending",
                    count: appointments.length.toString(),
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 12),
                  _statCard(
                    icon: Icons.check_circle_outline,
                    label: "Confirmed",
                    count: "0",
                    color: Colors.green,
                  ),
                  const SizedBox(width: 12),
                  _statCard(
                    icon: Icons.cancel_outlined,
                    label: "Rejected",
                    count: "0",
                    color: Colors.red,
                  ),
                ],
              ),

              const SizedBox(height: 25),


              const Text(
                "Quick Actions",
                style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _actionBox(
                    icon: Icons.calendar_today,
                    label: "Appointments",
                    color: Colors.blue,
                    onTap: () => Navigator.pushReplacementNamed(
                        context, '/doctorsappointment'),
                  ),
                  _actionBox(
                    icon: Icons.person_outline,
                    label: "Profile",
                    color: Colors.green,
                    onTap: () =>
                        Navigator.pushNamed(context, '/profile'),
                  ),
                  _actionBox(
                    icon: Icons.notifications_outlined,
                    label: "Alerts",
                    color: Colors.orange,
                    onTap: () {},
                  ),
                  _actionBox(
                    icon: Icons.logout,
                    label: "Logout",
                    color: Colors.red,
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, '/'),
                  ),
                ],
              ),

              const SizedBox(height: 25),


              const Text(
                "Recent Appointments",
                style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),

              const SizedBox(height: 15),

              appointments.isEmpty
                  ? Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.calendar_month_outlined,
                        size: 50, color: Colors.blue),
                    SizedBox(height: 10),
                    Text(
                      "No appointments yet",
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
                  : Column(
                children: appointments.take(3).map((appt) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),

                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[700],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [

                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blue[500],
                              borderRadius:
                              BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "${appt.date.day}",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18),
                                ),
                                Text(
                                  _weekday(appt.date.weekday),
                                  style: const TextStyle(
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appt.time.format(context),
                                  style: const TextStyle(
                                      color: Colors.white70),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  appt.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  appt.reason,
                                  style: const TextStyle(
                                      color: Colors.white70),
                                ),
                              ],
                            ),
                          ),


                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.2),
                              borderRadius:
                              BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "Pending",
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionBox(
      {required IconData icon,
        required String label,
        required Color color,
        required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String label,
    required String count,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              count,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color.withOpacity(0.8),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _weekday(int d) {
    const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return days[(d - 1).clamp(0, 6)];
  }
}