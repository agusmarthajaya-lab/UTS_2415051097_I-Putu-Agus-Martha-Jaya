class TaskModel {
  final int? id;
  final String title;
  final String description;
  final String category;
  final String priority;
  final bool isCompleted;

  TaskModel({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.isCompleted,
  });

  // Konversi dari JSON (Supabase) ke Object TaskModel
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'General',
      priority: json['priority'] ?? 'Medium',
      isCompleted: json['is_completed'] ?? false,
    );
  }

  // Konversi dari Object TaskModel ke JSON (untuk dikirim ke Supabase)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'is_completed': isCompleted,
    };
  }
}