import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
//import '/repository/database_sqflite.dart';
import '/permission_directory.dart';

class CreateBackupPage extends StatefulWidget {
  const CreateBackupPage({super.key});

  @override
  State<CreateBackupPage> createState() => _CreateBackupPageState();
}

class _CreateBackupPageState extends State<CreateBackupPage> {
  String _backupFileName = '';
  String? _backupDirectory;
  late DateTime now;
  late String horaFormatada;

  @override
  void initState() {
    super.initState();
    // Obtém a data e hora atual
    now = DateTime.now();
    // Formata apenas a hora em formato de números sem pontos
    horaFormatada = DateFormat('ddHHmmssyy').format(now);
    // Definir o nome do arquivo de backup com data e hora atual
    _backupFileName = 'bkp_$horaFormatada.db';
  }

  Future<void> salvarBackup(ScaffoldMessengerState scaffoldMessenger) async {
    try {
      bool permissionGranted = await requestExternalStoragePermission();
      if (!permissionGranted) {
        scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text('Permissão de escrita Negada'),
        ));
        return;
      }
      // Fechar o banco de dados, se estiver aberto
      //final db = await DatabaseSqflite.instance.database;
      //await db.close();

      final originalDbPath = await getDatabasesPath();
      final originalDbFile = File(join(originalDbPath, 'todo.db'));

      // Criar o arquivo "todo.db"
      await originalDbFile.create(recursive: true);

      // Copiar o arquivo para o diretório escolhido
      final backupDirectory = Directory(_backupDirectory!);
      final backupPath = join(backupDirectory.path, _backupFileName);
      await originalDbFile.copy(backupPath);

      const snackBar = SnackBar(
        content: Text('Backup salvo com sucesso!'),
      );
      scaffoldMessenger.showSnackBar(snackBar);
    } catch (error) {
      final snackBar = SnackBar(
        content: Text('Falha ao salvar backup: $error'),
      );
      scaffoldMessenger.showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Criar Backup',
        style: TextStyle(
          fontSize: 28,
          color: Colors.white,
        ),
      )),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Diretório de Destino: ${_backupDirectory ?? 'Nenhum diretório selecionado!'}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String? directory =
                    await FilePicker.platform.getDirectoryPath();
                if (directory != null) {
                  setState(() {
                    _backupDirectory = directory;
                  });
                }
              },
              child: const Text('Selecionar Diretório'),
            ),
            const SizedBox(height: 20),
            Text(
              'Nome do Backup: $_backupFileName',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              // Implemente a lógica para salvar o backup
              onPressed: () => salvarBackup(ScaffoldMessenger.of(context)),
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
