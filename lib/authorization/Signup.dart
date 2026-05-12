import 'package:flutter/material.dart';
import 'dart:ui'; // Required for BackdropFilter
import '../user_provider.dart';
import '../Models/user_model.dart';
import '../services/auth_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordHidden = true;
  bool isLoading = false;

  String? emailError;
  String? userError;
  String? passwordError;

  Future<void> signup() async {
    setState(() {
      emailError = null;
      userError = null;
      passwordError = null;
      isLoading = true;
    });

    final username = userNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() {
        if (username.isEmpty) userError = "Required";
        if (email.isEmpty) emailError = "Required";
        if (password.isEmpty) passwordError = "Required";
        isLoading = false;
      });
      return;
    }

    final newUser = UserModel(
      username: username,
      email: email,
      password: password,
      role: "user",
    );

    try {
      final response = await AuthService.register(newUser);
      if (response['success'] == true) {
        UserProvider.of(context).setUser(newUser);
        _showSuccess(username);
      } else {
        _showError(response['message'] ?? "Signup failed");
      }
    } catch (e) {
      _showError("Server Connection Failed");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.redAccent.shade400,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSuccess(String name) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
                child: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 60),
              ),
              const SizedBox(height: 20),
              Text("Welcome, $name!", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
              const SizedBox(height: 10),
              const Text("Your health journey starts here.", textAlign: TextAlign.center),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text("Go to Dashboard", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue.shade900, Colors.blue.shade600, Colors.blue.shade400],
              ),
            ),
          ),

          // Decorative Circles
          Positioned(top: -50, right: -50, child: _buildCircle(200, Colors.white12)),
          Positioned(bottom: -30, left: -30, child: _buildCircle(150, Colors.white10)),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Icon(Icons.medical_services_outlined, size: 80, color: Colors.white),
                  const SizedBox(height: 10),
                  const Text("MediCare", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                  const Text("Create your secure patient account", style: TextStyle(color: Colors.white70, fontSize: 16)),

                  const SizedBox(height: 40),

                  // The Glassmorphic Input Card
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Column(
                          children: [
                            _buildTextField(userNameController, "Username", Icons.person_outline_rounded, userError),
                            const SizedBox(height: 18),
                            _buildTextField(emailController, "Email Address", Icons.alternate_email_rounded, emailError),
                            const SizedBox(height: 18),
                            _buildTextField(passwordController, "Password", Icons.lock_open_rounded, passwordError, isPass: true),

                            const SizedBox(height: 35),

                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : signup,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade800,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                                child: isLoading
                                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                    : const Text("CREATE ACCOUNT", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(color: Colors.white, fontSize: 15),
                        children: [
                          TextSpan(text: "Already a member? "),
                          TextSpan(text: "Login", style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, String? error, {bool isPass = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: isPass ? isPasswordHidden : false,
          style: const TextStyle(fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.blueGrey.shade400, fontSize: 14),
            errorText: error,
            prefixIcon: Icon(icon, color: Colors.blue.shade700, size: 22),
            suffixIcon: isPass ? IconButton(
              icon: Icon(isPasswordHidden ? Icons.visibility_off : Icons.visibility, color: Colors.blueGrey.shade300, size: 20),
              onPressed: () => setState(() => isPasswordHidden = !isPasswordHidden),
            ) : null,
            filled: true,
            fillColor: Colors.blue.shade50.withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.blue.shade200)),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.red.shade200)),
            focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.red.shade400)),
          ),
        ),
      ],
    );
  }
}