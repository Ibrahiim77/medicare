import 'package:flutter/material.dart';
import '../main_screen.dart';
import '../appointments_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {


    final appointments = AppointmentProvider.of(context).appointments;


    final upcoming = [...appointments]..sort((a, b) => a.date.compareTo(b.date));


    final limited = upcoming.take(2).toList();

    return MainScaffold(
      currentIndex: 0,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),


              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: "Search Medical",
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Services",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),

              const SizedBox(height: 15),

              Row(
                children: [
                  const SizedBox(width: 32),
                  serviceBox(Icons.medical_services, Colors.blue),
                  const SizedBox(width: 30),
                  serviceBox(Icons.science, Colors.orange),
                  const SizedBox(width: 30),
                  serviceBox(Icons.local_hospital, Colors.green),
                  const SizedBox(width: 30),
                  serviceBox(Icons.healing, Colors.pink),
                ],
              ),

              const SizedBox(height: 33),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Get the best\nMedical Services",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Lorem ispum something to be",
                            style: TextStyle(fontSize: 12),
                          ),

                        ],
                      ),
                    ),
                    const CircleAvatar(
                      radius: 65,
                      backgroundImage:
                      NetworkImage("https://i.pravatar.cc/150?img=12"),

                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Upcoming appointments",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),


              if (limited.isEmpty)
                const Text("No upcoming appointments")
              else
                Column(
                  children: limited.map((appt) {
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
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "${appt.date.day}",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  Text(
                                    _weekday(appt.date.weekday),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appt.time.format(context),
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  appt.name,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  appt.reason,
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }


  String _weekday(int d) {
    const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return days[(d - 1).clamp(0, 6)];
  }
}


Widget serviceBox(IconData icon, Color color) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: color.withOpacity(0.2),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Icon(icon, color: color),
  );
}