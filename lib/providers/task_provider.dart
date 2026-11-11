import 'package:flutter/foundation.dart';
import '../models/task_model.dart';
import '../models/quote_model.dart';
import '../repositories/task_repository.dart';

class TaskProvider with ChangeNotifier {
  final TaskRepository _repository;

  TaskProvider({TaskRepository? repository})
      : _repository = repository ?? TaskRepository();

  // State: Task List
  List<TaskModel> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;

  // State: REST API Daily Quote
  QuoteModel? _quote;
  bool _isQuoteLoading = false;
  String? _quoteError;

  // Shared State: Filter & Search
  String _searchQuery = '';
  String _statusFilter = 'Semua'; // 'Semua', 'Belum Selesai', 'Selesai'
  String _priorityFilter = 'Semua'; // 'Semua', 'Tinggi', 'Sedang', 'Rendah'

  // Getters
  List<TaskModel> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  QuoteModel? get quote => _quote;
  bool get isQuoteLoading => _isQuoteLoading;
  String? get quoteError => _quoteError;

  String get searchQuery => _searchQuery;
  String get statusFilter => _statusFilter;
  String get priorityFilter => _priorityFilter;

  int get totalCount => _tasks.length;
  int get completedCount => _tasks.where((t) => t.isCompleted).length;
  int get pendingCount => _tasks.where((t) => !t.isCompleted).length;
  double get completionRate => totalCount == 0 ? 0.0 : (completedCount / totalCount);

  // Filtered Tasks berdasarkan pencarian, status, dan prioritas
  List<TaskModel> get filteredTasks {
    return _tasks.where((task) {
      // 1. Search Query
      final matchesSearch = task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          task.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          task.category.toLowerCase().contains(_searchQuery.toLowerCase());

      // 2. Status Filter
      bool matchesStatus = true;
      if (_statusFilter == 'Belum Selesai') {
        matchesStatus = !task.isCompleted;
      } else if (_statusFilter == 'Selesai') {
        matchesStatus = task.isCompleted;
      }

      // 3. Priority Filter
      bool matchesPriority = true;
      if (_priorityFilter != 'Semua') {
        matchesPriority = task.priority.toLowerCase() == _priorityFilter.toLowerCase();
      }

      return matchesSearch && matchesStatus && matchesPriority;
    }).toList();
  }

  // Setters untuk shared filter state
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setStatusFilter(String filter) {
    _statusFilter = filter;
    notifyListeners();
  }

  void setPriorityFilter(String filter) {
    _priorityFilter = filter;
    notifyListeners();
  }

  // 1. READ: Fetch all tasks
  Future<void> fetchTasks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tasks = await _repository.fetchAllTasks();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Gagal memuat daftar tugas: ${e.toString()}';
      notifyListeners();
    }
  }

  // 2. CREATE: Add new task
  Future<bool> addTask({
    required String title,
    required String description,
    required String category,
    required String priority,
  }) async {
    try {
      final newTask = TaskModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        category: category,
        priority: priority,
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      await _repository.addTask(newTask);
      _tasks = await _repository.fetchAllTasks();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menambahkan tugas: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // 3. UPDATE: Update existing task
  Future<bool> updateTask(TaskModel updatedTask) async {
    try {
      await _repository.updateTask(updatedTask);
      _tasks = await _repository.fetchAllTasks();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal memperbarui tugas: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // 4. DELETE: Delete task
  Future<bool> deleteTask(String id) async {
    try {
      await _repository.deleteTask(id);
      _tasks = await _repository.fetchAllTasks();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menghapus tugas: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Toggle completion status
  Future<void> toggleTaskStatus(String id) async {
    final taskIndex = _tasks.indexWhere((t) => t.id == id);
    if (taskIndex != -1) {
      final newStatus = !_tasks[taskIndex].isCompleted;
      await _repository.toggleTaskStatus(id, newStatus);
      _tasks = await _repository.fetchAllTasks();
      notifyListeners();
    }
  }

  // Clear all tasks
  Future<void> clearAllTasks() async {
    await _repository.clearAllTasks();
    _tasks = await _repository.fetchAllTasks();
    notifyListeners();
  }

  // 5. REST API: Fetch quote
  Future<void> fetchDailyQuote() async {
    _isQuoteLoading = true;
    _quoteError = null;
    notifyListeners();

    try {
      _quote = await _repository.fetchMotivationQuote();
      _isQuoteLoading = false;
      notifyListeners();
    } catch (e) {
      _isQuoteLoading = false;
      // Gunakan kutipan cadangan jika offline tapi tetap tandai pesan info
      _quote = QuoteModel(
        quote: 'Pendidikan bukan persiapan untuk hidup; pendidikan adalah hidup itu sendiri.',
        author: 'John Dewey',
      );
      _quoteError = 'Mode Offline (REST API cadangan aktif)';
      notifyListeners();
    }
  }
}
