import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../widgets/custom_button.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskModel task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late String _selectedCategory;
  late String _selectedPriority;
  late bool _isCompleted;
  bool _isLoading = false;

  final List<String> _categories = [
    'Kuliah',
    'Organisasi',
    'Pribadi',
    'Pekerjaan',
    'Lainnya',
  ];

  final List<String> _priorities = [
    'Tinggi',
    'Sedang',
    'Rendah',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descController = TextEditingController(text: widget.task.description);
    _selectedCategory = _categories.contains(widget.task.category)
        ? widget.task.category
        : _categories.first;
    _selectedPriority = _priorities.contains(widget.task.priority)
        ? widget.task.priority
        : 'Sedang';
    _isCompleted = widget.task.isCompleted;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submitChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final updatedTask = widget.task.copyWith(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        category: _selectedCategory,
        priority: _selectedPriority,
        isCompleted: _isCompleted,
      );

      final provider = Provider.of<TaskProvider>(context, listen: false);
      final success = await provider.updateTask(updatedTask);

      setState(() => _isLoading = false);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Perubahan tugas berhasil disimpan!'),
                ],
              ),
              backgroundColor: Colors.green.shade700,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(provider.errorMessage ?? 'Gagal memperbarui tugas.'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Data Tugas'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Perbarui Rincian Tugas',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'ID Tugas: ${widget.task.id}',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                      const Divider(height: 28),

                      // Judul
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Judul Tugas *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.title),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Judul tugas tidak boleh kosong.';
                          }
                          if (value.trim().length < 3) {
                            return 'Judul tugas minimal 3 karakter.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),

                      // Deskripsi
                      TextFormField(
                        controller: _descController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Deskripsi / Catatan *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.notes),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Deskripsi tidak boleh kosong.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),

                      // Kategori Dropdown
                      DropdownButtonFormField<String>(
                        initialValue: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Kategori Tugas *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.category),
                        ),
                        items: _categories.map((cat) {
                          return DropdownMenuItem<String>(
                            value: cat,
                            child: Text(cat),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedCategory = val);
                          }
                        },
                      ),
                      const SizedBox(height: 18),

                      // Prioritas Dropdown
                      DropdownButtonFormField<String>(
                        initialValue: _selectedPriority,
                        decoration: const InputDecoration(
                          labelText: 'Tingkat Prioritas *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.flag),
                        ),
                        items: _priorities.map((p) {
                          return DropdownMenuItem<String>(
                            value: p,
                            child: Text(p),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedPriority = val);
                          }
                        },
                      ),
                      const SizedBox(height: 18),

                      // Switch Status Selesai
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: _isCompleted ? Colors.green.shade50 : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _isCompleted ? Colors.green.shade200 : Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                                  color: _isCompleted ? Colors.green.shade700 : Colors.grey,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  _isCompleted ? 'Status: Selesai' : 'Status: Belum Selesai',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _isCompleted ? Colors.green.shade800 : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            Switch(
                              value: _isCompleted,
                              activeTrackColor: Colors.green,
                              onChanged: (val) {
                                setState(() => _isCompleted = val);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Submit Button
                      CustomButton(
                        text: 'Simpan Perubahan',
                        icon: Icons.check,
                        isLoading: _isLoading,
                        onPressed: _submitChanges,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
