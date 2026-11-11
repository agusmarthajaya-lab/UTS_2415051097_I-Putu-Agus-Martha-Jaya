import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import 'home_screen.dart';
import 'task_list_screen.dart';
import 'add_task_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String userName;
  final String userNim;

  const DashboardScreen({
    super.key,
    required this.userName,
    required this.userNim,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<TaskProvider>(context, listen: false);
      provider.fetchTasks();
      provider.fetchDailyQuote();
    });
  }

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
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
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        userName: widget.userName,
        userNim: widget.userNim,
        onNavigateToTasks: () => _onDestinationSelected(1),
        onNavigateToAddTask: () => _onDestinationSelected(2),
      ),
      TaskListScreen(
        userName: widget.userName,
        userNim: widget.userNim,
      ),
      AddTaskScreen(
        onSuccess: () => _onDestinationSelected(1),
      ),
      ProfileScreen(
        userName: widget.userName,
        userNim: widget.userNim,
        onLogout: _confirmLogout,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 700;

        return Scaffold(
          appBar: AppBar(
            elevation: 1,
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            title: Row(
              children: [
                const Icon(Icons.task_alt, size: 24),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TaskMate',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${widget.userName} (${widget.userNim})',
                      style: const TextStyle(fontSize: 11, color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Segarkan Data',
                onPressed: () {
                  final provider = Provider.of<TaskProvider>(context, listen: false);
                  provider.fetchTasks();
                  provider.fetchDailyQuote();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Data berhasil dimuat ulang!'),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Keluar',
                onPressed: _confirmLogout,
              ),
            ],
          ),
          body: isWide
              ? Row(
                  children: [
                    NavigationRail(
                      selectedIndex: _selectedIndex,
                      onDestinationSelected: _onDestinationSelected,
                      labelType: NavigationRailLabelType.all,
                      selectedIconTheme: const IconThemeData(color: Colors.deepPurple),
                      selectedLabelTextStyle: const TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                      destinations: const [
                        NavigationRailDestination(
                          icon: Icon(Icons.dashboard_outlined),
                          selectedIcon: Icon(Icons.dashboard),
                          label: Text('Dashboard'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.checklist_outlined),
                          selectedIcon: Icon(Icons.checklist),
                          label: Text('Daftar'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.add_task_outlined),
                          selectedIcon: Icon(Icons.add_task),
                          label: Text('Tambah'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.person_outline),
                          selectedIcon: Icon(Icons.person),
                          label: Text('Profil'),
                        ),
                      ],
                    ),
                    const VerticalDivider(thickness: 1, width: 1),
                    Expanded(child: screens[_selectedIndex]),
                  ],
                )
              : screens[_selectedIndex],
          bottomNavigationBar: isWide
              ? null
              : NavigationBar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onDestinationSelected,
                  indicatorColor: Colors.deepPurple.shade100,
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.dashboard_outlined),
                      selectedIcon: Icon(Icons.dashboard, color: Colors.deepPurple),
                      label: 'Ringkasan',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.checklist_outlined),
                      selectedIcon: Icon(Icons.checklist, color: Colors.deepPurple),
                      label: 'Tugas',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.add_circle_outline),
                      selectedIcon: Icon(Icons.add_circle, color: Colors.deepPurple),
                      label: 'Tambah',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person, color: Colors.deepPurple),
                      label: 'Profil',
                    ),
                  ],
                ),
        );
      },
    );
  }
}
