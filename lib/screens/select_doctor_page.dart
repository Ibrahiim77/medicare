import 'package:flutter/material.dart';
import '../user_provider.dart';

class SelectDoctorPage extends StatefulWidget {
  final void Function(String doctorName) onDoctorSelected;

  const SelectDoctorPage({
    super.key,
    required this.onDoctorSelected,
  });

  @override
  State<SelectDoctorPage> createState() => _SelectDoctorPageState();
}

class _SelectDoctorPageState extends State<SelectDoctorPage> {
  String query = "";

  @override
  Widget build(BuildContext context) {
    final doctors = availableDoctors;

    // 🔎 SMART SEARCH (name + specialty + partial specialty words)
    final filteredDoctors = doctors.where((doctor) {
      final q = query.toLowerCase().trim();

      final name = doctor.name.toLowerCase();
      final specialty = doctor.specialty.toLowerCase();
      final specialtyWords = specialty.split(' ');

      return name.contains(q) ||
          specialty.contains(q) ||
          specialtyWords.any((word) => word.contains(q));
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select Doctor",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [

          // =========================
          // 🔎 SEARCH BAR
          // =========================
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search by name or specialty...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // =========================
          // GRID LIST
          // =========================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: filteredDoctors.isEmpty
                  ? const Center(
                child: Text(
                  "No doctors found",
                  style: TextStyle(fontSize: 16),
                ),
              )
                  : GridView.builder(
                itemCount: filteredDoctors.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final doctor = filteredDoctors[index];

                  return _DoctorCard(
                    doctor: doctor,
                    onDoctorSelected:
                    widget.onDoctorSelected,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =========================
// DOCTOR CARD
// =========================
class _DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final void Function(String doctorName) onDoctorSelected;

  const _DoctorCard({
    required this.doctor,
    required this.onDoctorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          const SizedBox(height: 16),

          // ICON
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue,
            child: const Icon(
              Icons.medical_services,
              size: 40,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 12),

          // SPECIALTY
          Text(
            doctor.specialty,
            style: TextStyle(
              color: Colors.blue.shade700,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 4),

          // NAME
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              doctor.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // SELECT BUTTON
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                  const EdgeInsets.symmetric(vertical: 8),
                ),
                onPressed: () {
                  onDoctorSelected(doctor.name);
                  Navigator.pop(context);
                },
                child: const Text(
                  "Select",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}