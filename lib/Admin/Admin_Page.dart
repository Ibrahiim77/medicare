import 'package:flutter/material.dart';
import '../services/admin_service.dart';
import 'AdminScaffold.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<Map<String, dynamic>> doctors = [];
  List<Map<String, dynamic>> admins = [];
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

      setState(() {
        doctors = List<Map<String, dynamic>>.from(docData);
        admins = List<Map<String, dynamic>>.from(adminData);
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      currentIndex: 0,
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
                _card("Admins", admins.length, Icons.admin_panel_settings),
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

                      // SAFE NULL HANDLING
                      title: Text(
                        (d["name"] ?? "Unknown").toString(),
                      ),
                      subtitle: Text(
                        (d["specialty"] ?? "No specialty").toString(),
                      ),
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
              count.toString(),
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