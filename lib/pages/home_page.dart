import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'tugas_penting_page.dart';
import 'tugas_biasa_page.dart';
import 'daftar_tugas_page.dart';
import 'pengaturan_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int tugasSelesai = 0;
  int tugasBelum = 0;

  // Data Grafik Harian
  Map<String, int> statistikHarian = {
    "Sen": 0, "Sel": 0, "Rab": 0, "Kam": 0,
    "Jum": 0, "Sab": 0, "Min": 0,
  };

  final List<String> hariSingkat = ["Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min"];

  // Ambil Data dari Database
  void getStatistik() async {
    final data = await DatabaseHelper.getData();

    int selesai = 0;
    int belum = 0;

    Map<String, int> harian = {
      "Sen": 0, "Sel": 0, "Rab": 0, "Kam": 0,
      "Jum": 0, "Sab": 0, "Min": 0,
    };

    for (var tugas in data) {
      if (tugas['selesai'] == 1) {
        selesai++;

        try {
          DateTime tanggal = DateTime.parse(tugas['tanggal']);
          int hari = tanggal.weekday; // 1 = Senin, 7 = Minggu

          if (hari == 1) harian["Sen"] = harian["Sen"]! + 1;
          if (hari == 2) harian["Sel"] = harian["Sel"]! + 1;
          if (hari == 3) harian["Rab"] = harian["Rab"]! + 1;
          if (hari == 4) harian["Kam"] = harian["Kam"]! + 1;
          if (hari == 5) harian["Jum"] = harian["Jum"]! + 1;
          if (hari == 6) harian["Sab"] = harian["Sab"]! + 1;
          if (hari == 7) harian["Min"] = harian["Min"]! + 1;
        } catch (e) {
          // Skip jika format tanggal error
        }
      } else {
        belum++;
      }
    }

    setState(() {
      tugasSelesai = selesai;
      tugasBelum = belum;
      statistikHarian = harian;
    });
  }

  @override
  void initState() {
    super.initState();
    getStatistik();
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
          "Beranda",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: getStatistik,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => getStatistik(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.teal.shade100,
                    child: const Text("👋", style: TextStyle(fontSize: 28)),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Halo, Hety Rachmawati!",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F766E),
                        ),
                      ),
                      Text(
                        _getCurrentDate(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Statistic Cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      "Tugas Selesai",
                      tugasSelesai,
                      Colors.green,
                      Icons.check_circle_rounded,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      "Belum Selesai",
                      tugasBelum,
                      Colors.orange,
                      Icons.pending_rounded,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Grafik Harian
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Aktivitas Minggu Ini",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F766E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Tugas yang telah diselesaikan",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),

                    // Bar Chart
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,

                    children: hariSingkat.map((hari) {

                      int jumlah = statistikHarian[hari] ?? 0;

                      double height = jumlah * 18.0;

                      return Column(
                        children: [

                          // ANGKA JUMLAH
                          jumlah > 0
                              ? Text(
                                  jumlah.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                )
                              : const SizedBox(height: 18),

                          const SizedBox(height: 6),

                          // BATANG GRAFIK
                          Container(

                            width: 28,

                            height: jumlah == 0
                                ? 8
                                : height < 15
                                    ? 15
                                    : height,

                            decoration: BoxDecoration(

                              color: jumlah == 0
                                  ? Colors.grey.shade300
                                  : Colors.teal,

                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // NAMA HARI
                          Text(
                            hari,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Menu Utama
              const Text(
                "Menu Utama",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F766E),
                ),
              ),
              const SizedBox(height: 16),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildMenuCard(context, "Tugas Penting", Icons.priority_high_rounded,
                      const Color(0xFFE11D48), const TugasPentingPage()),
                  _buildMenuCard(context, "Tugas Biasa", Icons.add_task_rounded,
                      const Color(0xFF10B981), const TugasBiasaPage()),
                  _buildMenuCard(context, "Daftar Tugas", Icons.format_list_bulleted_rounded,
                      const Color(0xFF3B82F6), const DaftarTugasPage()),
                  _buildMenuCard(context, "Pengaturan", Icons.settings_rounded,
                      const Color(0xFF64748B), const PengaturanPage()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Statistic Card
  Widget _buildStatCard(String title, int value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey),
          ),
          Text(
            "$value",
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // Widget Menu Card
  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    Widget page,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
        getStatistik(); // Refresh setelah kembali
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    const bulan = [
      "", "Januari", "Februari", "Maret", "April", "Mei", "Juni",
      "Juli", "Agustus", "September", "Oktober", "November", "Desember"
    ];
    return "${now.day} ${bulan[now.month]} ${now.year}";
  }
}