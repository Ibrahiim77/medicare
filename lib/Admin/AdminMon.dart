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
      final docRes = await AdminService.getDoctors();
      final adminRes = await AdminService.getAdmins();
      final apptRes = await AdminService.getAppointments();

      if (mounted) {
        setState(() {
          // Extract 'data' from the Map response
          doctors = docRes["data"] ?? [];
          admins = adminRes["data"] ?? [];
          appointments = apptRes["data"] ?? [];
          loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => loading = false);
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
            const SizedBox(height: 30),
            _item("Total Doctors", doctors.length, Icons.person),
            _item("Total Admins", admins.length, Icons.admin_panel_settings),
            _item("Total Appointments", appointments.length, Icons.calendar_today),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: loadData,
              icon: const Icon(Icons.refresh),
              label: const Text("Refresh Stats"),
            )
          ],
        ),
      ),
    );
  }

  Widget _item(String title, int count, IconData icon) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            count.toString(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}