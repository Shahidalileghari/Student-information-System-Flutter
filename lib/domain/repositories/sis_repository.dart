import '../models/student.dart';
import '../models/course.dart';
import '../models/enrollment.dart';
import '../models/attendance_record.dart';
import '../models/grade_record.dart';

abstract interface class SisRepository {
  Future<List<Student>> getStudents();
  Future<void> saveStudent(Student value);
  Future<void> deleteStudent(String id);
  Future<List<Course>> getCourses();
  Future<void> saveCourse(Course value);
  Future<List<Enrollment>> getEnrollments();
  Future<void> saveEnrollment(Enrollment value);
  Future<List<AttendanceRecord>> getAttendance();
  Future<void> saveAttendance(AttendanceRecord value);
  Future<List<GradeRecord>> getGrades();
  Future<void> saveGrade(GradeRecord value);
}
