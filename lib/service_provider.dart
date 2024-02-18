import 'package:flutter/material.dart';
import '/model/task_model.dart';
import 'repository/repository_sqflite.dart';

class ServiceProvider extends ChangeNotifier {
  bool _switchValue = false;
  final RepositorySqflite _repository = RepositorySqflite();
  final List<TaskModel> _todoItems = []; // Adicione a lista de tarefas aqui

  bool get switchValue => _switchValue;
  List<TaskModel> get todoItems => _todoItems; // Getter para obter a lista

  // Método para atualizar o estado do switch da AppBar
  void updateSwitchValue(bool value) {
    _switchValue = value;
    notifyListeners();
  }

  // Método para adicionar tarefas
  void addTodoItem(String title) async {
    final newTask = TaskModel(
      title: title,
      id: DateTime.now().millisecondsSinceEpoch,
    );
    await _repository.insertTask(newTask);
    notifyListeners();
  }

  // Método para remover tarefas
  void removeTask(TaskModel task) async {
    await _repository.deleteTask(task.id);
    notifyListeners();
  }

  // Método para editar tarefas
  void editTask(TaskModel oldTask, TaskModel newTask) async {
    await _repository.updateTask(newTask);
    notifyListeners();
  }

  // Método para atualizar o estado da conclusão da tarefa
  void updateTaskCompletion(TaskModel task, bool completed) async {
    await _repository.updateTaskCompletion(task.id, completed);
    notifyListeners();
  }
}
