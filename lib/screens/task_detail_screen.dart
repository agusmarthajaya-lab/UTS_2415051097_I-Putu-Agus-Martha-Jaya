import 'package:flutter/material.dart';
import '../models/task_model.dart';
import 'edit_task_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final TaskModel task;

  const TaskDetailScreen({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tugas'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditTaskScreen(task: task),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Tugas
            Row(
              children: [
                Chip(
                  label: Text(
                    task.isCompleted ? 'Selesai' : 'Belum Selesai',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: task.isCompleted ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 12),
                Chip(
                  label: Text('Prioritas: ${task.priority}'),
                  backgroundColor: Colors.deepPurple.shade50,
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Judul Tugas
            Text(
              task.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            // Kategori
            Text(
              'Kategori: ${task.category}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Divider(height: 30),

            // Deskripsi Tugas
            const Text(
              'Deskripsi:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              task.description.isNotEmpty ? task.description : 'Tidak ada deskripsi.',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}