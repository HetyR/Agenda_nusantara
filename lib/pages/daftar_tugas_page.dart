import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class DaftarTugasPage extends StatefulWidget {
  const DaftarTugasPage({super.key});

  @override
  State<DaftarTugasPage> createState() => _DaftarTugasPageState();
}

class _DaftarTugasPageState extends State<DaftarTugasPage> {
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> filteredData = [];
  final TextEditingController searchController = TextEditingController();

  Future<void> getData() async {
    final hasil = await DatabaseHelper.getData();
    setState(() {
      data = hasil;
      filteredData = hasil;
    });
  }

  Future<void> updateSelesai(int id, int value) async {
    await DatabaseHelper.updateStatus(id, value);
    getData();
  }

  void searchTask(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredData = data;
      } else {
        filteredData = data.where((tugas) {
          return tugas['judul'].toString().toLowerCase().contains(query.toLowerCase()) ||
              tugas['deskripsi'].toString().toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
            ),
          ),
        ),
        title: const Text(
          "Daftar Tugas",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: getData,
        color: Colors.teal,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                controller: searchController,
                onChanged: searchTask,
                decoration: InputDecoration(
                  hintText: "Cari tugas...",
                  prefixIcon: const Icon(Icons.search, color: Colors.teal),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: filteredData.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.task_alt, size: 80, color: Colors.grey),
                          SizedBox(height: 16),
                          Text("Belum ada tugas", style: TextStyle(fontSize: 18, color: Colors.grey)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        final tugas = filteredData[index];
                        final bool isPenting = tugas['kategori'] == "Penting";
                        final bool isDone = tugas['selesai'] == 1;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            leading: Checkbox(
                              value: isDone,
                              activeColor: isPenting ? Colors.red : Colors.teal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              onChanged: (value) {
                                updateSelesai(tugas['id'], value! ? 1 : 0);
                              },
                            ),
                            title: Text(
                              tugas['judul'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                decoration: isDone ? TextDecoration.lineThrough : null,
                                color: isDone ? Colors.grey : Colors.black87,
                              ),
                            ),
                            subtitle: Text(
                              "${_formatDate(tugas['tanggal'])} • ${tugas['kategori']}",
                              style: const TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: isPenting ? Colors.red : const Color(0xFF10B981),
                              size: 20,
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

  String _formatDate(String? dateStr) {
    if (dateStr == null) return "-";
    try {
      final date = DateTime.parse(dateStr);
      return "${date.day.toString().padLeft(2, '0')} ${_getBulanSingkat(date.month)} ${date.year}";
    } catch (e) {
      return dateStr;
    }
  }

  String _getBulanSingkat(int month) {
    const bulan = ["", "Jan", "Feb", "Mar", "Apr", "Mei", "Jun", "Jul", "Agu", "Sep", "Okt", "Nov", "Des"];
    return bulan[month];
  }
}