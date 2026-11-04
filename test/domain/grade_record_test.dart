import 'package:flutter_test/flutter_test.dart';
import 'package:student_information_system/domain/models/grade_record.dart';
void main() {
  test('percentage calculation', () {
    const g=GradeRecord(id:'g',enrollmentId:'e',assessment:'Midterm',score:42,maxScore:50);
    expect(g.percentage,84);
  });
}
