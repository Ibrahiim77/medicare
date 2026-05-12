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
    if (index == _selectedIndex) return; // Don't reload if already on the page

    setState(() => _selectedIndex = index);

    final routes = ['/home', '/form', '/appointments', '/profile'];
    Navigator.pushReplacementNamed(context, routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Allows body to flow under the navigation bar
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        title: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5),
            children: [
              TextSpan(text: "Medi", style: TextStyle(color: Colors.blue.shade800)),
              const TextSpan(text: "Care", style: TextStyle(color: Colors.black87)),
            ],
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.notifications_none_rounded, color: Colors.blue.shade800),
              onPressed: () {},
            ),
          ),
        ],
      ),

      drawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
        ),
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.blue.shade800),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.blue),
              ),
              accountName: const Text("My Account", style: TextStyle(fontWeight: FontWeight.bold)),
              accountEmail: const Text("Manage your health settings"),
            ),
            _drawerTile(Icons.home_rounded, "Home", 0, '/home'),
            _drawerTile(Icons.add_task_rounded, "Book Appointment", 1, '/form'),
            _drawerTile(Icons.event_note_rounded, "My Appointments", 2, '/appointments'),
            _drawerTile(Icons.person_outline_rounded, "Profile Settings", 3, '/profile'),
            const Spacer(),
            const Divider(),
            _drawerTile(Icons.logout_rounded, "Logout", -1, '/', isDestructive: true),
            const SizedBox(height: 20),
          ],
        ),
      ),

      body: widget.body,

      // --- Enhanced Bottom Navigation ---
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5)),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: BottomNavigationBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              selectedItemColor: Colors.blue.shade800,
              unselectedItemColor: Colors.grey.shade400,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.grid_view_rounded),
                  activeIcon: Icon(Icons.grid_view_rounded),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle_outline_rounded),
                  activeIcon: Icon(Icons.add_circle_rounded),
                  label: 'Book',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today_outlined),
                  activeIcon: Icon(Icons.calendar_today_rounded),
                  label: 'Schedule',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline_rounded),
                  activeIcon: Icon(Icons.person_rounded),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawerTile(IconData icon, String title, int index, String route, {bool isDestructive = false}) {
    bool isSelected = _selectedIndex == index;
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.redAccent : (isSelected ? Colors.blue.shade800 : Colors.grey)),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.redAccent : (isSelected ? Colors.blue.shade800 : Colors.black87),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () => Navigator.pushReplacementNamed(context, route),
    );
  }
}