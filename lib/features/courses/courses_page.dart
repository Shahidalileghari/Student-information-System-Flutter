import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../sis/sis_controller.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});
  @override Widget build(BuildContext context) {
    final s = context.watch<SisController>();
    return Scaffold(appBar: AppBar(title: const Text('Courses')),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => _add(context),
        icon: const Icon(Icons.add), label: const Text('Add course')),
      body: s.courses.isEmpty ? const Center(child: Text('No courses added yet.')) :
        ListView.builder(itemCount: s.courses.length, itemBuilder: (c, i) {
          final v = s.courses[i];
          return ListTile(leading: const CircleAvatar(child: Icon(Icons.menu_book)),
            title: Text('${v.code} — ${v.title}'),
            subtitle: Text('${v.creditHours} credit hours • ${v.instructor}'));
        }));
  }
  Future<void> _add(BuildContext context) async {
    final key = GlobalKey<FormState>();
    final fields = [TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController(text: '3')];
    await showDialog<void>(context: context, builder: (d) => AlertDialog(
      title: const Text('Add course'),
      content: Form(key: key, child: Column(mainAxisSize: MainAxisSize.min, children: [
        for (var i=0; i<4; i++) Padding(padding: const EdgeInsets.only(bottom: 10),
          child: TextFormField(controller: fields[i], keyboardType: i==3 ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(labelText: ['Course code','Course title','Instructor','Credit hours'][i]),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Required';
              if (i==3 && (int.tryParse(v)==null || int.parse(v)<1 || int.parse(v)>6)) return 'Enter 1–6';
              return null;
            })),
      ])),
      actions: [
        TextButton(onPressed: () => Navigator.pop(d), child: const Text('Cancel')),
        FilledButton(onPressed: () async {
          if (!key.currentState!.validate()) return;
          try {
            await context.read<SisController>().addCourse(code: fields[0].text, title: fields[1].text,
              instructor: fields[2].text, creditHours: int.parse(fields[3].text));
            if (d.mounted) Navigator.pop(d);
          } catch (e) { ScaffoldMessenger.of(d).showSnackBar(SnackBar(content: Text(e.toString()))); }
        }, child: const Text('Save')),
      ]));
    for (final f in fields) { f.dispose(); }
  }
}
