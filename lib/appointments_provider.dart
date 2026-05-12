import 'package:flutter/material.dart';
import 'services/appointment_service.dart';

class Appointment {
  final int? id;
  final String patientName;
  final String doctorName;
  final String reason;
  final String date;
  final String time;
  final String status;

  Appointment({
    this.id,
    required this.patientName,
    required this.doctorName,
    required this.reason,
    required this.date,
    required this.time,
    this.status = "Pending",
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      // Standardizes the naming from your MySQL 'patient_name' column
      patientName: json['patient_name'] ?? json['name'] ?? "Unknown",
      doctorName: json['doctor_name'] ?? "Doctor",
      reason: json['reason'] ?? "",
      date: json['date'] ?? "",
      time: json['time'] ?? "",
      status: json['status'] ?? "Pending",
    );
  }
}

class AppointmentProvider extends InheritedWidget {
  final List<Appointment> appointments;
  final Future<void> Function() refreshAppointments;

  const AppointmentProvider({
    super.key,
    required this.appointments,
    required this.refreshAppointments,
    required super.child,
  });

  static AppointmentProvider of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<AppointmentProvider>();
    assert(provider != null, 'AppointmentProvider not found');
    return provider!;
  }

  @override
  bool updateShouldNotify(AppointmentProvider oldWidget) {
    return oldWidget.appointments != appointments;
  }
}

class AppointmentStore extends StatefulWidget {
  final Widget child;
  const AppointmentStore({super.key, required this.child});

  @override
  State<AppointmentStore> createState() => _AppointmentStoreState();
}

class _AppointmentStoreState extends State<AppointmentStore> {
  List<Appointment> appointments = [];

  @override
  void initState() {
    super.initState();
    loadFromDatabase();
  }

  Future<void> loadFromDatabase() async {
    try {
      final res = await AppointmentService.getAppointments();
      if (res["success"] == true) {
        final List rawData = res["data"] ?? [];
        if (mounted) {
          setState(() {
            appointments = rawData.map((item) => Appointment.fromJson(item)).toList();
          });
        }
      }
    } catch (e) {
      debugPrint("Database Fetch Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppointmentProvider(
      appointments: appointments,
      refreshAppointments: loadFromDatabase,
      child: widget.child,
    );
  }
}