class Reminder {
  final int id;
  final int userId;
  final int medicineId;
  final String name;
  final String dose;
  final DateTime time;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Reminder({
    required this.id,
    required this.userId,
    required this.medicineId,
    required this.name,
    required this.dose,
    required this.time,
    this.createdAt,
    this.updatedAt,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      userId: json['user_id'],
      medicineId: json['medicine_id'],
      name: json['name'],
      dose: json['dose'],
      time: DateTime.parse(json['time']),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  get daysOfWeek => null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'medicine_id': medicineId,
      'name': name,
      'dose': dose,
      'time': time.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}