import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../repositories/task_repository.dart';

class TaskProvider with ChangeNotifier {
  final TaskRepository _repository = TaskRepository();
  List<TaskModel> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<TaskModel> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadDashboardData() async {
    await fetchTasks();
  }

  Future<void> fetchTasks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tasks = await _repository.getTasks();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(TaskModel task) async {
    try {
      await _repository.addTask(task);
      await fetchTasks();
    } catch (e) {
      print("GAGAL MENAMBAHKAN TUGAS: $e");
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateTask(TaskModel updatedTask) async {
    try {
      await _repository.updateTask(updatedTask);
      await fetchTasks();
    } catch (e) {
      print("GAGAL MEMPERBARUI TUGAS: $e");
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> toggleTask(int id, bool currentStatus) async {
    try {
      final task = _tasks.firstWhere((t) => t.id == id);
      final updatedTask = TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        category: task.category,
        priority: task.priority,
        isCompleted: !currentStatus,
      );
      await _repository.updateTask(updatedTask);
      await fetchTasks();
    } catch (e) {
      print("GAGAL TOGGLE TUGAS: $e");
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await _repository.deleteTask(id);
      await fetchTasks();
    } catch (e) {
      print("GAGAL MENGHAPUS TUGAS: $e");
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}