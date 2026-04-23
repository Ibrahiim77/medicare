import 'package:flutter/material.dart';

class Appointment {
  final String name;
  final String reason;
  final DateTime date;
  final TimeOfDay time;
  final String status;
  final String email;
  final String doctorName;

  Appointment({
    required this.name,
    required this.reason,
    required this.date,
    required this.time,
    this.status = "Pending",
    this.email = '',
    this.doctorName = '',
  });

  Appointment copyWith({String? status}) {
    return Appointment(
      name: name,
      reason: reason,
      date: date,
      time: time,
      email: email,
      doctorName: doctorName,
      status: status ?? this.status,
    );
  }
}

class AppointmentProvider extends InheritedWidget {
  final List<Appointment> appointments;
  final void Function(Appointment) addAppointment;
  final void Function(int index, String status) updateStatus;

  const AppointmentProvider({
    super.key,
    required this.appointments,
    required this.addAppointment,
    required this.updateStatus,
    required super.child,
  });

  static AppointmentProvider of(BuildContext context) {
    final provider =
    context.dependOnInheritedWidgetOfExactType<AppointmentProvider>();
    assert(provider != null, 'No AppointmentProvider found in widget tree');
    return provider!;
  }

  @override
  bool updateShouldNotify(AppointmentProvider oldWidget) =>
      appointments != oldWidget.appointments;
}

class AppointmentStore extends StatefulWidget {
  final Widget child;
  const AppointmentStore({super.key, required this.child});

  @override
  State<AppointmentStore> createState() => _AppointmentStoreState();
}

class _AppointmentStoreState extends State<AppointmentStore> {
  final List<Appointment> _appointments = [];

  void _add(Appointment a) {
    setState(() => _appointments.add(a));
  }

  void _updateStatus(int index, String status) {
    setState(() {
      _appointments[index] = _appointments[index].copyWith(status: status);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppointmentProvider(
      appointments: List.unmodifiable(_appointments),
      addAppointment: _add,
      updateStatus: _updateStatus,
      child: widget.child,
    );
  }
}