import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  Database? _db;
  Future<Database> get database async {
    if (_db != null) return _db!;
    final path = p.join(await getDatabasesPath(), 'student_information_system.db');
    _db = await openDatabase(path, version: 1,
      onConfigure: (db) async => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE students(
          id TEXT PRIMARY KEY, roll_number TEXT NOT NULL UNIQUE, full_name TEXT NOT NULL,
          email TEXT NOT NULL, phone TEXT NOT NULL, department TEXT NOT NULL,
          semester INTEGER NOT NULL CHECK(semester BETWEEN 1 AND 12),
          admission_date TEXT NOT NULL, is_active INTEGER NOT NULL DEFAULT 1)''');
        await db.execute('''CREATE TABLE courses(
          id TEXT PRIMARY KEY, code TEXT NOT NULL UNIQUE, title TEXT NOT NULL,
          credit_hours INTEGER NOT NULL CHECK(credit_hours BETWEEN 1 AND 6),
          instructor TEXT NOT NULL)''');
        await db.execute('''CREATE TABLE enrollments(
          id TEXT PRIMARY KEY, student_id TEXT NOT NULL REFERENCES students(id) ON DELETE CASCADE,
          course_id TEXT NOT NULL REFERENCES courses(id) ON DELETE CASCADE, term TEXT NOT NULL,
          enrolled_at TEXT NOT NULL, UNIQUE(student_id, course_id, term))''');
        await db.execute('''CREATE TABLE attendance(
          id TEXT PRIMARY KEY, enrollment_id TEXT NOT NULL REFERENCES enrollments(id) ON DELETE CASCADE,
          date TEXT NOT NULL, status TEXT NOT NULL CHECK(status IN ('present','absent','late')),
          UNIQUE(enrollment_id, date))''');
        await db.execute('''CREATE TABLE grades(
          id TEXT PRIMARY KEY, enrollment_id TEXT NOT NULL REFERENCES enrollments(id) ON DELETE CASCADE,
          assessment TEXT NOT NULL, score REAL NOT NULL CHECK(score >= 0),
          max_score REAL NOT NULL CHECK(max_score > 0 AND score <= max_score))''');
      });
    return _db!;
  }
}
