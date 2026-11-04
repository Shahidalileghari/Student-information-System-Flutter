import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../sis/sis_controller.dart';

class EnrollmentsPage extends StatelessWidget {
  const EnrollmentsPage({super.key});
  @override Widget build(BuildContext context) {
    final s = context.watch<SisController>();
    return Scaffold(appBar: AppBar(title: const Text('Enrollments')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: s.students.isEmpty || s.courses.isEmpty ? null : () => _add(context),
        icon: const Icon(Icons.add), label: const Text('Enroll student')),
      body: s.enrollments.isEmpty ? const Center(child: Text('No enrollments recorded.')) :
        ListView(children: [for (final e in s.enrollments)
          ListTile(leading: const Icon(Icons.assignment_turned_in),
            title: Text(s.students.where((x)=>x.id==e.studentId).firstOrNull?.fullName ?? 'Unknown student'),
            subtitle: Text('${s.courses.where((x)=>x.id==e.courseId).firstOrNull?.code ?? 'Unknown course'} • ${e.term}'))]));
  }
  Future<void> _add(BuildContext context) async {
    final s = context.read<SisController>();
    String? student = s.students.first.id, course = s.courses.first.id;
    final term = TextEditingController(text: 'Fall 2026');
    await showDialog<void>(context: context, builder: (d) => StatefulBuilder(builder: (context, set) => AlertDialog(
      title: const Text('Enroll student'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        DropdownButtonFormField<String>(value: student, decoration: const InputDecoration(labelText: 'Student'),
          items: s.students.map((x)=>DropdownMenuItem(value:x.id,child:Text('${x.rollNumber} — ${x.fullName}'))).toList(),
          onChanged: (v)=>set(()=>student=v)),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(value: course, decoration: const InputDecoration(labelText: 'Course'),
          items: s.courses.map((x)=>DropdownMenuItem(value:x.id,child:Text('${x.code} — ${x.title}'))).toList(),
          onChanged: (v)=>set(()=>course=v)),
        const SizedBox(height: 12), TextField(controller: term, decoration: const InputDecoration(labelText: 'Academic term')),
      ]),
      actions: [
        TextButton(onPressed: ()=>Navigator.pop(d), child: const Text('Cancel')),
        FilledButton(onPressed: () async {
          try { await s.enroll(studentId: student!, courseId: course!, term: term.text);
            if (d.mounted) Navigator.pop(d);
          } catch(e) { ScaffoldMessenger.of(d).showSnackBar(SnackBar(content: Text(e.toString()))); }
        }, child: const Text('Enroll')),
      ])));
    term.dispose();
  }
}
