import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:student_information_system/app/app.dart';
import 'package:student_information_system/features/sis/sis_controller.dart';
import 'package:student_information_system/domain/repositories/sis_repository.dart';
import 'package:student_information_system/domain/models/student.dart';
import 'package:student_information_system/domain/models/course.dart';
import 'package:student_information_system/domain/models/enrollment.dart';
import 'package:student_information_system/domain/models/attendance_record.dart';
import 'package:student_information_system/domain/models/grade_record.dart';

class FakeRepo implements SisRepository {
  @override Future<List<Student>> getStudents() async => [];
  @override Future<void> saveStudent(Student v) async {}
  @override Future<void> deleteStudent(String id) async {}
  @override Future<List<Course>> getCourses() async => [];
  @override Future<void> saveCourse(Course v) async {}
  @override Future<List<Enrollment>> getEnrollments() async => [];
  @override Future<void> saveEnrollment(Enrollment v) async {}
  @override Future<List<AttendanceRecord>> getAttendance() async => [];
  @override Future<void> saveAttendance(AttendanceRecord v) async {}
  @override Future<List<GradeRecord>> getGrades() async => [];
  @override Future<void> saveGrade(GradeRecord v) async {}
}
void main() {
  testWidgets('dashboard renders main modules', (tester) async {
    await tester.pumpWidget(ChangeNotifierProvider(
      create: (_) => SisController(FakeRepo())..load(),
      child: const StudentInformationApp()));
    await tester.pumpAndSettle();
    expect(find.text('Student Information System'), findsOneWidget);
    expect(find.text('Students'), findsOneWidget);
    expect(find.text('Courses'), findsOneWidget);
    expect(find.text('Attendance'), findsOneWidget);
  });
}
