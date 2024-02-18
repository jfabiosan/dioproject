import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/dialog/help_dialog.dart';
import '/dialog/edit_dialog.dart';
import '/dialog/add_dialog.dart';
import '/dialog/confirm_del_dialog.dart';
import '/service_provider.dart';
import '/model/task_model.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

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
            return FutureBuilder<List<TaskModel>>(
              future: todoProvider
                  .getAllTasks(), // Método para buscar todas as tarefas do banco de dados
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Se estiver carregando, exiba um indicador de carregamento
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // Se ocorrer um erro, exiba uma mensagem de erro
                  return const Center(
                      child: Text('Erro ao carregar as tarefas'));
                } else {
                  final List<TaskModel> tasks = snapshot.data ?? [];
                  if (tasks.isEmpty) {
                    // Se a lista estiver vazia, exiba a mensagem para criar a primeira tarefa
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
                  } else {
                    // Se houver tarefas, construa a lista de tarefas visíveis
                    final bool showCompletedTasks = todoProvider.switchValue;
                    final List<TaskModel> visibleTasks = showCompletedTasks
                        ? tasks
                        : tasks.where((task) => !task.completed).toList();
                    return Scrollbar(
                      thickness: 10,
                      thumbVisibility: true,
                      radius: const Radius.circular(12),
                      child: ListView.builder(
                        itemCount: visibleTasks.length,
                        itemBuilder: (context, index) {
                          final task = visibleTasks[index];
                          return Dismissible(
                            key: Key(task.id.toString()),
                            direction: DismissDirection.horizontal,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerLeft,
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
                                      todoProvider.removeTask(task);
                                    },
                                  );
                                },
                              );
                            },
                            onDismissed: (direction) {
                              todoProvider.removeTask(task);
                            },
                            child: TaskListItem(task: task),
                          );
                        },
                      ),
                    );
                  }
                }
              },
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

  const TaskListItem({super.key, required this.task});

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
