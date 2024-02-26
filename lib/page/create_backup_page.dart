import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

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
    _backupFileName = 'bkp_$horaFormatada.csv';
    //_backupFileName = 'bkp_${DateTime.now().toString()}.csv';
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
              onPressed: () {
                // Implemente a lógica para salvar o backup
                // Aqui você pode usar a biblioteca path_provider para obter o diretório de destino
                // e a biblioteca csv para escrever os dados do banco de dados em um arquivo CSV
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
