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
    _updateTodoItems();
  }

  // Método para adicionar tarefas
  void addTodoItem(String title) async {
    final newTask = TaskModel(
      title: title,
      id: DateTime.now().millisecondsSinceEpoch,
    );
    await _repository.insertTask(newTask);
    _updateTodoItems();
  }

  // Método para remover tarefas
  void removeTask(TaskModel task) async {
    await _repository.deleteTask(task.id);
    _updateTodoItems();
  }

  // Método para editar tarefas
  void editTask(TaskModel oldTask, TaskModel newTask) async {
    await _repository.updateTask(newTask);
    _updateTodoItems();
  }

  // Método para atualizar o estado da conclusão da tarefa
  void updateTaskCompletion(TaskModel task, bool completed) async {
    await _repository.updateTaskCompletion(task.id, completed);
    _updateTodoItems();
  }

  // Método para obter todas as tarefas do banco de dados
  Future<List<TaskModel>> getAllTasks() async {
    try {
      return await _repository.getAllTasks();
    } catch (e) {
      // Tratamento de erro adequado, se necessário
      debugPrint('Erro ao buscar todas as tarefas: $e');
      return []; // Retorna uma lista vazia em caso de erro
    }
  }

// Método privado para atualizar a lista de tarefas
  void _updateTodoItems() async {
    // Obter a lista mais recente de tarefas do banco de dados
    List<TaskModel> updatedTasks = await _repository.getAllTasks();

    // Atualizar o estado com a lista atualizada
    _todoItems.clear();
    _todoItems.addAll(updatedTasks);

    // Notificar os ouvintes de que o estado foi alterado
    notifyListeners();
  }
}
