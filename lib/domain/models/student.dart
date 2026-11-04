class Student {
  const Student({required this.id, required this.rollNumber, required this.fullName,
    required this.email, required this.phone, required this.department,
    required this.semester, required this.admissionDate, this.isActive = true});
  final String id, rollNumber, fullName, email, phone, department;
  final int semester;
  final DateTime admissionDate;
  final bool isActive;
  Map<String, Object?> toMap() => {
    'id': id, 'roll_number': rollNumber, 'full_name': fullName, 'email': email,
    'phone': phone, 'department': department, 'semester': semester,
    'admission_date': admissionDate.toIso8601String(), 'is_active': isActive ? 1 : 0,
  };
  factory Student.fromMap(Map<String, Object?> m) => Student(
    id: m['id']! as String, rollNumber: m['roll_number']! as String,
    fullName: m['full_name']! as String, email: m['email']! as String,
    phone: m['phone']! as String, department: m['department']! as String,
    semester: m['semester']! as int,
    admissionDate: DateTime.parse(m['admission_date']! as String),
    isActive: m['is_active']! == 1,
  );
  Student copyWith({String? rollNumber, String? fullName, String? email, String? phone,
    String? department, int? semester, bool? isActive}) => Student(
      id: id, rollNumber: rollNumber ?? this.rollNumber,
      fullName: fullName ?? this.fullName, email: email ?? this.email,
      phone: phone ?? this.phone, department: department ?? this.department,
      semester: semester ?? this.semester, admissionDate: admissionDate,
      isActive: isActive ?? this.isActive);
}
