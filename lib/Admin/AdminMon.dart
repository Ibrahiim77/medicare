import 'package:flutter/material.dart';
import '../services/admin_service.dart';
import 'AdminScaffold.dart';

class AdminMonitorPage extends StatefulWidget {
  const AdminMonitorPage({super.key});

  @override
  State<AdminMonitorPage> createState() => _AdminMonitorPageState();
}

class _AdminMonitorPageState extends State<AdminMonitorPage> {
  List doctors = [];
  List admins = [];
  List appointments = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final docData = await AdminService.getDoctors();
      final adminData = await AdminService.getAdmins();
      final apptData = await AdminService.getAppointments();

      setState(() {
        doctors = docData;
        admins = adminData;
        appointments = apptData;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      currentIndex: 3,
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const Text(
              "System Monitoring",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            _item("Doctors", doctors.length),
            _item("Admins", admins.length),
            _item("Appointments", appointments.length),
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
        trailing: Text(count.toString()),
      ),
    );
  }
}