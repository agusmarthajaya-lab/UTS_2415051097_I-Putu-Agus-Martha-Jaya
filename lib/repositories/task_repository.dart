import '../models/task_model.dart';

class TaskRepository {
  // Penyimpanan sementara di memori agar aplikasi langsung berjalan lancar
  static final List<TaskModel> _memoryTasks = [
    TaskModel(
      id: 1,
      title: 'Membuat Laporan UTS Mobile',
      description: 'Menyelesaikan dokumentasi project Flutter dan integrasi',
      category: 'Kuliah',
      priority: 'High',
      isCompleted: false,
    ),
    TaskModel(
      id: 2,
      title: 'Belanja Kebutuhan Mingguan',
      description: 'Membeli beras, minyak goreng, dan sayuran',
      category: 'Pribadi',
      priority: 'Medium',
      isCompleted: false,
    ),
  ];

  Future<List<TaskModel>> getTasks() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _memoryTasks;
  }

  Future<void> addTask(TaskModel task) async {
    final newTask = TaskModel(
      id: (_memoryTasks.isNotEmpty ? _memoryTasks.map((e) => e.id ?? 0).reduce((a, b) => a > b ? a : b) : 0) + 1,
      title: task.title,
      description: task.description,
      category: task.category,
      priority: task.priority,
      isCompleted: task.isCompleted,
    );
    _memoryTasks.add(newTask);
  }

  Future<void> updateTask(TaskModel task) async {
    final index = _memoryTasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _memoryTasks[index] = task;
    }
  }

  Future<void> deleteTask(int id) async {
    _memoryTasks.removeWhere((t) => t.id == id);
  }
}