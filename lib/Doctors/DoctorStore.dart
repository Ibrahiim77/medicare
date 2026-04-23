import 'package:flutter/material.dart';


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
    name: "Dr. Ahmed",
    email: "ahmed@hospital.com",
    password: "ahmed123",
    specialty: "Cardiologist",
  ),
  Doctor(
    name: "Dr. Sara",
    email: "sara@hospital.com",
    password: "sara123",
    specialty: "Neurologist",
  ),
];


class DoctorProvider extends InheritedWidget {
  final Doctor? loggedInDoctor;
  final void Function(Doctor) loginDoctor;
  final void Function() logoutDoctor;

  const DoctorProvider({
    super.key,
    required this.loggedInDoctor,
    required this.loginDoctor,
    required this.logoutDoctor,
    required super.child,
  });


  static DoctorProvider of(BuildContext context) {
    final provider =
    context.dependOnInheritedWidgetOfExactType<DoctorProvider>();
    assert(provider != null, 'No DoctorProvider found in widget tree');
    return provider!;
  }


  @override
  bool updateShouldNotify(DoctorProvider oldWidget) =>
      loggedInDoctor != oldWidget.loggedInDoctor;
}


class DoctorStore extends StatefulWidget {
  final Widget child;
  const DoctorStore({super.key, required this.child});

  @override
  State<DoctorStore> createState() => _DoctorStoreState();
}

class _DoctorStoreState extends State<DoctorStore> {
  Doctor? _loggedInDoctor;

  void _login(Doctor doctor) {
    setState(() => _loggedInDoctor = doctor);
  }

  void _logout() {
    setState(() => _loggedInDoctor = null);
  }

  @override
  Widget build(BuildContext context) {
    return DoctorProvider(
      loggedInDoctor: _loggedInDoctor,
      loginDoctor: _login,
      logoutDoctor: _logout,
      child: widget.child,
    );
  }
}