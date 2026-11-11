import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import 'task_detail_screen.dart';
import 'add_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  final String userName;
  final String userNim;

  const TaskListScreen({
    super.key,
    required this.userName,
    required this.userNim,
  });

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _confirmDelete(BuildContext context, TaskProvider provider, TaskModel task) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
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
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        final tasks = provider.filteredTasks;

        return Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            heroTag: 'fab_add_task',
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: const Text('Tugas Baru'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddTaskScreen()),
              );
            },
          ),
          body: RefreshIndicator(
            onRefresh: () => provider.fetchTasks(),
            child: Column(
              children: [
                // Search Box & Filter Header
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  color: Colors.white,
                  child: Column(
                    children: [
                      // Search TextField
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari tugas, kategori, atau deskripsi...',
                          prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    provider.setSearchQuery('');
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (val) => provider.setSearchQuery(val),
                      ),
                      const SizedBox(height: 8),

                      // Filter Status Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            const Text(
                              'Status: ',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            ...['Semua', 'Belum Selesai', 'Selesai'].map((status) {
                              final isSelected = provider.statusFilter == status;
                              return Padding(
                                padding: const EdgeInsets.only(right: 6.0),
                                child: ChoiceChip(
                                  label: Text(status),
                                  selected: isSelected,
                                  selectedColor: Colors.deepPurple.shade100,
                                  labelStyle: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? Colors.deepPurple : Colors.black87,
                                  ),
                                  onSelected: (_) => provider.setStatusFilter(status),
                                ),
                              );
                            }),
                            const SizedBox(width: 8),
                            const Text(
                              'Prioritas: ',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            ...['Semua', 'Tinggi', 'Sedang', 'Rendah'].map((priority) {
                              final isSelected = provider.priorityFilter == priority;
                              return Padding(
                                padding: const EdgeInsets.only(right: 6.0),
                                child: ChoiceChip(
                                  label: Text(priority),
                                  selected: isSelected,
                                  selectedColor: Colors.orange.shade100,
                                  labelStyle: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? Colors.deepOrange.shade900 : Colors.black87,
                                  ),
                                  onSelected: (_) => provider.setPriorityFilter(priority),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Main Task Content Area (Responsive Grid / List)
                Expanded(
                  child: provider.isLoading
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text('Memuat data tugas...'),
                            ],
                          ),
                        )
                      : provider.errorMessage != null
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.error_outline, size: 54, color: Colors.red),
                                    const SizedBox(height: 12),
                                    Text(
                                      provider.errorMessage!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton.icon(
                                      onPressed: () => provider.fetchTasks(),
                                      icon: const Icon(Icons.refresh),
                                      label: const Text('Coba Lagi'),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : tasks.isEmpty
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(32.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.assignment_turned_in_outlined,
                                          size: 64,
                                          color: Colors.grey.shade400,
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                          'Tidak ada tugas yang ditemukan.',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'Coba ganti filter pencarian atau buat tugas baru sekarang!',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                                        ),
                                        const SizedBox(height: 20),
                                        ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.deepPurple,
                                            foregroundColor: Colors.white,
                                          ),
                                          icon: const Icon(Icons.add),
                                          label: const Text('Tambah Tugas Baru'),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => const AddTaskScreen(),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : LayoutBuilder(
                                  builder: (context, constraints) {
                                    // Responsivitas: List di layar sempit (< 650px), Grid di layar lebar (>= 650px)
                                    final isWide = constraints.maxWidth >= 650;
                                    final crossAxisCount = constraints.maxWidth >= 1000 ? 3 : 2;

                                    if (isWide) {
                                      return GridView.builder(
                                        padding: const EdgeInsets.all(16.0),
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: crossAxisCount,
                                          crossAxisSpacing: 12,
                                          mainAxisSpacing: 12,
                                          childAspectRatio: 2.2,
                                        ),
                                        itemCount: tasks.length,
                                        itemBuilder: (context, index) {
                                          final task = tasks[index];
                                          return TaskCard(
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
                                            onDelete: () => _confirmDelete(context, provider, task),
                                          );
                                        },
                                      );
                                    } else {
                                      return ListView.builder(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0,
                                          vertical: 8.0,
                                        ),
                                        itemCount: tasks.length,
                                        itemBuilder: (context, index) {
                                          final task = tasks[index];
                                          return TaskCard(
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
                                            onDelete: () => _confirmDelete(context, provider, task),
                                          );
                                        },
                                      );
                                    }
                                  },
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
