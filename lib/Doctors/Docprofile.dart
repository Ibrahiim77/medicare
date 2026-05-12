import 'package:flutter/material.dart';
import '../user_provider.dart';
import 'doctorsNav.dart';

class DocProfilePage extends StatelessWidget {
  const DocProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocScaffold(
      currentIndex: 3,
      body: const EditableProfileBody(),
    );
  }
}

class EditableProfileBody extends StatefulWidget {
  const EditableProfileBody({super.key});

  @override
  State<EditableProfileBody> createState() => _EditableProfileBodyState();
}

class _EditableProfileBodyState extends State<EditableProfileBody> {
  // We'll use a single editing toggle for a cleaner "Settings" feel
  bool isEditing = false;

  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      final user = UserProvider.of(context).user;
      usernameController = TextEditingController(text: user?.username ?? '');
      emailController = TextEditingController(text: user?.email ?? '');
      passwordController = TextEditingController(text: user?.password ?? '');
      initialized = true;
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void saveChanges() {
    final provider = UserProvider.of(context);
    final currentUser = provider.user;
    if (currentUser == null) return;

    provider.setUser(
      currentUser.copyWith(
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      ),
    );

    setState(() => isEditing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile Synced Successfully"),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = UserProvider.of(context).user;

    if (user == null || user.role != "doctor") {
      return const Center(child: Text("Access Denied"));
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // --- Premium Header Section ---
          Stack(
            children: [
              Container(
                height: 230,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0D47A1), Color(0xFF1976D2), Color(0xFF42A5F5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),
              Positioned(
                top: 50,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: const CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.medical_services_rounded, size: 50, color: Color(0xFF1976D2)),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => isEditing = !isEditing),
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: isEditing ? Colors.green : Colors.white,
                            child: Icon(isEditing ? Icons.check : Icons.edit, size: 18, color: isEditing ? Colors.white : Colors.blue),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Dr. ${user.username}",
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Specialist Surgeon • Verified",
                      style: TextStyle(color: Colors.white70, fontSize: 14, letterSpacing: 0.5),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // --- Stats Bar (New) ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat("1.2k", "Patients"),
                _buildStat("12", "Years Exp."),
                _buildStat("4.9", "Rating"),
              ],
            ),
          ),

          // --- Info Section ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(color: Colors.blue.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildEnhancedField(
                      label: "Public Display Name",
                      icon: Icons.badge_outlined,
                      controller: usernameController,
                    ),
                    const Divider(height: 30),
                    _buildEnhancedField(
                      label: "Professional Email",
                      icon: Icons.alternate_email_rounded,
                      controller: emailController,
                    ),
                    const Divider(height: 30),
                    _buildEnhancedField(
                      label: "Account Password",
                      icon: Icons.fingerprint_rounded,
                      controller: passwordController,
                      isPassword: true,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // --- Bottom Action ---
          Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                if (isEditing)
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 5,
                        shadowColor: Colors.blue.withOpacity(0.4),
                      ),
                      onPressed: saveChanges,
                      child: const Text("UPDATE PROFESSIONAL PROFILE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                const SizedBox(height: 15),
                TextButton.icon(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                  icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                  label: const Text("Logout from Session", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1976D2))),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildEnhancedField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: Colors.blue.shade700, size: 22),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade400)),
              isEditing
                  ? TextField(
                controller: controller,
                obscureText: isPassword,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(isDense: true, border: UnderlineInputBorder(), contentPadding: EdgeInsets.symmetric(vertical: 5)),
              )
                  : Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  isPassword ? "••••••••" : controller.text,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}