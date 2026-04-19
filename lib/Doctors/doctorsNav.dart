import 'package:flutter/material.dart';

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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("HOSPITAL", style: TextStyle(fontWeight: .bold),),
        actions: [

          IconButton(
            icon: const Icon(Icons.account_circle, size: 30),
            onPressed: () {
              Navigator.pushNamed(context,'/docprofile');

            },
          ),
          const SizedBox(width: 10),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            const SizedBox(height: 20,),
            ListTile(
              title: const Text("Home"),
              onTap: () => Navigator.pushReplacementNamed(context, '/doctors'),
            ),
            ListTile(
              title: const Text("Appointments"),
              onTap: () => Navigator.pushReplacementNamed(context, '/docappointments'),
            ),
            ListTile(
              title: const Text("Profile"),
              onTap: () => Navigator.pushReplacementNamed(context, '/profile'),
            ),
            ListTile(
              title: const Text("Logout"),
              onTap: () => Navigator.pushReplacementNamed(context, '/'),
            ),
          ],
        ),
      ),

      body: widget.body,

    );
  }
}