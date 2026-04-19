import 'package:flutter/material.dart';

class MainScaffold extends StatefulWidget {
  final Widget body;
  final int currentIndex;

  const MainScaffold({
    super.key,
    required this.body,
    this.currentIndex = 0,
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });


    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/form');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/appointments');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("HOSPITAL", style: TextStyle(fontWeight: .bold),),
          actions: [

          IconButton(
          icon: const Icon(Icons.account_circle, size: 30),
      onPressed: () {
        Navigator.pushNamed(context,'/profile');

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
              onTap: () => Navigator.pushReplacementNamed(context, '/home'),
            ),
            ListTile(
              title: const Text("Book appointment"),
              onTap: () => Navigator.pushReplacementNamed(context, '/form'),
            ),
            ListTile(
              title: const Text("Profile"),
              onTap: () => Navigator.pushReplacementNamed(context, '/profile'),
            ),
            ListTile(
              title: const Text("Logout"),
              onTap: () => Navigator.pushReplacementNamed(context, '/'),
            ),
            ListTile(
              title: const Text("Doc"),
              onTap: () => Navigator.pushReplacementNamed(context, '/doctors'),
            ),
          ],
        ),
      ),

      body: widget.body,

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'BOOK'),
          BottomNavigationBarItem(icon: Icon(Icons.save), label: 'Appointments'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),

        ],
      ),
    );
  }
}