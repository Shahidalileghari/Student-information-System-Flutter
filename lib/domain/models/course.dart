class Course {
  const Course({required this.id, required this.code, required this.title,
    required this.creditHours, required this.instructor});
  final String id, code, title, instructor;
  final int creditHours;
  Map<String, Object?> toMap() => {'id': id, 'code': code, 'title': title,
    'credit_hours': creditHours, 'instructor': instructor};
  factory Course.fromMap(Map<String, Object?> m) => Course(
    id: m['id']! as String, code: m['code']! as String,
    title: m['title']! as String, creditHours: m['credit_hours']! as int,
    instructor: m['instructor']! as String);
}
