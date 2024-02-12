import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/dialog/edit_dialog.dart';
import '/dialog/add_dialog.dart';
import '/dialog/confirm_del_dialog.dart'; // Importe o arquivo confirm_del_dialog.dart
import '/service_provider.dart';
import '/model/task_model.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
        actions: const [
          TaskSwitch(),
        ],
      ),
      body: Consumer<ServiceProvider>(
        builder: (context, todoProvider, child) {
          final bool showCompletedTasks = todoProvider.switchValue;
          final List<TaskModel> visibleTasks = showCompletedTasks
              ? todoProvider.todoItems
              : todoProvider.todoItems
                  .where((task) => !task.completed)
                  .toList();

          return ListView.builder(
            itemCount: visibleTasks.length,
            itemBuilder: (context, index) {
              final task = visibleTasks[index];
              return Dismissible(
                key: Key(task.title), // Chave única para o Dismissible
                direction: DismissDirection.horizontal,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                confirmDismiss: (direction) async {
                  return await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return ConfirmDelDialog(
                        onDeleteConfirmed: () {
                          todoProvider
                              .removeTask(index); // Remove a tarefa da lista
                        },
                      );
                    },
                  );
                },
                onDismissed: (direction) {
                  todoProvider.removeTask(index); // Remove a tarefa da lista
                },
                child: TaskListItem(task: task),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AddDialog.show(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

//Switch da AppBar
class TaskSwitch extends StatelessWidget {
  const TaskSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceProvider>(
      builder: (context, todoProvider, child) {
        return Switch(
          value: todoProvider.switchValue,
          onChanged: (value) {
            todoProvider.updateSwitchValue(value);
          },
        );
      },
    );
  }
}

//tarefas da ListView
class TaskListItem extends StatelessWidget {
  final TaskModel task;

  const TaskListItem({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.title),
      //Switch das tarefas
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => EditDialog(task: task),
              );
            },
            icon: const Icon(Icons.edit),
          ),
          Switch(
            value: task.completed,
            onChanged: (value) {
              Provider.of<ServiceProvider>(context, listen: false)
                  .updateTaskCompletion(task, value);
            },
          ),
        ],
      ),
    );
  }
}
