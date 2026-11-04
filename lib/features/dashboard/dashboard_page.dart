import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../sis/sis_controller.dart';
import '../../shared/summary_card.dart';
import '../students/students_page.dart';
import '../courses/courses_page.dart';
import '../enrollments/enrollments_page.dart';
import '../attendance/attendance_page.dart';
import '../grades/grades_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override Widget build(BuildContext context) {
    final s = context.watch<SisController>();
    return Scaffold(appBar: AppBar(title: const Text('Student Information System'),
      actions: [IconButton(onPressed: s.load, icon: const Icon(Icons.refresh), tooltip: 'Refresh')]),
      body: s.isLoading ? const Center(child: CircularProgressIndicator()) :
      RefreshIndicator(onRefresh: s.load, child: ListView(padding: const EdgeInsets.all(20), children: [
        Text('Academic overview', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8), const Text('Manage student records and academic activity.'),
        if (s.errorMessage != null) Text(s.errorMessage!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
        const SizedBox(height: 20),
        GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: MediaQuery.sizeOf(context).width > 700 ? 4 : 2,
          crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.5,
          children: [
            SummaryCard(label: 'Students', value: '${s.students.length}', icon: Icons.people),
            SummaryCard(label: 'Courses', value: '${s.courses.length}', icon: Icons.menu_book),
            SummaryCard(label: 'Enrollments', value: '${s.enrollments.length}', icon: Icons.assignment_turned_in),
            SummaryCard(label: 'Grades', value: '${s.grades.length}', icon: Icons.grade),
          ]),
        const SizedBox(height: 24), Text('Modules', style: Theme.of(context).textTheme.titleLarge),
        _tile(context, 'Students', 'Create, search, edit and remove records', Icons.people, const StudentsPage()),
        _tile(context, 'Courses', 'Manage course catalogue', Icons.menu_book, const CoursesPage()),
        _tile(context, 'Enrollments', 'Register students by academic term', Icons.how_to_reg, const EnrollmentsPage()),
        _tile(context, 'Attendance', 'Record daily attendance', Icons.fact_check, const AttendancePage()),
        _tile(context, 'Grades', 'Record assessment scores', Icons.assessment, const GradesPage()),
      ])));
  }
  Widget _tile(BuildContext c, String title, String subtitle, IconData icon, Widget page) =>
    Card(child: ListTile(leading: CircleAvatar(child: Icon(icon)), title: Text(title),
      subtitle: Text(subtitle), trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.push(c, MaterialPageRoute<void>(builder: (_) => page))));
}
