import 'package:flutter/material.dart';
import '../user_provider.dart';

class DocScaffold extends StatefulWidget {
  final Widget body;
  final int currentIndex;

  const DocScaffold({
    super.key,
    required this.body,
    this.currentIndex = 0,
  });

  @override
  State<DocScaffold> createState() => _DocScaffoldState();
}

class _DocScaffoldState extends State<DocScaffold> {

  void logout() {
    final provider = UserProvider.of(context);
    provider.logout();

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
      appBar: AppBar(
        title: const Text(
          "HOSPITAL",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, size: 30),
            onPressed: () {
              Navigator.pushNamed(context, '/docprofile');
            },
          ),
          const SizedBox(width: 10),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [

            UserAccountsDrawerHeader(
              accountName: Text(user?.username ?? "Doctor"),
              accountEmail: Text(user?.email ?? ""),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.medical_services),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/doctors');
              },
            ),

            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text("Appointments"),
              onTap: () {
                Navigator.pushReplacementNamed(
                    context, '/doctorsappointment');
              },
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/docprofile');
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: logout,
            ),
          ],
        ),
      ),

      body: widget.body,
    );
  }
}