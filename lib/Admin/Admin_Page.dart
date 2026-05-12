import 'package:flutter/material.dart';
import '../services/admin_service.dart';
import 'AdminScaffold.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  // Changed to dynamic List to avoid strict Map casting issues during load
  List doctors = [];
  List admins = [];
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

      if (mounted) {
        setState(() {
          // Extract the 'data' list from the response Map
          doctors = docRes["data"] ?? [];
          admins = adminRes["data"] ?? [];
          loading = false;
        });
      }
    } catch (e) {
      debugPrint("Dashboard Load Error: $e");
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      currentIndex: 0,
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator( // Added RefreshIndicator for better UX
        onRefresh: loadData,
        child: ListView( // Used ListView to make the whole page scrollable
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              "Dashboard Overview",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _card("Doctors", doctors.length, Icons.medical_services),
                const SizedBox(width: 10),
                _card("Admins", admins.length, Icons.admin_panel_settings),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              "Doctor List",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Using ListView.builder inside a Column requires shrinkWrap or a Container
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                final d = doctors[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(d["name"] ?? "Unknown Doctor"),
                    subtitle: Text(d["specialty"] ?? "No specialty"),
                  ),
                );
              },
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
          color: Colors.blue.withOpacity(0.1), // Changed to Blue for variety
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue, size: 30),
            const SizedBox(height: 10),
            Text(
              count.toString(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(title, style: const TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}