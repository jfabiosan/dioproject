import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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
  late String _dbPath;
  late final GlobalKey<ScaffoldMessengerState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
    // Obtém a data e hora atual
    now = DateTime.now();
    // Formata apenas a hora em formato de números sem pontos
    horaFormatada = DateFormat('ddHHmmssyy').format(now);
    // Definir o nome do arquivo de backup com data e hora atual
    _backupFileName = 'bkp_$horaFormatada.csv';

    // Obtém o caminho do banco de dados
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    // Obtém o diretório de documentos do dispositivo
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    _dbPath = join(documentsDirectory.path, 'todos.db');
  }

  Future<void> _saveBackup() async {
    if (!File(_dbPath).existsSync()) {
      _scaffoldKey.currentState?.showSnackBar(
        const SnackBar(content: Text('Banco de dados não encontrado!')),
      );
      return;
    }

    String? directory = _backupDirectory;

    if (directory != null) {
      try {
        //basename(_dbPath);
        String backupFilePath = join(directory, _backupFileName);
        await File(_dbPath).copy(backupFilePath);

        _scaffoldKey.currentState?.showSnackBar(
          const SnackBar(content: Text('Backup salvo com sucesso!')),
        );
      } catch (e) {
        _scaffoldKey.currentState?.showSnackBar(
          SnackBar(content: Text('Erro ao salvar backup: $e')),
        );
      }
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
              onPressed: _saveBackup,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
