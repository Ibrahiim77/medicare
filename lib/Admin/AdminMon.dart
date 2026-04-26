import 'package:flutter/material.dart';
import '../user_provider.dart';
import 'AdminScaffold.dart';

class AdminMonitorPage extends StatelessWidget {
  const AdminMonitorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      currentIndex: 3,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const Text(
              "System Monitoring",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            _item("Doctors", availableDoctors.length),
            _item("Admins", admins.length),
            _item("Appointments", 0),
          ],
        ),
      ),
    );
  }

  Widget _item(String title, int count) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.analytics, color: Colors.red),
        title: Text(title),
        trailing: Text("$count"),
      ),
    );
  }
}