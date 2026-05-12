import 'package:flutter/material.dart';
import '../services/doctor_service.dart';
import 'AdminScaffold.dart';

class AddDoctorPage extends StatefulWidget {
  const AddDoctorPage({super.key});

  @override
  State<AddDoctorPage> createState() => _AddDoctorPageState();
}

class _AddDoctorPageState extends State<AddDoctorPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _specialtyController = TextEditingController();

  bool _isLoading = false;

  Future<void> _handleSaveDoctor() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final res = await DoctorService.addDoctor(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        specialty: _specialtyController.text.trim(),
      );

      if (!mounted) return;

      if (res["success"] == true) {
        _showSnackBar("Doctor profile created!", Colors.green);
        _formKey.currentState!.reset(); // Clears all fields
      } else {
        _showSnackBar(res["message"] ?? "Failed to add doctor", Colors.orange);
      }
    } catch (e) {
      _showSnackBar("Server connection failed", Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color, behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      currentIndex: 1,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Add New Doctor",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),

              _buildField(_nameController, "Full Name", Icons.person_add_alt),
              const SizedBox(height: 15),
              _buildField(_emailController, "Email Address", Icons.email_outlined),
              const SizedBox(height: 15),
              _buildField(_passwordController, "Login Password", Icons.lock_outline, obscure: true),
              const SizedBox(height: 15),
              _buildField(_specialtyController, "Specialty (e.g. Cardiologist)", Icons.medical_services_outlined),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _isLoading ? null : _handleSaveDoctor,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Register Doctor", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label, IconData icon, {bool obscure = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (val) => val!.isEmpty ? "Field required" : null,
    );
  }
}