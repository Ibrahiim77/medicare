import 'package:flutter/material.dart';
import 'appointments_provider.dart';
import 'user_provider.dart';
import 'main_screen.dart';
import 'screens/home_page.dart';
import 'screens/profile_page.dart';
import 'screens/form_page.dart';
import 'screens/appointments_page.dart';
import 'authorization/Login.dart';
import 'authorization/Signup.dart';
import 'package:check/Doctors/doctos.dart';
import 'package:check/Doctors/doctorsNav.dart';
import 'package:check/Doctors/Docprofile.dart';
import 'Doctors/Doctorsappointment.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppointmentStore(
      child: UserStore(

          child: MaterialApp(
            initialRoute: '/',
            routes: {
              '/':             (context) => const LoginPage(),
              '/home':         (context) => const HomePage(),
              '/form':         (context) => const FormPage(),
              '/profile':      (context) => const ProfilePage(),
              '/signup':       (context) => const SignupPage(),
              '/appointments': (context) => const AppointmentsPage(),
              '/doctors':      (context) => DoctorsPage(),
              '/docprofile' : (context) => DocProfilePage(),
              '/doctorsappointment' : (context) => DocAppointmentsPage(),
            },
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
          ),
        ),
    );
  }
}