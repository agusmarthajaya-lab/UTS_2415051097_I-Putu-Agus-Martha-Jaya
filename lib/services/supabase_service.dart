import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task_model.dart';

class SupabaseService {
  // Konfigurasi Project Supabase (Dapat dihubungkan dengan proyek live Supabase)
  static const String supabaseUrl = 'https://proyekanda.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.anon_key_placeholder';

  bool get isConfigured {
    try {
      final isPlaceholder = supabaseUrl.contains('proyekanda') || supabaseUrl.contains('your-project');
      if (isPlaceholder) return false;
      // Memastikan Supabase telah diinisialisasi
      return Supabase.instance.client.auth.currentSession != null || Supabase.instance.isInitialized;
    } catch (_) {
      return false;
    }
  }

  SupabaseClient? get _client {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  // 1. READ: Ambil seluruh data tugas dari tabel 'tasks'
  Future<List<TaskModel>> getTasks() async {
    final client = _client;
    if (client == null || !isConfigured) {
      throw Exception('Supabase belum terkonfigurasi dengan URL & Anon Key aktif.');
    }

    final response = await client
        .from('tasks')
        .select()
        .order('created_at', ascending: false);

    final dataList = response as List<dynamic>;
    return dataList.map((item) => TaskModel.fromJson(item as Map<String, dynamic>)).toList();
  }

  // 2. CREATE: Tambah tugas baru ke tabel 'tasks'
  Future<TaskModel> addTask(TaskModel task) async {
    final client = _client;
    if (client == null || !isConfigured) {
      throw Exception('Supabase belum terkonfigurasi.');
    }

    final response = await client
        .from('tasks')
        .insert(task.toJson())
        .select()
        .single();

    return TaskModel.fromJson(response);
  }

  // 3. UPDATE: Perbarui data tugas pada tabel 'tasks'
  Future<void> updateTask(TaskModel task) async {
    final client = _client;
    if (client == null || !isConfigured) {
      throw Exception('Supabase belum terkonfigurasi.');
    }

    await client
        .from('tasks')
        .update(task.toJson())
        .eq('id', task.id);
  }

  // 4. DELETE: Hapus data tugas berdasarkan primary key id
  Future<void> deleteTask(String id) async {
    final client = _client;
    if (client == null || !isConfigured) {
      throw Exception('Supabase belum terkonfigurasi.');
    }

    await client.from('tasks').delete().eq('id', id);
  }

  // Toggle Status Selesai
  Future<void> toggleTaskStatus(String id, bool isCompleted) async {
    final client = _client;
    if (client == null || !isConfigured) {
      throw Exception('Supabase belum terkonfigurasi.');
    }

    await client.from('tasks').update({'is_completed': isCompleted}).eq('id', id);
  }
}
