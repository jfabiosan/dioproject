import 'package:dioproject/page/splash_page.dart';
import 'package:dioproject/repository/database_sqflite.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'service_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseSqflite
      .instance.database; // Inicializa o banco de dados SQFlite
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ServiceProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flash Note',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashPage(),
      ),
    );
  }
}
