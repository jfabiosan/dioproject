import 'package:flutter/material.dart';
import '/model/task_model.dart';

class ServiceProvider extends ChangeNotifier {
  bool _switchValue = false;
  final List<TaskModel> _todoItems = [];

  bool get switchValue => _switchValue;
  List<TaskModel> get todoItems => _todoItems;

  //metodo para atualizar estado do switch da AppBar
  void updateSwitchValue(bool value) {
    _switchValue = value;
    notifyListeners();
  }

  //metodo para adicionar tarefas
  void addTodoItem(String title) {
    _todoItems.add(TaskModel(title: title));
    notifyListeners();
  }

  //metodo para remocao da tarefa
  void removeTask(int index) {
    _todoItems.removeAt(index);
    notifyListeners();
  }

  //metodo para editar a tarefa
  void editTask(TaskModel oldTask, TaskModel newTask) {
    final index = _todoItems.indexOf(oldTask);
    if (index != -1) {
      _todoItems[index] = newTask;
      notifyListeners();
    }
  }

  //metodo para atualizar o estado do switch de cada tarefa
  void updateTaskCompletion(TaskModel task, bool completed) {
    final index = _todoItems.indexOf(task);
    if (index != -1) {
      _todoItems[index] = TaskModel(
        title: task.title,
        completed: completed,
      );
      notifyListeners();
    }
  }
}
