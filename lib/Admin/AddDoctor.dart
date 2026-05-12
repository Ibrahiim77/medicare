import 'package:flutter/material.dart';
import '../services/doctor_service.dart';
import 'AdminScaffold.dart';

class AddDoctorPage extends StatefulWidget {
  const AddDoctorPage({super.key});

  @override
  State<AddDoctorPage> createState() => _AddDoctorPageState();
}

class _AddDoctorPageState extends State<AddDoctorPage> {
  final name = TextEditingController(); // optional UI only
  final email = TextEditingController();
  final password = TextEditingController();
  final specialty = TextEditingController();

  bool loading = false;

  Future<void> addDoctor() async {
    if (email.text.isEmpty ||
        password.text.isEmpty ||
        specialty.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final res = await DoctorService.addDoctor(
        email: email.text.trim(),
        password: password.text.trim(),
        specialty: specialty.text.trim(),
      );

      if (res["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Doctor added successfully")),
        );

        email.clear();
        password.clear();
        specialty.clear();
        name.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res["message"] ?? "Failed to add doctor")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      currentIndex: 1,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const Text(
              "Add Doctor",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: email,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: specialty,
              decoration: const InputDecoration(
                labelText: "Specialty",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: loading ? null : addDoctor,
                child: Text(
                  loading ? "Adding..." : "Add Doctor",
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}