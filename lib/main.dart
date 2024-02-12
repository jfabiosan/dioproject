import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'page/task_page.dart';
import 'service_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ServiceProvider(),
      child: MaterialApp(
        title: 'Lista de Tarefas',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const TaskPage(),
      ),
    );
  }
}
