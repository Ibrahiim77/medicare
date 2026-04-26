import 'package:flutter/material.dart';


enum UserRole {
  user,
  doctor,
  admin,
}


class Doctor {
  final String name;
  final String email;
  final String password;
  final String specialty;

  const Doctor({
    required this.name,
    required this.email,
    required this.password,
    required this.specialty,
  });
}

const List<Doctor> availableDoctors = [
  Doctor(
    name: "Dr. Ahmed Khan",
    email: "ahmed@hospital.com",
    password: "ahmed123",
    specialty: "Cardiologist",
  ),
  Doctor(
    name: "Dr. Sara Malik",
    email: "sara@hospital.com",
    password: "sara123",
    specialty: "Neurologist",
  ),
  Doctor(
    name: "Dr. Usman Ali",
    email: "usman@hospital.com",
    password: "usman123",
    specialty: "Dermatologist",
  ),
  Doctor(
    name: "Dr. Ayesha Rahman",
    email: "ayesha@hospital.com",
    password: "ayesha123",
    specialty: "Pediatrician",
  ),
  Doctor(
    name: "Dr. Hamza Iqbal",
    email: "hamza@hospital.com",
    password: "hamza123",
    specialty: "Orthopedic Surgeon",
  ),
];


class Admin {
  final String email;
  final String password;

  const Admin({
    required this.email,
    required this.password,
  });
}

const List<Admin> admins = [
  Admin(
    email: "admin@hospital.com",
    password: "admin123",
  ),
];


class UserData {
  final String username;
  final String email;
  final String password;
  final UserRole role;

  UserData({
    required this.username,
    required this.email,
    required this.password,
    required this.role,
  });

  UserData copyWith({
    String? username,
    String? email,
    String? password,
    UserRole? role,
  }) {
    return UserData(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
    );
  }
}


class UserProvider extends InheritedWidget {
  final UserData? user;
  final void Function(UserData) setUser;
  final void Function() logout;

  const UserProvider({
    super.key,
    required this.user,
    required this.setUser,
    required this.logout,
    required super.child,
  });

  static UserProvider of(BuildContext context) {
    final provider =
    context.dependOnInheritedWidgetOfExactType<UserProvider>();
    assert(provider != null, 'No UserProvider found in widget tree');
    return provider!;
  }

  @override
  bool updateShouldNotify(UserProvider oldWidget) =>
      user != oldWidget.user;
}


class UserStore extends StatefulWidget {
  final Widget child;
  const UserStore({super.key, required this.child});

  @override
  State<UserStore> createState() => _UserStoreState();
}

class _UserStoreState extends State<UserStore> {
  UserData? _user;

  void _setUser(UserData user) {
    setState(() => _user = user);
  }

  void _logout() {
    setState(() => _user = null);
  }

  @override
  Widget build(BuildContext context) {
    return UserProvider(
      user: _user,
      setUser: _setUser,
      logout: _logout,
      child: widget.child,
    );
  }
}


void loginUser({
  required BuildContext context,
  required String email,
  required String password,
}) {

  final adminMatch = admins.where(
        (a) => a.email == email && a.password == password,
  ).toList();

  if (adminMatch.isNotEmpty) {
    UserProvider.of(context).setUser(
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


  final doctorMatch = availableDoctors.where(
        (d) => d.email == email && d.password == password,
  ).toList();

  if (doctorMatch.isNotEmpty) {
    final doc = doctorMatch.first;

    UserProvider.of(context).setUser(
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


  final user = UserProvider.of(context).user;

  if (user == null) return;

  if (user.email == email && user.password == password) {
    UserProvider.of(context).setUser(
      user.copyWith(role: UserRole.user),
    );

    Navigator.pushReplacementNamed(context, '/home');
  }
}