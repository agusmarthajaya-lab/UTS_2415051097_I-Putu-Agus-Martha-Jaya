# TaskMate - Mobile Application Mini Project (UTS Pemrograman Mobile)

Aplikasi mobile manajemen tugas dan produktivitas (*Task & Productivity Management*) yang dibangun dengan **Flutter** dan **Dart**, mengintegrasikan konsep *Responsive Layout*, *Multi-Screen Navigation*, *State Management (Provider)*, *Clean Architecture*, *REST API Integration*, serta *Backend Database (Supabase / PostgreSQL)*.

---

## 👤 Identitas Mahasiswa
* **Nama:** I Putu Agus Martha Jaya
* **NIM:** 2415051097
* **Program Studi / Kelas:** Pendidikan Teknik Informatika
* **Mata Kuliah:** Pemrograman Mobile
* **Dosen Pengampu:** Dr. Ir. I Ketut Resika Arthana, S.T., M.Kom
* **Teaching Assistant:** Made Yuda Sadewa, S.Pd.

---

## 🚀 Fitur Utama Aplikasi
1. **Autentikasi & Identitas Pengguna:** Layar login validasi nama dan NIM dengan feedback SnackBar visual.
2. **Dashboard & Ringkasan Progres:**
   - Menampilkan salam personal dengan inisial avatar.
   - Indikator statistik interaktif (*Total Tugas, Tugas Selesai, Tugas Pending, dan Persentase Kelulusan Progres*).
   - Pratinjau tugas prioritas tinggi dan tombol aksi cepat.
3. **Kutipan Motivasi Harian (REST API):**
   - Mengambil data motivasi real-time dari ZenQuotes API (`GET /api/random`).
   - Parsing JSON ke Dart Model (`QuoteModel`).
   - Menangani *Loading State*, *Error State*, dan tombol muat ulang (*Refresh*).
4. **Katalog & Daftar Tugas Responsif:**
   - Pencarian dinamis (*Search Bar*) berdasarkan judul, deskripsi, atau kategori.
   - Filter status selesai (*Semua, Belum Selesai, Selesai*).
   - Filter tingkat prioritas (*Semua, Tinggi, Sedang, Rendah*).
   - **Tampilan Responsif:** Menampilkan `ListView` pada layar ponsel/compact (< 650px) dan otomatis beralih menjadi `GridView` (2 hingga 3 kolom) pada tablet/desktop (>= 650px).
5. **Detail Tugas (Passing Data):**
   - Menampilkan rincian data tugas secara lengkap (*Judul, Deskripsi, Kategori, Prioritas, Status, Waktu Pembuatan*).
   - Tombol toggle status instan (*Selesai / Belum Selesai*).
   - Tombol navigasi ke form Edit data.
6. **Form Tambah Tugas (Create Data):**
   - Validasi formulir menggunakan `GlobalKey<FormState>`.
   - Input judul (min 3 karakter), deskripsi, pilihan kategori (dropdown), dan pemilihan prioritas interaktif.
7. **Form Edit Tugas (Update Data):**
   - Memperbarui judul, deskripsi, kategori, tingkat prioritas, dan switch status selesai.
   - Terintegrasi langsung dengan Provider dan Repository.
8. **Hapus Data & Konfirmasi Dialog (Delete Data):**
   - Setiap penghapusan tugas wajib melalui dialog konfirmasi (`AlertDialog`) sebelum data dihapus dari database.
9. **Profil Mahasiswa:**
   - Menampilkan biodata mahasiswa, informasi mata kuliah, ringkasan capaian tugas, dan tombol logout dengan konfirmasi.

---

## 🛠️ Tech Stack
* **Framework:** Flutter 3.x (Material 3)
* **Bahasa Pemrograman:** Dart (Null-safety enabled)
* **State Management:** Provider (`ChangeNotifierProvider`, `Consumer`)
* **Arsitektur:** Clean Layered Architecture (`UI -> Provider -> Repository -> Service -> Data Source`)
* **HTTP Client:** `http: ^1.2.0`
* **Backend Database:** Supabase Flutter SDK (`supabase_flutter: ^2.3.4`) & In-Memory Persistent Fallback Cache
* **Format Tanggal:** `intl: ^0.19.0`
* **Version Control:** Git & GitHub

---

