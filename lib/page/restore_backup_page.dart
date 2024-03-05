import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class RestoreBackupPage extends StatefulWidget {
  const RestoreBackupPage({super.key});

  @override
  State<RestoreBackupPage> createState() => _RestoreBackupPageState();
}

class _RestoreBackupPageState extends State<RestoreBackupPage> {
  String _selectedFilePath = '';

  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFilePath = result.files.single.path!;
      });
    }
  }

// Função para solicitar permissões
  Future<bool> _requestPermissions() async {
    PermissionStatus status = await Permission.storage.request();
    return status == PermissionStatus.granted;
  }

  // Função para importar o backup, incluindo a verificação de permissões
  Future<void> _importBackup() async {
    try {
      // Verificar se as permissões foram concedidas
      bool permissionGranted = await _requestPermissions();
      if (!permissionGranted) {
        // Permissão negada, notificar o usuário
        ScaffoldMessenger.of(_scaffoldContext!).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Permissão de acesso ao sistema de arquivos negada.'),
        ));
        return;
      }

      // Se as permissões foram concedidas, continuar com a importação do backup
      if (_selectedFilePath.isNotEmpty) {
        // Obter o diretório escolhido pelo usuário para o backup
        final backupDirectory = Directory(_selectedFilePath).parent;

        // Verificar se o diretório existe
        if (await backupDirectory.exists()) {
          // Obter o diretório do banco de dados do aplicativo
          final appDirectory = await getApplicationDocumentsDirectory();
          final dbPath = join(appDirectory.path, 'todo.db');

          // Copiar o arquivo de backup para o diretório do banco de dados com o nome 'todo.db'
          await File(_selectedFilePath).copy(dbPath);

          // Notificar o usuário que a restauração foi concluída
          ScaffoldMessenger.of(_scaffoldContext!).showSnackBar(const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Backup restaurado com sucesso!'),
          ));
        } else {
          // Notificar o usuário se o diretório escolhido não existir
          ScaffoldMessenger.of(_scaffoldContext!).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Text('O diretório de backup selecionado não existe.'),
          ));
        }
      } else {
        // Notificar o usuário se nenhum arquivo foi selecionado
        ScaffoldMessenger.of(_scaffoldContext!).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Nenhum arquivo selecionado.'),
        ));
      }
    } catch (error) {
      // Notificar o usuário se ocorrer um erro durante a restauração
      ScaffoldMessenger.of(_scaffoldContext!).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text('Falha ao restaurar backup: $error'),
      ));
    }
  }

  BuildContext? _scaffoldContext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Restaurar Backup',
          style: TextStyle(
            fontSize: 28,
            color: Colors.white,
          ),
        ),
      ),
      body: Builder(
        builder: (BuildContext context) {
          _scaffoldContext = context;
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: _selectFile,
                  child: const Text('Selecione o arquivo'),
                ),
                const SizedBox(height: 20),
                Text(
                  'Arquivo Selecionado : $_selectedFilePath',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _importBackup,
                  child: const Text('Importar'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
