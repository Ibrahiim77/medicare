class Doctor {
  final int? id;
  final String name;
  final String specialty;

  Doctor({
    this.id,
    required this.name,
    required this.specialty,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()),
      name: json['name'] ?? "",
      specialty: json['specialty'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "specialty": specialty,
    };
  }
}