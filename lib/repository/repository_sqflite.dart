import 'package:sqflite/sqflite.dart';
import '/model/task_model.dart';
import 'database_sqflite.dart';

class RepositorySqflite {
  Future<void> insertTask(TaskModel task) async {
    final db = await DatabaseSqflite.instance.database;
    await db.insert(
      'todos',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TaskModel>> getAllTasks() async {
    final db = await DatabaseSqflite.instance.database;
    final List<Map<String, dynamic>> maps = await db.query('todos');
    return List.generate(maps.length, (i) {
      return TaskModel(
        id: maps[i]['id'],
        title: maps[i]['title'],
        completed: maps[i]['completed'] == 1 ? true : false,
      );
    });
  }

  Future<void> deleteTask(int id) async {
    final db = await DatabaseSqflite.instance.database;
    await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateTask(TaskModel task) async {
    final db = await DatabaseSqflite.instance.database;
    await db.update(
      'todos',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> updateTaskCompletion(int id, bool completed) async {
    final db = await DatabaseSqflite.instance.database;
    await db.update(
      'todos',
      {'completed': completed ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
