
class Alarm {
  final String id;
  final String title;
  final String? note; // Optional note
  final DateTime dateTime;
  final bool isActive;

  Alarm({
    required this.id,
    required this.title,
    this.note,
    required this.dateTime,
    this.isActive = true,
  });

  factory Alarm.fromMap(Map<String, dynamic> json) {
    return Alarm(
      id: json['id'],
      title: json['title'],
      note: json['note'], // can be null
      dateTime: DateTime.parse(json['dateTime']),
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'dateTime': dateTime.toIso8601String(),
      'isActive': isActive,
    };
  }

  Alarm copyWith({
    String? id,
    String? title,
    String? note,
    DateTime? dateTime,
    bool? isActive,
  }) {
    return Alarm(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      dateTime: dateTime ?? this.dateTime,
      isActive: isActive ?? this.isActive,
    );
  }
}
