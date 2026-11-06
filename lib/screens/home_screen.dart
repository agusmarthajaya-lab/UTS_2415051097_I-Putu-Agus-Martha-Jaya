import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/quote_card.dart';
import '../widgets/task_card.dart';
import '../models/task_model.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Memuat data kutipan dan tugas saat halaman pertama kali dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).loadDashboardData();
    });
  }

  // Fungsi untuk menampilkan dialog form tambah tugas
  void _showAddTaskDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    String selectedCategory = 'General';
    String selectedPriority = 'Medium';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Tambah Tugas Baru'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Judul Tugas'),
                ),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: 'Deskripsi'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: ['General', 'Kuliah', 'Pribadi', 'Pekerjaan']
                      .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                  onChanged: (val) => selectedCategory = val ?? 'General',
                  decoration: const InputDecoration(labelText: 'Kategori'),
                ),
                DropdownButtonFormField<String>(
                  value: selectedPriority,
                  items: ['Low', 'Medium', 'High']
                      .map((pri) => DropdownMenuItem(value: pri, child: Text(pri)))
                      .toList(),
                  onChanged: (val) => selectedPriority = val ?? 'Medium',
                  decoration: const InputDecoration(labelText: 'Prioritas'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  final newTask = TaskModel(
                    title: titleController.text,
                    description: descController.text,
                    category: selectedCategory,
                    priority: selectedPriority,
                  );
                  Provider.of<TaskProvider>(context, listen: false).addTask(newTask);
                  Navigator.pop(dialogContext);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskMate - UTS Flutter'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          if (taskProvider.state == ViewState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () => taskProvider.loadDashboardData(),
            child: Column(
              children: [
                // Menampilkan Widget Quote Motivasi dari API
                QuoteCard(quote: taskProvider.quote),
                
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Daftar Tugas Anda',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                // Daftar Tugas
                Expanded(
                  child: taskProvider.state == ViewState.empty
                      ? const Center(
                          child: Text(
                            'Belum ada tugas. Yuk tambahkan tugas baru!',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: taskProvider.tasks.length,
                          itemBuilder: (context, index) {
                            final task = taskProvider.tasks[index];
                            return TaskCard(
                              task: task,
                              onCheckboxChanged: (val) {
                                if (task.id != null) {
                                  taskProvider.toggleTask(task.id!, task.isCompleted);
                                }
                              },
                              onDelete: () {
                                if (task.id != null) {
                                  taskProvider.deleteTask(task.id!);
                                }
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}