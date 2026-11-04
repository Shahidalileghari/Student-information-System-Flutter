import 'package:sqflite/sqflite.dart';
import '../../domain/repositories/sis_repository.dart';
import '../../domain/models/student.dart';
import '../../domain/models/course.dart';
import '../../domain/models/enrollment.dart';
import '../../domain/models/attendance_record.dart';
import '../../domain/models/grade_record.dart';
import '../database/app_database.dart';

class SqliteSisRepository implements SisRepository {
  SqliteSisRepository(this.database);
  final AppDatabase database;
  Future<Database> get db => database.database;
  @override Future<List<Student>> getStudents() async => (await (await db).query('students', orderBy: 'full_name')).map(Student.fromMap).toList();
  @override Future<void> saveStudent(Student v) async { await (await db).insert('students', v.toMap(), conflictAlgorithm: ConflictAlgorithm.replace); }
  @override Future<void> deleteStudent(String id) async { await (await db).delete('students', where: 'id=?', whereArgs: [id]); }
  @override Future<List<Course>> getCourses() async => (await (await db).query('courses', orderBy: 'code')).map(Course.fromMap).toList();
  @override Future<void> saveCourse(Course v) async { await (await db).insert('courses', v.toMap(), conflictAlgorithm: ConflictAlgorithm.replace); }
  @override Future<List<Enrollment>> getEnrollments() async => (await (await db).query('enrollments', orderBy: 'enrolled_at DESC')).map(Enrollment.fromMap).toList();
  @override Future<void> saveEnrollment(Enrollment v) async { await (await db).insert('enrollments', v.toMap()); }
  @override Future<List<AttendanceRecord>> getAttendance() async => (await (await db).query('attendance', orderBy: 'date DESC')).map(AttendanceRecord.fromMap).toList();
  @override Future<void> saveAttendance(AttendanceRecord v) async { await (await db).insert('attendance', v.toMap()); }
  @override Future<List<GradeRecord>> getGrades() async => (await (await db).query('grades')).map(GradeRecord.fromMap).toList();
  @override Future<void> saveGrade(GradeRecord v) async { await (await db).insert('grades', v.toMap()); }
}
