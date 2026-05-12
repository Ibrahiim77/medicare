import 'package:flutter/material.dart';
import '../services/admin_service.dart'; // Using the updated AdminService

class SelectDoctorPage extends StatefulWidget {
  final void Function(String doctorName) onDoctorSelected;
  const SelectDoctorPage({super.key, required this.onDoctorSelected});

  @override
  State<SelectDoctorPage> createState() => _SelectDoctorPageState();
}

class _SelectDoctorPageState extends State<SelectDoctorPage> {
  String query = "";
  bool loading = true;
  List doctors = [];

  @override
  void initState() {
    super.initState();
    loadDoctors();
  }

  Future<void> loadDoctors() async {
    try {
      // Calling the fixed AdminService
      final res = await AdminService.getDoctors();

      setState(() {
        // We look for the 'data' key inside the Map
        doctors = res["data"] ?? [];
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredDoctors = doctors.where((doctor) {
      final q = query.toLowerCase().trim();
      final name = (doctor["name"] ?? "").toString().toLowerCase();
      final specialty = (doctor["specialty"] ?? "").toString().toLowerCase();
      return name.contains(q) || specialty.contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Select Doctor")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) => setState(() => query = value),
              decoration: InputDecoration(
                hintText: "Search doctor...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: filteredDoctors.isEmpty
                ? const Center(child: Text("No doctors found in Database"))
                : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredDoctors.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final doctor = filteredDoctors[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(radius: 30, child: Icon(Icons.medical_services)),
                      const SizedBox(height: 10),
                      Text(doctor["name"] ?? "Unknown", style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(doctor["specialty"] ?? "General"),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          widget.onDoctorSelected(doctor["name"] ?? "Unknown");
                          Navigator.pop(context);
                        },
                        child: const Text("Select"),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}