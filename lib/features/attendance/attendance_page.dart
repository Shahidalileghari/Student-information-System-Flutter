import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/attendance_record.dart';
import '../sis/sis_controller.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});
  @override Widget build(BuildContext context) {
    final s = context.watch<SisController>();
    return Scaffold(appBar: AppBar(title: const Text('Attendance')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: s.enrollments.isEmpty ? null : () => _add(context),
        icon: const Icon(Icons.add), label: const Text('Record attendance')),
      body: s.attendance.isEmpty ? const Center(child: Text('No attendance records yet.')) :
        ListView(children: [for (final a in s.attendance)
          ListTile(leading: Icon(a.status==AttendanceStatus.present ? Icons.check_circle :
            a.status==AttendanceStatus.late ? Icons.schedule : Icons.cancel),
            title: Text(a.status.name.toUpperCase()),
            subtitle: Text('${a.date.toIso8601String().substring(0,10)} • ${a.enrollmentId.substring(0,8)}'))]));
  }
  Future<void> _add(BuildContext context) async {
    final s = context.read<SisController>();
    String enrollment = s.enrollments.first.id;
    AttendanceStatus status = AttendanceStatus.present;
    await showDialog<void>(context: context, builder: (d) => StatefulBuilder(builder: (context,set)=>AlertDialog(
      title: const Text('Record attendance'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        DropdownButtonFormField<String>(value: enrollment, decoration: const InputDecoration(labelText: 'Enrollment'),
          items: s.enrollments.map((e) {
            final st=s.students.where((x)=>x.id==e.studentId).firstOrNull;
            final co=s.courses.where((x)=>x.id==e.courseId).firstOrNull;
            return DropdownMenuItem(value:e.id,child:Text('${st?.fullName ?? 'Student'} • ${co?.code ?? 'Course'}'));
          }).toList(), onChanged:(v)=>set(()=>enrollment=v!)),
        const SizedBox(height: 12),
        DropdownButtonFormField<AttendanceStatus>(value:status, decoration: const InputDecoration(labelText:'Status'),
          items: AttendanceStatus.values.map((v)=>DropdownMenuItem(value:v,child:Text(v.name))).toList(),
          onChanged:(v)=>set(()=>status=v!)),
      ]),
      actions: [
        TextButton(onPressed:()=>Navigator.pop(d),child:const Text('Cancel')),
        FilledButton(onPressed:() async {
          try { await s.recordAttendance(enrollmentId:enrollment,date:DateTime.now(),status:status);
            if(d.mounted) Navigator.pop(d);
          } catch(e) { ScaffoldMessenger.of(d).showSnackBar(SnackBar(content:Text(e.toString()))); }
        },child:const Text('Save')),
      ])));
  }
}
