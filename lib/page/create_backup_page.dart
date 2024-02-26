import 'package:flutter/material.dart';

class CreateBackupPage extends StatefulWidget {
  const CreateBackupPage({super.key});

  @override
  State<CreateBackupPage> createState() => _CreateBackupPageState();
}

class _CreateBackupPageState extends State<CreateBackupPage> {
  String _backupFileName = '';

  @override
  void initState() {
    super.initState();
    // Definir o nome do arquivo de backup com data e hora atual
    _backupFileName = 'backup_${DateTime.now().toString()}.csv';
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
            const Text(
              'Diretório de Destino:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 18),
            Text('Nome do Backup: $_backupFileName'),
            const SizedBox(height: 50),
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
