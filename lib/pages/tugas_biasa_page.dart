import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class TugasBiasaPage extends StatefulWidget {
  const TugasBiasaPage({super.key});

  @override
  State<TugasBiasaPage> createState() => _TugasBiasaPageState();
}

class _TugasBiasaPageState extends State<TugasBiasaPage> {
  final TextEditingController judulController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();

  DateTime? tanggal;

  Future<void> pilihTanggal() async {
    final DateTime? pilih = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF10B981), // Emerald green
            ),
          ),
          child: child!,
        );
      },
    );

    if (pilih != null) {
      setState(() {
        tanggal = pilih;
      });
    }
  }

  Future<void> simpan() async {
    if (judulController.text.isEmpty ||
        deskripsiController.text.isEmpty ||
        tanggal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Mohon lengkapi semua data"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    try {
      await DatabaseHelper.insertData(
        judulController.text,
        deskripsiController.text,
        tanggal.toString(),
        "Biasa",           // ← Diperbaiki
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tugas Biasa berhasil disimpan"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Terjadi kesalahan: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF10B981), Color(0xFF34D399)],
            ),
          ),
        ),
        title: const Text(
          "Tambah Tugas Biasa",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tanggal
            const Text(
              "Tanggal",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF10B981),
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: pilihTanggal,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Color(0xFF10B981)),
                    const SizedBox(width: 12),
                    Text(
                      tanggal == null
                          ? "Pilih Tanggal"
                          : "${tanggal!.day.toString().padLeft(2, '0')}/${tanggal!.month.toString().padLeft(2, '0')}/${tanggal!.year}",
                      style: TextStyle(
                        fontSize: 16,
                        color: tanggal == null ? Colors.grey : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Judul Tugas
            TextField(
              controller: judulController,
              decoration: InputDecoration(
                labelText: "Judul Tugas",
                prefixIcon: const Icon(Icons.title, color: Color(0xFF10B981)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFF10B981), width: 2),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Deskripsi
            TextField(
              controller: deskripsiController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Deskripsi",
                prefixIcon: const Icon(Icons.description_outlined, color: Color(0xFF10B981)),
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFF10B981), width: 2),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Tombol Aksi
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text("Batal"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: simpan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Simpan Tugas",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}