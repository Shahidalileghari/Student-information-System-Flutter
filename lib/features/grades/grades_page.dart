import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../sis/sis_controller.dart';

class GradesPage extends StatelessWidget {
  const GradesPage({super.key});
  @override Widget build(BuildContext context) {
    final s=context.watch<SisController>();
    return Scaffold(appBar:AppBar(title:const Text('Grades')),
      floatingActionButton:FloatingActionButton.extended(onPressed:s.enrollments.isEmpty?null:()=>_add(context),
        icon:const Icon(Icons.add),label:const Text('Record grade')),
      body:s.grades.isEmpty?const Center(child:Text('No grades recorded yet.')):
        ListView(children:[for(final g in s.grades)
          ListTile(leading:const CircleAvatar(child:Icon(Icons.grade)),title:Text(g.assessment),
            subtitle:Text('${g.score}/${g.maxScore} • ${g.percentage.toStringAsFixed(1)}%'))]));
  }
  Future<void> _add(BuildContext context) async {
    final s=context.read<SisController>();
    String enrollment=s.enrollments.first.id;
    final a=TextEditingController(), score=TextEditingController(), max=TextEditingController(text:'100');
    await showDialog<void>(context:context,builder:(d)=>StatefulBuilder(builder:(context,set)=>AlertDialog(
      title:const Text('Record grade'),
      content:SingleChildScrollView(child:Column(mainAxisSize:MainAxisSize.min,children:[
        DropdownButtonFormField<String>(value:enrollment,decoration:const InputDecoration(labelText:'Enrollment'),
          items:s.enrollments.map((e)=>DropdownMenuItem(value:e.id,child:Text(
            '${s.students.where((x)=>x.id==e.studentId).firstOrNull?.fullName ?? 'Student'} • ${s.courses.where((x)=>x.id==e.courseId).firstOrNull?.code ?? 'Course'}'))).toList(),
          onChanged:(v)=>set(()=>enrollment=v!)),
        TextField(controller:a,decoration:const InputDecoration(labelText:'Assessment')),
        TextField(controller:score,keyboardType:TextInputType.number,decoration:const InputDecoration(labelText:'Score')),
        TextField(controller:max,keyboardType:TextInputType.number,decoration:const InputDecoration(labelText:'Maximum score')),
      ])),
      actions:[
        TextButton(onPressed:()=>Navigator.pop(d),child:const Text('Cancel')),
        FilledButton(onPressed:() async {
          try { await s.recordGrade(enrollmentId:enrollment,assessment:a.text,
            score:double.parse(score.text),maxScore:double.parse(max.text));
            if(d.mounted) Navigator.pop(d);
          } catch(e) { ScaffoldMessenger.of(d).showSnackBar(SnackBar(content:Text(e.toString()))); }
        },child:const Text('Save')),
      ])));
    for(final c in [a,score,max]) { c.dispose(); }
  }
}
