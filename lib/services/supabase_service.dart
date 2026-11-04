import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task_model.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<TaskModel>> getTasks() async {
    final response = await _client.from('tasks').select().order('created_at', ascending: false);
    return (response as List).map((json) => TaskModel.fromJson(json)).toList();
  }

  Future<void> addTask(TaskModel task) async {
    await _client.from('tasks').insert(task.toJson());
  }

  Future<void> updateTask(String id, TaskModel task) async {
    await _client.from('tasks').update(task.toJson()).eq('id', id);
  }

  Future<void> toggleTaskStatus(String id, bool isCompleted) async {
    await _client.from('tasks').update({'is_completed': isCompleted}).eq('id', id);
  }

  Future<void> deleteTask(String id) async {
    await _client.from('tasks').delete().eq('id', id);
  }
}
