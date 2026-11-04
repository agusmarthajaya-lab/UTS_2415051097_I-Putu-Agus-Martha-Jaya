import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../models/quote_model.dart';
import '../repositories/task_repository.dart';

enum ViewState { loading, success, error, empty }

class TaskProvider with ChangeNotifier {
  final TaskRepository _repository = TaskRepository();

  ViewState _state = ViewState.loading;
  ViewState get state => _state;

  List<TaskModel> _tasks = [];
  List<TaskModel> get tasks => _tasks;

  QuoteModel? _quote;
  QuoteModel? get quote => _quote;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> loadDashboardData() async {
    _state = ViewState.loading;
    notifyListeners();
    try {
      _quote = await _repository.getDailyQuote();
      await fetchTasks();
    } catch (e) {
      _errorMessage = e.toString();
      _state = ViewState.error;
      notifyListeners();
    }
  }

  Future<void> fetchTasks() async {
    try {
      _tasks = await _repository.getTasks();
      if (_tasks.isEmpty) {
        _state = ViewState.empty;
      } else {
        _state = ViewState.success;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _state = ViewState.error;
    }
    notifyListeners();
  }

  Future<void> addTask(TaskModel task) async {
    await _repository.addTask(task);
    await fetchTasks();
  }

  Future<void> updateTask(String id, TaskModel task) async {
    await _repository.updateTask(id, task);
    await fetchTasks();
  }

  Future<void> toggleTask(String id, bool currentStatus) async {
    await _repository.toggleTaskStatus(id, !currentStatus);
    await fetchTasks();
  }

  Future<void> deleteTask(String id) async {
    await _repository.deleteTask(id);
    await fetchTasks();
  }
}