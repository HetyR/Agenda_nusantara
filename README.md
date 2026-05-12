# agenda_nusantara1

Aplikasi Todo List sederhana berbasis Flutter yang dibuat untuk memenuhi tugas Sertikom BNSP DIPA 2026.  
Aplikasi ini membantu pengguna mencatat dan mengelola tugas penting maupun tugas biasa menggunakan database lokal SQLite.

---

# Fitur Aplikasi

- Login pengguna
- Dashboard berisi statistik tugas
- Tambah tugas penting
- Tambah tugas biasa
- Daftar seluruh tugas
- Menandai tugas selesai
- Penyimpanan data menggunakan SQLite
- Pengaturan username dan password
- Tampilan sederhana dan mudah digunakan

---

# Halaman Aplikasi

## 1. Login Page

Halaman login digunakan untuk masuk ke aplikasi.

### Default Login

- Username: `user`
- Password: `user`

### Fitur

- Input username
- Input password
- Validasi login
- Navigasi ke halaman beranda

---

## 2. Home Page

Halaman utama aplikasi setelah login berhasil.

### Menampilkan

- Total tugas selesai
- Total tugas belum selesai
- Tombol navigasi menu

### Menu Navigasi

- Tambah Tugas Penting
- Tambah Tugas Biasa
- Daftar Tugas
- Pengaturan

---

## 3. Tambah Tugas Penting

Halaman untuk menambahkan tugas kategori penting.

### Input Data

- Tanggal deadline
- Judul tugas
- Deskripsi tugas

### Fitur

- Menggunakan Date Picker
- Menyimpan data ke SQLite
- Tombol kembali ke beranda

---

## 4. Tambah Tugas Biasa

Halaman untuk menambahkan tugas kategori biasa.

### Input Data

- Tanggal deadline
- Judul tugas
- Deskripsi tugas

### Fitur

- Menyimpan data sebagai tugas biasa
- Menggunakan SQLite

---

## 5. Daftar Tugas

Halaman untuk menampilkan seluruh daftar tugas.

### Fitur

- Menampilkan semua tugas
- Scrollable ListView
- Penanda warna kategori tugas
  - Merah = tugas penting
  - Hijau = tugas biasa
- Menandai tugas selesai

---

## 6. Pengaturan

Halaman pengaturan akun pengguna.

### Fitur

- Mengubah username
- Mengubah password
- Validasi password lama
- Menampilkan identitas developer

---

# Teknologi yang Digunakan

- Flutter
- Dart
- SQLite
- Material Design

---

# Struktur Folder

```bash
lib/
├── database/
│   └── database_helper.dart
├── pages/
│   ├── login_page.dart
│   ├── home_page.dart
│   ├── tugas_penting_page.dart
│   ├── tugas_biasa_page.dart
│   ├── daftar_tugas_page.dart
│   └── pengaturan_page.dart
├── models/
│   └── tugas_model.dart
└── main.dart
