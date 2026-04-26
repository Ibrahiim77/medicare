import 'package:flutter/material.dart';
import '../user_provider.dart';
import 'AdminScaffold.dart';

class AddDoctorPage extends StatefulWidget {
  const AddDoctorPage({super.key});

  @override
  State<AddDoctorPage> createState() => _AddDoctorPageState();
}

class _AddDoctorPageState extends State<AddDoctorPage> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final specialty = TextEditingController();

  void addDoctor() {
    availableDoctors.add(
      Doctor(
        name: name.text,
        email: email.text,
        password: password.text,
        specialty: specialty.text,
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      currentIndex: 1,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(controller: name, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: email, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: password, decoration: const InputDecoration(labelText: "Password")),
            TextField(controller: specialty, decoration: const InputDecoration(labelText: "Specialty")),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: addDoctor,
              child: const Text("Add Doctor"),
            )
          ],
        ),
      ),
    );
  }
}