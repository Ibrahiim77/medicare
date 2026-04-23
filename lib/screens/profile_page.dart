import 'package:flutter/material.dart';
import '../main_screen.dart';
import '../user_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});


  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 3,
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: EditableProfileBody(),
      ),
    );
  }
}

class EditableProfileBody extends StatefulWidget {
  const EditableProfileBody({super.key});

  @override
  State<EditableProfileBody> createState() => _EditableProfileBodyState();
}

class _EditableProfileBodyState extends State<EditableProfileBody> {
  bool isEditingUsername = false;
  bool isEditingEmail = false;
  bool isEditingPassword = false;


  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final user = UserProvider.of(context).user;
    usernameController = TextEditingController(text: user?.username ?? '');
    emailController = TextEditingController(text: user?.email ?? '');
    passwordController = TextEditingController(text: user?.password ?? '');
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void saveChanges() {

    UserProvider.of(context).updateUser(
      usernameController.text.trim(),
      emailController.text.trim(),
      passwordController.text.trim(),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated!")),
    );
  }

  Widget buildEditableField({
    required String label,
    required TextEditingController controller,
    required bool isEditing,
    required Function toggleEdit,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: isEditing
                  ? TextField(
                controller: controller,
                obscureText: isPassword,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              )
                  : Container(
                height: 50,
                padding:
                const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person),
                    const SizedBox(width: 5),
                    Text(
                      isPassword ? "••••••••" : controller.text,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: Icon(isEditing ? Icons.check : Icons.edit),
              onPressed: () {
                setState(() => toggleEdit());
                if (isEditing) saveChanges();
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 65,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 20),
        buildEditableField(
          label: "Username",
          controller: usernameController,
          isEditing: isEditingUsername,
          toggleEdit: () => isEditingUsername = !isEditingUsername,
        ),
        buildEditableField(
          label: "Email",
          controller: emailController,
          isEditing: isEditingEmail,
          toggleEdit: () => isEditingEmail = !isEditingEmail,
        ),
        buildEditableField(
          label: "Password",
          controller: passwordController,
          isEditing: isEditingPassword,
          toggleEdit: () => isEditingPassword = !isEditingPassword,
          isPassword: true,
        ),
      ],
    );
  }
}