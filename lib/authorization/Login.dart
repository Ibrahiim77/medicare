import 'package:check/authorization/logAppbar.dart';
import 'package:flutter/material.dart';
import '../user_provider.dart';
import 'logAppbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordHidden = true;
  String emailError = "";
  String passwordError = "";
  String generalError = "";

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    setState(() {
      emailError = "";
      passwordError = "";
      generalError = "";
    });

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty) {
      setState(() => emailError = "Email is required");
      return;
    }

    if (password.isEmpty) {
      setState(() => passwordError = "Password is required");
      return;
    }

    final provider = UserProvider.of(context);

    // =========================
    // 🛠 ADMIN LOGIN
    // =========================
    final adminMatch = admins.where(
          (a) => a.email == email && a.password == password,
    ).toList();

    if (adminMatch.isNotEmpty) {
      provider.setUser(
        UserData(
          username: "Admin",
          email: email,
          password: password,
          role: UserRole.admin,
        ),
      );

      Navigator.pushReplacementNamed(context, '/admin');
      return;
    }

    // =========================
    // 🧑‍⚕️ DOCTOR LOGIN
    // =========================
    final doctorMatch = availableDoctors.where(
          (d) => d.email == email && d.password == password,
    ).toList();

    if (doctorMatch.isNotEmpty) {
      final doc = doctorMatch.first;

      provider.setUser(
        UserData(
          username: doc.name,
          email: doc.email,
          password: doc.password,
          role: UserRole.doctor,
        ),
      );

      Navigator.pushReplacementNamed(context, '/doctors');
      return;
    }

    // =========================
    // 👤 USER LOGIN
    // =========================
    final user = provider.user;

    if (user == null) {
      setState(() {
        generalError = "No account found. Please sign up first.";
      });
      return;
    }

    if (user.email == email && user.password == password) {
      provider.setUser(
        user.copyWith(role: UserRole.user),
      );

      Navigator.pushReplacementNamed(context, '/home');
      return;
    }

    setState(() {
      generalError = "Wrong email or password.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  "Login",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                if (generalError.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      generalError,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    errorText: emailError.isEmpty ? null : emailError,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: passwordController,
                  obscureText: isPasswordHidden,
                  decoration: InputDecoration(
                    labelText: "Password",
                    errorText: passwordError.isEmpty ? null : passwordError,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordHidden
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordHidden = !isPasswordHidden;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: login,
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/signup');
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}