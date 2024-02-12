import 'package:flutter/material.dart';

class ConfirmDelDialog extends StatelessWidget {
  final Function onDeleteConfirmed;

  const ConfirmDelDialog({Key? key, required this.onDeleteConfirmed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmar exclusão'),
      content: const Text('Tem certeza que deseja excluir esta tarefa?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context)
                .pop(false); // Fecha o diálogo sem excluir a tarefa
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            onDeleteConfirmed(); // Chama a função para excluir a tarefa
            Navigator.of(context)
                .pop(true); // Fecha o diálogo após excluir a tarefa
          },
          child: const Text('Confirmar'),
        ),
      ],
    );
  }
}
