import 'package:flutter/material.dart';
import '../main_screen.dart';
import '../user_provider.dart';
import '../services/appointment_service.dart';
import 'select_doctor_page.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedDoctor;
  String? selectedReason;

  final TextEditingController nameController = TextEditingController();

  final List<String> reasons = const [
    "General Checkup", "Fever", "Headache", "Stomach Pain",
    "Skin Issue", "Back Pain", "Follow-up", "Other"
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = UserProvider.of(context).user;
      if (user != null) {
        setState(() {
          nameController.text = user.username;
        });
      }
    });
  }

  void _openDoctorSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectDoctorPage(
          onDoctorSelected: (name) {
            setState(() => selectedDoctor = name);
          },
        ),
      ),
    );
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: Colors.blue.shade800),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => selectedTime = picked);
  }

  Future<void> bookAppointment() async {
    if (selectedDate == null || selectedTime == null || selectedDoctor == null ||
        selectedReason == null || nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all fields"), behavior: SnackBarBehavior.floating)
      );
      return;
    }

    final user = UserProvider.of(context).user;
    final data = {
      "user_id": user?.id,
      "doctor_id": 1,
      "patient_name": nameController.text.trim(),
      "doctor_name": selectedDoctor,
      "reason": selectedReason,
      "date": selectedDate!.toIso8601String().split('T')[0],
      "time": "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}",
      "status": "Pending"
    };

    try {
      final res = await AppointmentService.bookAppointment(data);
      if (res["success"] == true) {
        _showSuccessDialog();
        setState(() {
          selectedDate = null;
          selectedTime = null;
          selectedDoctor = null;
          selectedReason = null;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Server error"), behavior: SnackBarBehavior.floating)
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
        content: const Text("Your appointment has been booked successfully!", textAlign: TextAlign.center),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Great!"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 1,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade50.withOpacity(0.5),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("New Appointment", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
              const SizedBox(height: 8),
              Text("Fill in the details to schedule your visit.", style: TextStyle(color: Colors.blueGrey.shade400, fontSize: 15)),
              const SizedBox(height: 30),

              // Patient Card (Read Only)
              _buildSectionLabel("Patient Information"),
              _buildModernField(
                child: TextField(
                  controller: nameController,
                  readOnly: true,
                  decoration: _inputStyle("Patient Name", Icons.person_outline),
                ),
              ),

              const SizedBox(height: 20),
              _buildSectionLabel("Consultation Details"),

              // Doctor Selection
              _buildModernField(
                child: InkWell(
                  onTap: _openDoctorSelection,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                    child: Row(
                      children: [
                        Icon(Icons.medical_services_outlined, color: Colors.blue.shade700),
                        const SizedBox(width: 12),
                        Text(
                          selectedDoctor ?? "Select a Doctor",
                          style: TextStyle(
                              fontSize: 16,
                              color: selectedDoctor == null ? Colors.grey.shade600 : Colors.black87,
                              fontWeight: selectedDoctor == null ? FontWeight.normal : FontWeight.w600
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Reason Dropdown
              _buildModernField(
                child: DropdownButtonFormField<String>(
                  value: selectedReason,
                  items: reasons.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                  onChanged: (val) => setState(() => selectedReason = val),
                  decoration: _inputStyle("Reason for Visit", Icons.healing_outlined),
                  icon: const Icon(Icons.keyboard_arrow_down),
                ),
              ),

              const SizedBox(height: 25),
              _buildSectionLabel("Schedule"),

              // Date & Time Row
              Row(
                children: [
                  Expanded(
                    child: _buildPickerTile(
                      label: selectedDate == null ? "Date" : "${selectedDate!.day}/${selectedDate!.month}",
                      icon: Icons.calendar_today_rounded,
                      color: Colors.blue.shade700,
                      onTap: pickDate,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildPickerTile(
                      label: selectedTime == null ? "Time" : selectedTime!.format(context),
                      icon: Icons.access_time_rounded,
                      color: Colors.orange.shade700,
                      onTap: pickTime,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Action Button
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    elevation: 0,
                  ),
                  onPressed: bookAppointment,
                  child: const Text("Confirm & Book", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // UI Helpers to keep code clean
  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
    );
  }

  Widget _buildModernField({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: child,
    );
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.blue.shade700),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      filled: true,
      fillColor: Colors.white,
    );
  }

  Widget _buildPickerTile({required String label, required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}