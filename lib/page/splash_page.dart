import 'dart:async';
import 'package:flutter/material.dart';
import '/page/task_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 2),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const TaskPage()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Define a cor de fundo
      body: Center(
        child: Image.asset(
          'lib/image/ic_launcher.png', // Caminho para a imagem
        ),
      ),
    );
  }
}