## 🌐 Integrasi REST API
* **Endpoint API:** `https://zenquotes.io/api/random`
* **Metode HTTP:** `GET`
* **Dart Model:** `QuoteModel` (`quote`, `author`)
* **State yang Ditangani:**
  - *Loading State:* Indikator animasi loading (`CircularProgressIndicator`).
  - *Success State:* Menampilkan kutipan teks dan nama penulis ke dalam `QuoteCard`.
  - *Error State:* Menampilkan pesan kegagalan dan beralih ke kutipan cadangan yang aman tanpa menghentikan aplikasi.

---

## 🗄️ Backend & Database (Supabase / PostgreSQL)
Aplikasi mendukung integrasi database Supabase pada tabel utama `tasks`.

### Skema Tabel Database `tasks`:
```sql
CREATE TABLE tasks (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  category TEXT DEFAULT 'Kuliah',
  priority TEXT DEFAULT 'Sedang',
  is_completed BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```
* **Jumlah Field Data:** 6 field data + 1 primary key (ID) = 7 field *(memenuhi syarat minimal >= 4 field data + ID)*.
* **Operasi CRUD Terintegrasi:**
  - **Create:** `addTask(TaskModel task)` -> `insert()`
  - **Read:** `getTasks()` -> `select().order('created_at', ascending: false)`
  - **Update:** `updateTask(TaskModel task)` -> `update().eq('id', id)`
  - **Delete:** `deleteTask(String id)` -> `delete().eq('id', id)`

---

## 🏛️ Struktur Arsitektur Aplikasi
Struktur direktori disusun rapi mengikuti kaidah clean architecture sesuai pedoman UTS:

```
lib/
├── models/
│   ├── quote_model.dart       # Model Dart untuk data kutipan REST API
│   └── task_model.dart        # Model Dart untuk entitas Tugas (7 fields)
├── services/
│   ├── api_service.dart       # Layanan HTTP GET ke REST API ZenQuotes
│   └── supabase_service.dart  # Layanan CRUD database Supabase
├── repositories/
│   └── task_repository.dart   # Abstraksi data layer & sinkronisasi cache
├── providers/
│   └── task_provider.dart     # State management terpusat (ChangeNotifier)
├── screens/
│   ├── login_screen.dart      # Screen 1: Login & input identitas
│   ├── dashboard_screen.dart  # Screen 2: Navigasi utama (NavigationBar & NavigationRail)
│   ├── home_screen.dart       # Screen 3: Ringkasan statistik & kutipan API
│   ├── task_list_screen.dart  # Screen 4: Katalog tugas responsif (List/Grid)
│   ├── task_detail_screen.dart# Screen 5: Detail tugas & aksi
│   ├── add_task_screen.dart   # Screen 6: Form tambah tugas (Validation)
│   ├── edit_task_screen.dart  # Screen 7: Form edit tugas
│   └── profile_screen.dart    # Screen 8: Profil mahasiswa & info UTS
├── widgets/
│   ├── custom_button.dart     # Custom Widget 1: Reusable elevated button
│   ├── quote_card.dart        # Custom Widget 2: Kartu kutipan REST API
│   ├── stats_card.dart        # Custom Widget 3: Kartu ringkasan progress
│   └── task_card.dart         # Custom Widget 4: Kartu item tugas interaktif
└── main.dart                  # Entry point aplikasi & MultiProvider setup
```

**Alur Data:**
`Screen / UI` ➔ `TaskProvider` ➔ `TaskRepository` ➔ `ApiService / SupabaseService` ➔ `REST API / Database`

---

## 📱 Daftar Screen Fungsional (Total 8 Screen)
1. **LoginScreen:** Autentikasi nama dan NIM mahasiswa.
2. **DashboardScreen:** Cangkang navigasi adaptif (`NavigationBar` pada smartphone, `NavigationRail` pada tablet/web).
3. **HomeScreen (Ringkasan):** Kartu selamat datang, widget REST API ZenQuotes, statistik progres, dan pratinjau prioritas tinggi.
4. **TaskListScreen (Katalog Tugas):** Search bar, chip filter status, chip filter prioritas, layout responsif `ListView` / `GridView`.
5. **TaskDetailScreen:** Menampilkan rincian field data, badge prioritas, tanggal terformat, tombol toggle, edit, dan hapus.
6. **AddTaskScreen:** Formulir tambah tugas lengkap dengan validasi form (`TextFormField`, `DropdownButtonFormField`).
7. **EditTaskScreen:** Formulir pembaruan data tugas dengan validasi dan switch status.
8. **ProfileScreen:** Biodata mahasiswa, program studi, dosen pengampu, ringkasan tugas, dan konfirmasi logout.

