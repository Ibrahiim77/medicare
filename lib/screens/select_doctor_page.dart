import 'package:flutter/material.dart';
import '../services/doctor_service.dart';

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
  bool loading = true;
  List doctors = [];

  @override
  void initState() {
    super.initState();
    loadDoctors();
  }

  Future<void> loadDoctors() async {
    try {
      final res = await DoctorService.getDoctors();
      setState(() {
        // Adjust based on your API response structure
        doctors = res["data"] ?? res;
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
      appBar: AppBar(
        title: const Text("Select Doctor", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
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
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredDoctors.isEmpty
                ? const Center(child: Text("No doctors found"))
                : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredDoctors.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final doctor = filteredDoctors[index];
                return _DoctorCard(
                  doctor: doctor,
                  onDoctorSelected: widget.onDoctorSelected,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final dynamic doctor;
  final void Function(String doctorName) onDoctorSelected;

  const _DoctorCard({required this.doctor, required this.onDoctorSelected});

  @override
  Widget build(BuildContext context) {
    final name = doctor["name"] ?? "Unknown Doctor";
    final specialty = doctor["specialty"] ?? "General";

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundColor: Colors.blue,
            child: Icon(Icons.medical_services, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 10),
          Text(specialty, style: TextStyle(color: Colors.blue.shade700, fontSize: 11, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(name, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                onPressed: () {
                  onDoctorSelected(name);
                  Navigator.pop(context);
                },
                child: const Text("Select"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}