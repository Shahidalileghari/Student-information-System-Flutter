import 'package:flutter_test/flutter_test.dart';
import 'package:student_information_system/domain/models/student.dart';

void main() {
  test('student map round-trip preserves core fields', () {
    final s = Student(id:'id-1',rollNumber:'SE-001',fullName:'Ayesha Khan',
      email:'a@example.com',phone:'03000000000',department:'Software Engineering',
      semester:5,admissionDate:DateTime(2024,9,1));
    final restored=Student.fromMap(s.toMap());
    expect(restored.id,s.id); expect(restored.rollNumber,s.rollNumber);
    expect(restored.fullName,s.fullName); expect(restored.semester,5);
  });
}
