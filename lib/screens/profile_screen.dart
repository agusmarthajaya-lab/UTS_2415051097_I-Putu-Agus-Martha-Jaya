import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengembang'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Avatar / Logo Inisial
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.deepPurple.shade100,
              child: const Icon(
                Icons.person,
                size: 50,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),
            // Nama Lengkap Mahasiswa
            const Text(
              'I Putu Agus Martha Jaya',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // NIM Mahasiswa
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.deepPurple.shade200),
              ),
              child: const Text(
                'NIM: 2415051097',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 20),
            // Informasi Detail Project UTS
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Informasi Aplikasi UTS',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.apps, color: Colors.deepPurple),
                      title: Text('Nama Aplikasi'),
                      subtitle: Text('TaskMate (Task Management App)'),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.architecture, color: Colors.deepPurple),
                      title: Text('Arsitektur'),
                      subtitle: Text('Modular Clean Architecture & Provider'),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.storage, color: Colors.deepPurple),
                      title: Text('Backend & API'),
                      subtitle: Text('Supabase Database & ZenQuotes API'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}