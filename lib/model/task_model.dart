class TaskModel {
  String title;
  int id;
  bool completed;

  TaskModel({
    required this.title,
    required this.id,
    this.completed = false,
  });

  // Método para converter o objeto TaskModel em um mapa
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'id': id,
      'completed': completed
          ? 1
          : 0, // Armazenamos o estado concluído como 1 ou 0 no banco de dados
    };
  }
}
