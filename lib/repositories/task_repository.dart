import '../models/task_model.dart';
import '../models/quote_model.dart';
import '../services/api_service.dart';
import '../services/supabase_service.dart';

class TaskRepository {
  final ApiService _apiService = ApiService();
  final SupabaseService _supabaseService = SupabaseService();

  Future<QuoteModel> getDailyQuote() => _apiService.fetchDailyQuote();
  Future<List<TaskModel>> getTasks() => _supabaseService.getTasks();
  Future<void> addTask(TaskModel task) => _supabaseService.addTask(task);
  Future<void> updateTask(String id, TaskModel task) => _supabaseService.updateTask(id, task);
  Future<void> toggleTaskStatus(String id, bool isCompleted) => _supabaseService.toggleTaskStatus(id, isCompleted);
  Future<void> deleteTask(String id) => _supabaseService.deleteTask(id);
}