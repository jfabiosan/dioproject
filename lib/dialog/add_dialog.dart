import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/service_provider.dart';

class AddDialog {
  static void show(BuildContext context) {
    TextEditingController textFieldController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Tarefa'),
          content: TextField(
            textCapitalization: TextCapitalization.words,
            controller: textFieldController,
            decoration: const InputDecoration(hintText: "Digite o título"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Adicionar'),
              onPressed: () {
                final String title = textFieldController.text.trim();
                if (title.isNotEmpty) {
                  final todoProvider =
                      Provider.of<ServiceProvider>(context, listen: false);
                  todoProvider.addTodoItem(title);
                  Navigator.of(context).pop();
                } else {
                  // Exiba uma mensagem de erro se o título estiver vazio
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        'O título não pode estar vazio.',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
