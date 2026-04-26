import 'package:flutter/material.dart';
import '../user_provider.dart';
import 'AdminScaffold.dart';

class AddAdminPage extends StatefulWidget {
  const AddAdminPage({super.key});

  @override
  State<AddAdminPage> createState() => _AddAdminPageState();
}

class _AddAdminPageState extends State<AddAdminPage> {
  final email = TextEditingController();
  final password = TextEditingController();

  void addAdmin() {
    admins.add(
      Admin(
        email: email.text,
        password: password.text,
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      currentIndex: 2,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(controller: email, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: password, decoration: const InputDecoration(labelText: "Password")),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: addAdmin,
              child: const Text("Add Admin"),
            )
          ],
        ),
      ),
    );
  }
}