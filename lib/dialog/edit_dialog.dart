import 'package:dioproject/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/model/task_model.dart';

class EditDialog extends StatelessWidget {
  final TaskModel task;

  const EditDialog({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController textFieldController =
        TextEditingController(text: task.title);

    return AlertDialog(
      title: const Text('Editar Tarefa'),
      content: TextField(
        controller: textFieldController,
        decoration: const InputDecoration(hintText: "Digite o novo título"),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Salvar'),
          onPressed: () {
            final String newTitle = textFieldController.text.trim();
            if (newTitle.isNotEmpty) {
              // Atualize a tarefa com o novo título
              final updateTask = TaskModel(
                title: newTitle,
                completed: task.completed,
              );
              //atualiza a tarefa com provider
              Provider.of<ServiceProvider>(context, listen: false)
                  .editTask(task, updateTask);
              // Feche o diálogo
              Navigator.of(context).pop();
            } else {
              // Exiba uma mensagem de erro se o título estiver vazio
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  'O título não pode estar vazio.',
                  style: TextStyle(fontSize: 20),
                ),
              ));
            }
          },
        ),
      ],
    );
  }
}
