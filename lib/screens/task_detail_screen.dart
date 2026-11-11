import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import 'edit_task_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final TaskModel task;

  const TaskDetailScreen({
    super.key,
    required this.task,
  });

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'tinggi':
      case 'high':
      case 'penting':
        return Colors.red.shade600;
      case 'sedang':
      case 'medium':
        return Colors.orange.shade700;
      default:
        return Colors.green.shade600;
    }
  }

  void _confirmDelete(BuildContext context, TaskProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Tugas'),
        content: Text('Apakah Anda yakin ingin menghapus tugas "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await provider.deleteTask(task.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tugas berhasil dihapus!'),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE, dd MMMM yyyy HH:mm', 'id_ID');
    final priorityColor = _getPriorityColor(task.priority);

    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        // Cari tugas terkini dari provider jika sudah diupdate
        final currentTask = provider.tasks.firstWhere(
          (t) => t.id == task.id,
          orElse: () => task,
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Detail Tugas'),
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Edit Tugas',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditTaskScreen(task: currentTask),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Hapus Tugas',
                onPressed: () => _confirmDelete(context, provider),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 650),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Status & Priority Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: currentTask.isCompleted
                                    ? Colors.green.shade50
                                    : Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: currentTask.isCompleted
                                      ? Colors.green.shade300
                                      : Colors.orange.shade300,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    currentTask.isCompleted
                                        ? Icons.check_circle
                                        : Icons.pending,
                                    size: 16,
                                    color: currentTask.isCompleted
                                        ? Colors.green.shade700
                                        : Colors.orange.shade800,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    currentTask.isCompleted ? 'Selesai' : 'Belum Selesai',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      color: currentTask.isCompleted
                                          ? Colors.green.shade700
                                          : Colors.orange.shade800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: priorityColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: priorityColor.withValues(alpha: 0.4)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.flag, size: 16, color: priorityColor),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Prioritas ${currentTask.priority}',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      color: priorityColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 32),

                        // Title
                        const Text(
                          'Judul Tugas',
                          style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currentTask.title,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            decoration: currentTask.isCompleted ? TextDecoration.lineThrough : null,
                            color: currentTask.isCompleted ? Colors.grey : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Kategori
                        const Text(
                          'Kategori',
                          style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Chip(
                          label: Text(currentTask.category),
                          backgroundColor: Colors.deepPurple.shade50,
                          labelStyle: TextStyle(
                            color: Colors.deepPurple.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Deskripsi
                        const Text(
                          'Deskripsi / Catatan',
                          style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Text(
                            currentTask.description.isNotEmpty
                                ? currentTask.description
                                : 'Tidak ada deskripsi tambahan.',
                            style: const TextStyle(fontSize: 14.5, height: 1.5),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Tanggal Dibuat
                        const Text(
                          'Waktu Dibuat',
                          style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16, color: Colors.deepPurple),
                            const SizedBox(width: 8),
                            Text(
                              dateFormat.format(currentTask.createdAt),
                              style: const TextStyle(fontSize: 13.5, color: Colors.black87),
                            ),
                          ],
                        ),
                        const Divider(height: 36),

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: currentTask.isCompleted
                                      ? Colors.orange.shade700
                                      : Colors.green.shade700,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                icon: Icon(
                                  currentTask.isCompleted
                                      ? Icons.undo
                                      : Icons.check_circle_outline,
                                ),
                                label: Text(
                                  currentTask.isCompleted
                                      ? 'Tandai Belum Selesai'
                                      : 'Tandai Sudah Selesai',
                                ),
                                onPressed: () {
                                  provider.toggleTaskStatus(currentTask.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        currentTask.isCompleted
                                            ? 'Status diubah ke Belum Selesai'
                                            : 'Tugas ditandai selesai! Hebat!',
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.deepPurple,
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              ),
                              icon: const Icon(Icons.edit),
                              label: const Text('Edit'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditTaskScreen(task: currentTask),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
