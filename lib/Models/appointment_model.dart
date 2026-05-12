class Appointment {
  final int? id;
  final String patientName; // Changed from name
  final String reason;
  final String date;
  final String time;
  final String status;
  final String doctorName;

  Appointment({
    this.id,
    required this.patientName,
    required this.reason,
    required this.date,
    required this.time,
    required this.doctorName,
    this.status = "Pending",
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] == null ? null : int.tryParse(json['id'].toString()),
      // Map the DB keys (snake_case) to your Flutter properties
      patientName: json['patient_name'] ?? json['name'] ?? "Unknown",
      doctorName: json['doctor_name'] ?? json['doctorName'] ?? "Unknown",
      reason: json['reason'] ?? "",
      date: json['date'] ?? "",
      time: json['time'] ?? "",
      status: json['status'] ?? "Pending",
    );
  }
}