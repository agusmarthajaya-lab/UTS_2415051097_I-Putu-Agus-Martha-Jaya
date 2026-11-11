import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/quote_card.dart';
import '../widgets/stats_card.dart';
import '../widgets/task_card.dart';
import 'task_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final String userName;
  final String userNim;
  final VoidCallback onNavigateToTasks;
  final VoidCallback onNavigateToAddTask;

  const HomeScreen({
    super.key,
    required this.userName,
    required this.userNim,
    required this.onNavigateToTasks,
    required this.onNavigateToAddTask,
  });

  void _confirmDelete(BuildContext context, TaskProvider provider, String id, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Tugas'),
        content: Text('Apakah Anda yakin ingin menghapus tugas "$title"?'),
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
              await provider.deleteTask(id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tugas berhasil dihapus!'),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _confirmClearAll(BuildContext context, TaskProvider provider) {
    if (provider.tasks.isEmpty) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Semua Tugas'),
        content: const Text('Apakah Anda yakin ingin menghapus seluruh daftar tugas?'),
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
              await provider.clearAllTasks();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Seluruh tugas berhasil dibersihkan!'),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Hapus Semua'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        final highPriorityTasks = provider.tasks
            .where((t) => !t.isCompleted && (t.priority == 'Tinggi' || t.priority == 'High'))
            .take(3)
            .toList();

        return RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              provider.fetchTasks(),
              provider.fetchDailyQuote(),
            ]);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcoming Card
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.deepPurple.shade100),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.deepPurple,
                        child: Text(
                          userName.isNotEmpty ? userName[0].toUpperCase() : 'M',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Halo, $userName!',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'NIM: $userNim | PTI Undiksha',
                              style: TextStyle(
                                fontSize: 12.5,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // REST API Motivation Quote Card
                QuoteCard(
                  quote: provider.quote,
                  isLoading: provider.isQuoteLoading,
                  errorMessage: provider.quoteError,
                  onRefresh: () => provider.fetchDailyQuote(),
                ),
                const SizedBox(height: 16),

                // Statistics Card
                StatsCard(
                  totalCount: provider.totalCount,
                  completedCount: provider.completedCount,
                  pendingCount: provider.pendingCount,
                  completionRate: provider.completionRate,
                ),
                const SizedBox(height: 20),

                // Quick Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.add_task),
                        label: const Text('Tambah Tugas'),
                        onPressed: onNavigateToAddTask,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.deepPurple,
                          side: const BorderSide(color: Colors.deepPurple),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.list_alt),
                        label: const Text('Semua Tugas'),
                        onPressed: onNavigateToTasks,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // High Priority Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 22),
                        SizedBox(width: 6),
                        Text(
                          'Tugas Prioritas Tinggi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (provider.tasks.isNotEmpty)
                      TextButton(
                        onPressed: () => _confirmClearAll(context, provider),
                        child: const Text(
                          'Bersihkan Semua',
                          style: TextStyle(color: Colors.redAccent, fontSize: 12),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),

                if (provider.isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (highPriorityTasks.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.thumb_up_alt_outlined, color: Colors.green.shade600, size: 36),
                        const SizedBox(height: 8),
                        const Text(
                          'Tidak ada tugas prioritas tinggi yang tertunda.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                      ],
                    ),
                  )
                else
                  ...highPriorityTasks.map(
                    (task) => TaskCard(
                      task: task,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaskDetailScreen(task: task),
                          ),
                        );
                      },
                      onToggle: () => provider.toggleTaskStatus(task.id),
                      onDelete: () => _confirmDelete(context, provider, task.id, task.title),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
