import 'package:flutter/material.dart';
import 'dart:ui'; // Required for BackdropFilter
import '../user_provider.dart';
import '../Models/user_model.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;
  bool hidePassword = true;
  String error = "";

  Future<void> login() async {
    if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
      setState(() => error = "Please fill in all fields");
      return;
    }

    setState(() {
      loading = true;
      error = "";
    });

    try {
      final res = await AuthService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (res["success"] != true) {
        setState(() => error = res["message"] ?? "Invalid credentials");
        return;
      }

      final userData = res["user"];
      if (userData == null) {
        setState(() => error = "Server data error");
        return;
      }

      final user = UserModel.fromJson(userData);

      if (!mounted) return;
      UserProvider.of(context).setUser(user);

      // Role-based routing
      String targetRoute = '/home';
      if (user.role == "admin") {
        targetRoute = '/admin';
      } else if (user.role == "doctor") {
        targetRoute = '/doctors';
      }

      Navigator.pushReplacementNamed(context, targetRoute);
    } catch (e) {
      setState(() => error = "Connection failed. Check your server.");
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Premium Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.blue.shade900,
                  Colors.blue.shade700,
                  const Color(0xFF1E88E5),
                ],
              ),
            ),
          ),

          // 2. Decorative Soft Light Blobs
          Positioned(top: -100, left: -50, child: _buildBlob(300, Colors.white.withOpacity(0.1))),
          Positioned(bottom: 50, right: -80, child: _buildBlob(250, Colors.blue.shade300.withOpacity(0.2))),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // --- Logo Section ---
                    const Icon(Icons.health_and_safety_rounded, size: 85, color: Colors.white),
                    const SizedBox(height: 12),
                    const Text(
                      "MediCare",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const Text(
                      "Your Personalized Health Portal",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 40),

                    // --- Glassmorphism Login Card ---
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.white.withOpacity(0.3)),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                "Welcome Back",
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
                              ),
                              const SizedBox(height: 8),
                              const Text("Sign in to continue", style: TextStyle(color: Colors.blueGrey)),
                              const SizedBox(height: 30),

                              // Error Display
                              if (error.isNotEmpty) _buildErrorBox(),

                              _buildInputField(
                                controller: emailController,
                                label: "Email Address",
                                icon: Icons.alternate_email_rounded,
                              ),
                              const SizedBox(height: 20),
                              _buildInputField(
                                controller: passwordController,
                                label: "Password",
                                icon: Icons.lock_person_rounded,
                                isPass: true,
                              ),
                              const SizedBox(height: 35),

                              // Login Button
                              SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton(
                                  onPressed: loading ? null : login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade800,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    elevation: 0,
                                  ),
                                  child: loading
                                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                      : const Text("SIGN IN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // --- Sign Up Link ---
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/signup'),
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(color: Colors.white, fontSize: 15),
                          children: [
                            TextSpan(text: "Don't have an account? "),
                            TextSpan(
                              text: "Join Now",
                              style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildErrorBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(error, style: const TextStyle(color: Colors.red, fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPass = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPass ? hidePassword : false,
      style: const TextStyle(fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue.shade700, size: 22),
        suffixIcon: isPass
            ? IconButton(
          icon: Icon(hidePassword ? Icons.visibility_off : Icons.visibility, color: Colors.blueGrey.shade300, size: 20),
          onPressed: () => setState(() => hidePassword = !hidePassword),
        )
            : null,
        filled: true,
        fillColor: Colors.blue.shade50.withOpacity(0.5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.blue.shade200)),
      ),
    );
  }
}