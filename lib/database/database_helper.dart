import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {

  static Database? database;

  // DATABASE
  static Future<Database> getDatabase() async {

    if(database != null){
      return database!;
    }

    database = await openDatabase(

      join(await getDatabasesPath(), 'agenda.db'),

      onCreate: (db, version) async {

        await db.execute('''
        CREATE TABLE tugas(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          judul TEXT,
          deskripsi TEXT,
          tanggal TEXT,
          kategori TEXT,
          selesai INTEGER
        )
        ''');

      },

      version: 1,

    );

    return database!;
  }

  // INSERT DATA
  static Future insertData(

      String judul,
      String deskripsi,
      String tanggal,
      String kategori,

      ) async {

    final db = await getDatabase();

    await db.insert(

      'tugas',

      {
        'judul': judul,
        'deskripsi': deskripsi,
        'tanggal': tanggal,
        'kategori': kategori,
        'selesai': 0,
      },

    );
  }

  // AMBIL DATA
  static Future<List<Map<String, dynamic>>> getData() async {

    final db = await getDatabase();

    return db.query('tugas');
  }

  // UPDATE STATUS
  static Future updateStatus(int id, int status) async {

    final db = await getDatabase();

    await db.update(

      'tugas',

      {
        'selesai': status,
      },

      where: 'id = ?',
      whereArgs: [id],

    );
  }
}