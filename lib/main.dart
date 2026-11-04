import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/app.dart';
import 'data/database/app_database.dart';
import 'data/repositories/sqlite_sis_repository.dart';
import 'features/sis/sis_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
  await database.database;
  runApp(ChangeNotifierProvider(
    create: (_) => SisController(SqliteSisRepository(database))..load(),
    child: const StudentInformationApp(),
  ));
}
