import 'package:flutter/material.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String? userName;
  final String? userNim;

  const HomeScreen({super.key, this.userName, this.userNim});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<dynamic> _tasks = [];
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedPriority = 'Normal';
  String _filterStatus = 'Semua'; // Status filter: Semua, Belum, Selesai

  void _addTask() {
    if (_taskController.text.trim().isNotEmpty) {
      setState(() {
        _tasks.add({
          'title': _taskController.text.trim(),
          'isDone': false,
          'priority': _selectedPriority,
        });
        _taskController.clear();
        _selectedPriority = 'Normal';
      });
    }
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Tugas'),
          content: const Text('Apakah Anda yakin ingin menghapus tugas ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _tasks.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  void _confirmClearAll() {
    if (_tasks.isEmpty) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Semua Tugas'),
          content: const Text('Apakah Anda yakin ingin menghapus seluruh daftar tugas?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _tasks.clear();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Hapus Semua'),
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Penting':
        return Colors.red;
      case 'Sedang':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  @override
  void dispose() {
    _taskController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.userName ?? 'I Putu Agus Martha Jaya';
    final nim = widget.userNim ?? '2415051097';

    // Filter tugas berdasarkan pencarian dan status (Commit ke-14)
    final filteredTasks = _tasks.where((task) {
      final title = (task['title'] as String).toLowerCase();
      final isDone = task['isDone'] as bool;
      
      bool matchesSearch = title.contains(_searchQuery.toLowerCase());
      bool matchesFilter = true;

      if (_filterStatus == 'Belum') {
        matchesFilter = !isDone;
      } else if (_filterStatus == 'Selesai') {
        matchesFilter = isDone;
      }

      return matchesSearch && matchesFilter;
    }).toList();

    final int completedCount = _tasks
        .where((task) => (task as Map<String, dynamic>)['isDone'] == true)
        .length;
    final int totalCount = _tasks.length;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('TaskMate - Daftar Tugas', style: TextStyle(fontSize: 18)),
            Text(
              '$name ($nim)',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white24,
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : 'A',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Keluar',
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input Tugas & Prioritas
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(
                      labelText: 'Tambah tugas baru...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.add_task),
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedPriority,
                  items: ['Normal', 'Sedang', 'Penting'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: const TextStyle(fontSize: 13)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPriority = newValue!;
                    });
                  },
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  child: const Text('Tambah'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Input Pencarian & Pilihan Filter Status
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Cari tugas...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _filterStatus,
                  items: ['Semua', 'Belum', 'Selesai'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text('Filter: $value', style: const TextStyle(fontSize: 13)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _filterStatus = newValue!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Statistik & Tombol Hapus Semua
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.deepPurple.shade200),
                    ),
                    child: Text(
                      'Total: $totalCount | Selesai: $completedCount',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple.shade800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _tasks.isEmpty ? null : _confirmClearAll,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade50,
                    foregroundColor: Colors.red,
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.delete_sweep, size: 18),
                  label: const Text('Hapus Semua'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredTasks.isEmpty
                  ? const Center(
                      child: Text(
                        'Tidak ada tugas ditemukan.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index] as Map<String, dynamic>;
                        final originalIndex = _tasks.indexOf(task);
                        final priority = task['priority'] ?? 'Normal';

                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: Checkbox(
                              value: task['isDone'] as bool,
                              onChanged: (bool? value) {
                                setState(() {
                                  _tasks[originalIndex]['isDone'] = value ?? false;
                                });
                              },
                            ),
                            title: Text(
                              task['title'] as String,
                              style: TextStyle(
                                decoration: (task['isDone'] as bool)
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                color: (task['isDone'] as bool)
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              'Prioritas: $priority',
                              style: TextStyle(
                                fontSize: 12,
                                color: _getPriorityColor(priority),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                              onPressed: () => _confirmDelete(originalIndex),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}