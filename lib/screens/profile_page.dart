import 'package:flutter/material.dart';
import '../main_screen.dart';
import '../user_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
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
      SnackBar(
        content: const Text("Profile Settings Saved"),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.blue.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = UserProvider.of(context).user;
    if (user == null) return const Center(child: Text("No user logged in"));

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // --- Modern User Header ---
          Stack(
            children: [
              Container(
                height: 215,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade800, Colors.blue.shade400],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 54,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          child: const CircleAvatar(
                            radius: 50,

                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => isEditing = !isEditing),
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: isEditing ? Colors.green : Colors.white,
                            child: Icon(isEditing ? Icons.done : Icons.camera_alt, size: 16, color: isEditing ? Colors.white : Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user.username,
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Premium Member",
                      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13, letterSpacing: 1),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // --- User Health Stats (New) ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatTile(Icons.directions_run, "6.4k", "Steps", Colors.orange),
                _buildStatTile(Icons.favorite, "72", "BPM", Colors.redAccent),
                _buildStatTile(Icons.water_drop, "2.4L", "Water", Colors.blue),
              ],
            ),
          ),

          // --- Information Card ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildEditableRow(
                      icon: Icons.person_pin_rounded,
                      label: "User ID",
                      controller: usernameController,
                    ),
                    const Divider(height: 35, thickness: 0.5),
                    _buildEditableRow(
                      icon: Icons.alternate_email_rounded,
                      label: "Email Address",
                      controller: emailController,
                    ),
                    const Divider(height: 35, thickness: 0.5),
                    _buildEditableRow(
                      icon: Icons.lock_person_rounded,
                      label: "Account Password",
                      controller: passwordController,
                      isPassword: true,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // --- Action Section ---
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
                        backgroundColor: Colors.blue.shade700,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        elevation: 4,
                      ),
                      onPressed: saveChanges,
                      child: const Text("SAVE CHANGES", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                    ),
                  ),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                  icon: const Icon(Icons.power_settings_new_rounded, color: Colors.grey),
                  label: const Text("Sign Out", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatTile(IconData icon, String value, String label, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  Widget _buildEditableRow({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue.shade50,
          radius: 20,
          child: Icon(icon, color: Colors.blue.shade700, size: 20),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blueGrey.shade300)),
              const SizedBox(height: 2),
              isEditing
                  ? TextField(
                controller: controller,
                obscureText: isPassword,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                decoration: const InputDecoration(isDense: true, border: UnderlineInputBorder()),
              )
                  : Text(
                isPassword ? "••••••••" : controller.text,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );
  }
}