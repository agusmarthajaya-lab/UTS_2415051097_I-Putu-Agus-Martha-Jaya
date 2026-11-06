import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/task_provider.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase (Ganti URL dan Anon Key dengan milik Anda di Supabase Dashboard)
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL', // Ganti dengan Project URL Supabase Anda
    anonKey: 'YOUR_SUPABASE_ANON_KEY', // Ganti dengan Anon/Public Key Supabase Anda
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Mendaftarkan TaskProvider agar bisa digunakan di seluruh halaman
        ChangeNotifierProvider(create: (_) => TaskProvider()..fetchTasks()),
      ],
      child: MaterialApp(
        title: 'TaskMate UTS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}