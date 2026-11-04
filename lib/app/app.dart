import 'package:flutter/material.dart';
import 'app_theme.dart';
import '../features/dashboard/dashboard_page.dart';

class StudentInformationApp extends StatelessWidget {
  const StudentInformationApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Student Information System',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    themeMode: ThemeMode.system,
    home: const DashboardPage(),
  );
}
