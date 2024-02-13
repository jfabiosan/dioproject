import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/dialog/help_dialog.dart';
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
        toolbarHeight: 70.0,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        backgroundColor: Colors.blueGrey,
        title: const Text(
          'Flash Note',
          style: TextStyle(
            fontSize: 28,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const HelpDialog(),
              );
            },
            icon: const Icon(Icons.help),
          ),
          const TaskSwitch(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 90),
        child: Consumer<ServiceProvider>(
          builder: (context, todoProvider, child) {
            final bool showCompletedTasks = todoProvider.switchValue;
            final List<TaskModel> visibleTasks = showCompletedTasks
                ? todoProvider.todoItems
                : todoProvider.todoItems
                    .where((task) => !task.completed)
                    .toList();
            if (visibleTasks.isEmpty) {
              return const Center(
                child: Card(
                  margin: EdgeInsets.all(40),
                  child: Text(
                    'Clique no botão + para inserir uma nota.',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            //Mostra barra de rolagem na lista
            return Scrollbar(
              thickness: 10,
              thumbVisibility: true,
              radius: const Radius.circular(12),
              child: ListView.builder(
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
                              todoProvider.removeTask(
                                  index); // Remove a tarefa da lista
                            },
                          );
                        },
                      );
                    },
                    onDismissed: (direction) {
                      todoProvider
                          .removeTask(index); // Remove a tarefa da lista
                    },
                    child: TaskListItem(task: task),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrangeAccent,
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
          activeColor: Colors.white,
          activeTrackColor: Colors.deepOrangeAccent,
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
    return Card(
      child: ListTile(
        title: Text(
          task.title,
          style: const TextStyle(fontSize: 20),
        ),
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
            //Switch das tarefas
            Switch(
              activeColor: Colors.white,
              activeTrackColor: Colors.deepOrangeAccent,
              value: task.completed,
              onChanged: (value) {
                Provider.of<ServiceProvider>(context, listen: false)
                    .updateTaskCompletion(task, value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
