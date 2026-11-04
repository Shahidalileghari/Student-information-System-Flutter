import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/student.dart';
import '../sis/sis_controller.dart';

class StudentsPage extends StatefulWidget {
  const StudentsPage({super.key});
  @override State<StudentsPage> createState() => _StudentsPageState();
}
class _StudentsPageState extends State<StudentsPage> {
  String query = '';
  @override Widget build(BuildContext context) {
    final sis = context.watch<SisController>();
    final items = sis.students.where((s) => '${s.fullName} ${s.rollNumber} ${s.department}'.toLowerCase().contains(query.toLowerCase())).toList();
    return Scaffold(appBar: AppBar(title: const Text('Students')),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => _form(context),
        icon: const Icon(Icons.add), label: const Text('Add student')),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(16), child: TextField(
          decoration: const InputDecoration(prefixIcon: Icon(Icons.search), labelText: 'Search students'),
          onChanged: (v) => setState(() => query = v))),
        Expanded(child: items.isEmpty ? const Center(child: Text('No students found. Add a student to begin.')) :
          ListView.builder(itemCount: items.length, itemBuilder: (context, i) {
            final s = items[i];
            return ListTile(leading: CircleAvatar(child: Text(s.fullName[0].toUpperCase())),
              title: Text(s.fullName), subtitle: Text('${s.rollNumber} • ${s.department} • Semester ${s.semester}'),
              trailing: PopupMenuButton<String>(onSelected: (v) async {
                if (v == 'edit') await _form(context, student: s);
                if (v == 'delete') await context.read<SisController>().removeStudent(s.id);
              }, itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ]));
          })),
      ]));
  }

  Future<void> _form(BuildContext context, {Student? student}) async {
    final key = GlobalKey<FormState>();
    final ctrls = [
      TextEditingController(text: student?.rollNumber ?? ''),
      TextEditingController(text: student?.fullName ?? ''),
      TextEditingController(text: student?.email ?? ''),
      TextEditingController(text: student?.phone ?? ''),
      TextEditingController(text: student?.department ?? ''),
    ];
    var semester = student?.semester ?? 1;
    await showDialog<void>(context: context, builder: (dialog) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(student == null ? 'Add student' : 'Edit student'),
        content: SizedBox(width: 420, child: SingleChildScrollView(child: Form(key: key,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            _field(ctrls[0], 'Roll number'), _field(ctrls[1], 'Full name'),
            _field(ctrls[2], 'Email', email: true), _field(ctrls[3], 'Phone'),
            _field(ctrls[4], 'Department'),
            DropdownButtonFormField<int>(value: semester, decoration: const InputDecoration(labelText: 'Semester'),
              items: List.generate(12, (i) => DropdownMenuItem(value: i+1, child: Text('${i+1}'))),
              onChanged: (v) => setState(() => semester = v ?? 1)),
          ])))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialog), child: const Text('Cancel')),
          FilledButton(onPressed: () async {
            if (!key.currentState!.validate()) return;
            try {
              final c = context.read<SisController>();
              if (student == null) {
                await c.addStudent(rollNumber: ctrls[0].text, fullName: ctrls[1].text,
                  email: ctrls[2].text, phone: ctrls[3].text, department: ctrls[4].text, semester: semester);
              } else {
                await c.updateStudent(student.copyWith(rollNumber: ctrls[0].text.trim(),
                  fullName: ctrls[1].text.trim(), email: ctrls[2].text.trim(), phone: ctrls[3].text.trim(),
                  department: ctrls[4].text.trim(), semester: semester));
              }
              if (dialog.mounted) Navigator.pop(dialog);
            } catch (e) { ScaffoldMessenger.of(dialog).showSnackBar(SnackBar(content: Text(e.toString()))); }
          }, child: const Text('Save')),
        ],
      )));
    for (final c in ctrls) { c.dispose(); }
  }

  Widget _field(TextEditingController c, String label, {bool email = false}) =>
    Padding(padding: const EdgeInsets.only(bottom: 12), child: TextFormField(
      controller: c, keyboardType: email ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(labelText: label),
      validator: (v) {
        final x = v?.trim() ?? '';
        if (x.isEmpty) return '$label is required';
        if (email && !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(x)) return 'Enter a valid email';
        return null;
      }));
}
