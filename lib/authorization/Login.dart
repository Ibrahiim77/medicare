import 'package:flutter/material.dart';
import './logAppbar.dart';
import '../user_provider.dart';
import '../Doctors/DoctorStore.dart';

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

    bool isValid = true;

    if (email.isEmpty) {
      setState(() => emailError = "Email is required");
      isValid = false;
    }

    if (password.isEmpty) {
      setState(() => passwordError = "Password is required");
      isValid = false;
    }

    if (!isValid) return;


    final matchedDoctor = availableDoctors.where(
          (d) => d.email == email && d.password == password,
    ).firstOrNull;

    if (matchedDoctor != null) {

      DoctorProvider.of(context).loginDoctor(matchedDoctor);
      Navigator.pushReplacementNamed(context, '/doctors');
      return;
    }

    final user = UserProvider.of(context).user;

    if (user == null) {
      setState(() => generalError = "No account found. Please sign up first.");
      return;
    }

    if (user.email != email || user.password != password) {
      setState(() => generalError = "Wrong email or password.");
      return;
    }


    Navigator.pushReplacementNamed(context, '/home');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Login",
                    style: TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold)),
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
                    child: Text(generalError,
                        style: const TextStyle(color: Colors.red)),
                  ),

                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    errorText: emailError.isEmpty ? null : emailError,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
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
                        borderRadius: BorderRadius.circular(10)),
                    suffixIcon: IconButton(
                      icon: Icon(isPasswordHidden
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () => setState(
                              () => isPasswordHidden = !isPasswordHidden),
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue),
                    onPressed: login,
                    child: const Text("Login",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue),
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/signup'),
                    child: const Text("Sign up",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
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