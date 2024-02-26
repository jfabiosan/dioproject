import 'package:zionnote/page/splash_page.dart';
import 'package:zionnote/repository/database_sqflite.dart';
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
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.orange,
            toolbarHeight: 70.0,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
        ),
        home: const SplashPage(),
      ),
    );
  }
}
