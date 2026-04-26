import 'package:flutter/material.dart';
import '../user_provider.dart';
import 'AdminScaffold.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final doctors = availableDoctors;
    final adminList = admins;

    return AdminScaffold(
      currentIndex: 0,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Dashboard Overview",
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                _card("Doctors", doctors.length, Icons.medical_services),
                const SizedBox(width: 10),
                _card("Admins", adminList.length, Icons.admin_panel_settings),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Doctors",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: doctors.length,
                itemBuilder: (context, index) {
                  final d = doctors[index];

                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(d.name),
                      subtitle: Text(d.specialty),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(String title, int count, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.red),
            const SizedBox(height: 10),
            Text(
              "$count",
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}