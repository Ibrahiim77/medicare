import 'package:flutter/material.dart';
import '../user_provider.dart';

class AdminScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;

  const AdminScaffold({
    super.key,
    required this.body,
    required this.currentIndex,
  });

  void _logout(BuildContext context) {
    UserProvider.of(context).logout();

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = UserProvider.of(context).user;

    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        title: const Text("Admin Panel"),
      ),


      drawer: Drawer(
        child: Column(
          children: [

            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.red),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.admin_panel_settings,
                      color: Colors.white, size: 40),
                  const SizedBox(height: 10),
                  Text(
                    user?.email ?? "Admin",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text("Dashboard"),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, '/admin'),
            ),

            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text("Add Doctor"),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, '/add-doctor'),
            ),

            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text("Add Admin"),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, '/add-admin'),
            ),

            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text("Monitoring"),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, '/admin-monitor'),
            ),

            const Spacer(),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout",
                  style: TextStyle(color: Colors.red)),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),

      body: body,


      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/admin');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/add-doctor');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/add-admin');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/admin-monitor');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_add), label: "Doctors"),
          BottomNavigationBarItem(
              icon: Icon(Icons.admin_panel_settings), label: "Admins"),
          BottomNavigationBarItem(
              icon: Icon(Icons.analytics), label: "Monitor"),
        ],
      ),
    );
  }
}