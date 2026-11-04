class Enrollment {
  const Enrollment({required this.id, required this.studentId, required this.courseId,
    required this.term, required this.enrolledAt});
  final String id, studentId, courseId, term;
  final DateTime enrolledAt;
  Map<String, Object?> toMap() => {'id': id, 'student_id': studentId,
    'course_id': courseId, 'term': term, 'enrolled_at': enrolledAt.toIso8601String()};
  factory Enrollment.fromMap(Map<String, Object?> m) => Enrollment(
    id: m['id']! as String, studentId: m['student_id']! as String,
    courseId: m['course_id']! as String, term: m['term']! as String,
    enrolledAt: DateTime.parse(m['enrolled_at']! as String));
}
