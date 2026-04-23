import 'package:flutter/material.dart';
import '../main_screen.dart';
import '../appointments_provider.dart';
import '../user_provider.dart';
import 'select_doctor_page.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<FormPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedDoctor;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => selectedTime = picked);
  }


  Future<void> pickDoctor() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const SelectDoctorPage()),
    );
    if (result != null) {
      setState(() => selectedDoctor = result);
    }
  }

  void _book() {
    if (selectedDate == null ||
        selectedTime == null ||
        nameController.text.isEmpty ||
        reasonController.text.isEmpty ||
        selectedDoctor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields and select a doctor")),
      );
      return;
    }

    final userEmail = UserProvider.of(context).user?.email ?? '';

    AppointmentProvider.of(context).addAppointment(
      Appointment(
        name: nameController.text.trim(),
        reason: reasonController.text.trim(),
        date: selectedDate!,
        time: selectedTime!,
        email: userEmail,
        doctorName: selectedDoctor!,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Booked with $selectedDoctor on ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
              " at ${selectedTime!.format(context)}",
        ),
      ),
    );

    setState(() {
      selectedDate = null;
      selectedTime = null;
      selectedDoctor = null;
    });
    nameController.clear();
    reasonController.clear();
  }

  String? selectedReason;

  final List<String> medicalReasons = [
    "General Checkup",
    "Fever",
    "Headache",
    "Stomach Pain",
    "Skin Issue",
    "Follow-up",
    "Other",
  ];

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 1,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Book appointment",
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 40),


            GestureDetector(
              onTap: pickDoctor,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: selectedDoctor == null
                      ? Colors.blue[700]
                      : Colors.green[600],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.medical_services,
                        color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      selectedDoctor == null
                          ? "Select Doctor"
                          : selectedDoctor!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),


            GestureDetector(
              onTap: pickDate,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 10),
                    Text(selectedDate == null
                        ? "Select Date"
                        : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),


            GestureDetector(
              onTap: pickTime,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time),
                    const SizedBox(width: 10),
                    Text(selectedTime == null
                        ? "Select Time"
                        : selectedTime!.format(context)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Your Name",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 25),

            DropdownButtonFormField<String>(
              value: selectedReason,
              items: medicalReasons.map((reason) {
                return DropdownMenuItem(
                  value: reason,
                  child: Text(reason),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => selectedReason = value);
              },
              decoration: InputDecoration(
                labelText: "Select Reason",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _book,
                child: const Text("Book Appointment"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}