import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/custom_button.dart';

class AddTaskScreen extends StatefulWidget {
  final VoidCallback? onSuccess;

  const AddTaskScreen({super.key, this.onSuccess});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String _selectedCategory = 'Kuliah';
  String _selectedPriority = 'Sedang';
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
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final provider = Provider.of<TaskProvider>(context, listen: false);
      final success = await provider.addTask(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        category: _selectedCategory,
        priority: _selectedPriority,
      );

      setState(() => _isLoading = false);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Tugas berhasil ditambahkan ke database!'),
                ],
              ),
              backgroundColor: Colors.green.shade700,
              behavior: SnackBarBehavior.floating,
            ),
          );

          _titleController.clear();
          _descController.clear();

          if (widget.onSuccess != null) {
            widget.onSuccess!();
          } else if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(provider.errorMessage ?? 'Gagal menambahkan tugas.'),
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
        title: const Text('Tambah Tugas Baru'),
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
                        'Form Tambah Tugas',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Lengkapi data tugas Anda di bawah ini secara lengkap.',
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                      ),
                      const Divider(height: 28),

                      // Judul Tugas
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Judul Tugas *',
                          hintText: 'Contoh: Mengerjakan Modul 5',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.title),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Judul tugas wajib diisi.';
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
                          hintText: 'Tuliskan rincian atau catatan tugas...',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.notes),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Deskripsi tugas wajib diisi.';
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

                      // Prioritas Selector
                      const Text(
                        'Tingkat Prioritas *',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: _priorities.map((p) {
                          final isSelected = _selectedPriority == p;
                          Color color;
                          if (p == 'Tinggi') {
                            color = Colors.red;
                          } else if (p == 'Sedang') {
                            color = Colors.orange;
                          } else {
                            color = Colors.green;
                          }

                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: InkWell(
                                onTap: () => setState(() => _selectedPriority = p),
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isSelected ? color.withValues(alpha: 0.15) : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isSelected ? color : Colors.grey.shade300,
                                      width: isSelected ? 2 : 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(Icons.flag, size: 20, color: isSelected ? color : Colors.grey),
                                      const SizedBox(height: 4),
                                      Text(
                                        p,
                                        style: TextStyle(
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                          color: isSelected ? color : Colors.black87,
                                          fontSize: 12.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 28),

                      // Submit Button
                      CustomButton(
                        text: 'Simpan Tugas ke Database',
                        icon: Icons.save,
                        isLoading: _isLoading,
                        onPressed: _submitForm,
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