---

## 📐 Layout Responsif
Aplikasi mengimplementasikan 2 kondisi responsif utama menggunakan `LayoutBuilder` dan `MediaQuery`:
1. **Kondisi Compact (< 650px / 700px - Mobile Smartphone):**
   - Menggunakan `NavigationBar` di bagian bawah layar.
   - Daftar tugas disajikan dalam format `ListView` vertikal yang ergonomis.
   - Form dan kartu statistik beradaptasi memenuhi lebar layar ponsel dengan padding yang rapi.
2. **Kondisi Wide / Expanded (>= 650px / 700px - Tablet, Desktop, Web):**
   - Navigasi berpindah secara otomatis ke sisi kiri menggunakan `NavigationRail`.
   - Daftar tugas berubah menjadi `GridView` multi-kolom (2 hingga 3 kolom) yang memanfaatkan bidang layar secara optimal.
   - Tidak ada isu *RenderFlex overflow*.

---

## 💻 Cara Menjalankan Project

### 1. Prasyarat:
* Flutter SDK (versi >= 3.13.0)
* Dart SDK (versi >= 3.0.0)
* Koneksi internet (untuk fetch ZenQuotes API)

### 2. Langkah Menjalankan:
```bash
# 1. Clone repository
git clone https://github.com/agusmarthajaya/task_mate.git

# 2. Masuk ke direktori project
cd task_mate

# 3. Ambil seluruh dependencies
flutter pub get

# 4. Jalankan pengujian smoke test
flutter test

# 5. Jalankan aplikasi pada perangkat / emulator / browser
flutter run
```
*(Untuk menjalankan di Google Chrome: `flutter run -d chrome`)*

---

## 📋 Checklist Spesifikasi Minimum UTS
| Komponen | Spesifikasi Minimum | Status Implementasi |
| :--- | :--- | :---: |
| Screen Fungsional | $\ge$ 6 Screen (tanpa splash) | ✅ Terpenuhi (8 Screen) |
| Dart Model | $\ge$ 2 Model | ✅ Terpenuhi (`TaskModel`, `QuoteModel`) |
| Reusable Widget | $\ge$ 3 Widget | ✅ Terpenuhi (4 Custom Widgets) |
| Responsive Layout | $\ge$ 2 Kondisi (Compact & Wide) | ✅ Terpenuhi (`LayoutBuilder`, List/Grid, Rail) |
| REST API | $\ge$ 1 REST API (GET wajib) | ✅ Terpenuhi (ZenQuotes API `GET /api/random`) |
| Data API di UI | Ditampilkan pada UI | ✅ Terpenuhi (`QuoteCard` dengan loading/error) |
| Backend Database | $\ge$ 1 Database | ✅ Terpenuhi (Supabase PostgreSQL `tasks`) |
| Field Tabel | $\ge$ 4 Data + ID | ✅ Terpenuhi (ID + 6 field data = 7 fields) |
| CRUD Database | Create, Read, Update, Delete | ✅ Terpenuhi (Lengkap 4 Operasi) |
| Konfirmasi Hapus | Delete confirmation dialog | ✅ Terpenuhi (`AlertDialog` sebelum hapus) |
| State Management | Provider + ChangeNotifier | ✅ Terpenuhi (`TaskProvider` + MultiProvider) |
| Multi-Screen Nav | Multi-screen dengan passing data | ✅ Terpenuhi (List ➔ Detail ➔ Edit) |
| Navigasi Utama | NavigationBar / NavigationRail | ✅ Terpenuhi (Adaptif responsif) |
| Form & Validasi | Minimal 1 Form + validasi | ✅ Terpenuhi (`Form` + `GlobalKey<FormState>`) |
| User Feedback | SnackBar & AlertDialog | ✅ Terpenuhi (Feedback sukses & gagal) |
| Loading, Error, Empty | 3 State pada UI | ✅ Terpenuhi pada daftar tugas & kutipan API |
| Git Commits | $\ge$ 16 Meaningful Commits | ✅ Terpenuhi ($\ge$ 16 commits di riwayat git) |
| README GitHub | Lengkap dengan identitas & panduan | ✅ Terpenuhi |
