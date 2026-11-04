enum AttendanceStatus { present, absent, late }
class AttendanceRecord {
  const AttendanceRecord({required this.id, required this.enrollmentId, required this.date, required this.status});
  final String id, enrollmentId;
  final DateTime date;
  final AttendanceStatus status;
  Map<String, Object?> toMap() => {'id': id, 'enrollment_id': enrollmentId,
    'date': date.toIso8601String(), 'status': status.name};
  factory AttendanceRecord.fromMap(Map<String, Object?> m) => AttendanceRecord(
    id: m['id']! as String, enrollmentId: m['enrollment_id']! as String,
    date: DateTime.parse(m['date']! as String),
    status: AttendanceStatus.values.byName(m['status']! as String));
}
