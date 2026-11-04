import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../domain/repositories/sis_repository.dart';
import '../../domain/models/student.dart';
import '../../domain/models/course.dart';
import '../../domain/models/enrollment.dart';
import '../../domain/models/attendance_record.dart';
import '../../domain/models/grade_record.dart';

class SisController extends ChangeNotifier {
  SisController(this.repo);
  final SisRepository repo;
  final Uuid _uuid = const Uuid();
  List<Student> students = [];
  List<Course> courses = [];
  List<Enrollment> enrollments = [];
  List<AttendanceRecord> attendance = [];
  List<GradeRecord> grades = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true; errorMessage = null; notifyListeners();
    try {
      final values = await Future.wait([repo.getStudents(), repo.getCourses(),
        repo.getEnrollments(), repo.getAttendance(), repo.getGrades()]);
      students = values[0] as List<Student>; courses = values[1] as List<Course>;
      enrollments = values[2] as List<Enrollment>; attendance = values[3] as List<AttendanceRecord>;
      grades = values[4] as List<GradeRecord>;
    } catch (e) { errorMessage = 'Unable to load records: $e'; }
    finally { isLoading = false; notifyListeners(); }
  }

  Future<void> addStudent({required String rollNumber, required String fullName,
    required String email, required String phone, required String department,
    required int semester}) async {
    if (students.any((s) => s.rollNumber.toLowerCase() == rollNumber.trim().toLowerCase())) {
      throw ArgumentError('Roll number already exists.');
    }
    final v = Student(id: _uuid.v4(), rollNumber: rollNumber.trim(),
      fullName: fullName.trim(), email: email.trim(), phone: phone.trim(),
      department: department.trim(), semester: semester, admissionDate: DateTime.now());
    await repo.saveStudent(v); students = [...students, v]; notifyListeners();
  }

  Future<void> updateStudent(Student v) async {
    if (students.any((s) => s.id != v.id && s.rollNumber.toLowerCase() == v.rollNumber.toLowerCase())) {
      throw ArgumentError('Roll number already exists.');
    }
    await repo.saveStudent(v); students = students.map((s) => s.id == v.id ? v : s).toList(); notifyListeners();
  }

  Future<void> removeStudent(String id) async {
    await repo.deleteStudent(id);
    students = students.where((s) => s.id != id).toList();
    enrollments = enrollments.where((e) => e.studentId != id).toList(); notifyListeners();
  }

  Future<void> addCourse({required String code, required String title,
    required int creditHours, required String instructor}) async {
    if (courses.any((c) => c.code.toLowerCase() == code.trim().toLowerCase())) {
      throw ArgumentError('Course code already exists.');
    }
    final v = Course(id: _uuid.v4(), code: code.trim().toUpperCase(),
      title: title.trim(), creditHours: creditHours, instructor: instructor.trim());
    await repo.saveCourse(v); courses = [...courses, v]; notifyListeners();
  }

  Future<void> enroll({required String studentId, required String courseId, required String term}) async {
    if (!students.any((s) => s.id == studentId) || !courses.any((c) => c.id == courseId)) {
      throw ArgumentError('Select a valid student and course.');
    }
    if (enrollments.any((e) => e.studentId == studentId && e.courseId == courseId && e.term == term.trim())) {
      throw ArgumentError('Duplicate enrollment for this term.');
    }
    final v = Enrollment(id: _uuid.v4(), studentId: studentId, courseId: courseId,
      term: term.trim(), enrolledAt: DateTime.now());
    await repo.saveEnrollment(v); enrollments = [...enrollments, v]; notifyListeners();
  }

  Future<void> recordAttendance({required String enrollmentId, required DateTime date,
    required AttendanceStatus status}) async {
    final d = DateTime(date.year, date.month, date.day);
    if (attendance.any((a) => a.enrollmentId == enrollmentId &&
      a.date.year == d.year && a.date.month == d.month && a.date.day == d.day)) {
      throw ArgumentError('Attendance already recorded for this date.');
    }
    final v = AttendanceRecord(id: _uuid.v4(), enrollmentId: enrollmentId, date: d, status: status);
    await repo.saveAttendance(v); attendance = [...attendance, v]; notifyListeners();
  }

  Future<void> recordGrade({required String enrollmentId, required String assessment,
    required double score, required double maxScore}) async {
    if (assessment.trim().isEmpty || maxScore <= 0 || score < 0 || score > maxScore) {
      throw ArgumentError('Enter a valid assessment and score within the maximum.');
    }
    final v = GradeRecord(id: _uuid.v4(), enrollmentId: enrollmentId,
      assessment: assessment.trim(), score: score, maxScore: maxScore);
    await repo.saveGrade(v); grades = [...grades, v]; notifyListeners();
  }
}
