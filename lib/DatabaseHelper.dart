// ignore_for_file: file_names

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class Income {
  late int id;
  late String tanggal;
  late double nominal;
  late String keterangan;

  Income({
    required this.id,
    required this.tanggal,
    required this.nominal,
    required this.keterangan,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tanggal': tanggal,
      'nominal': nominal,
      'keterangan': keterangan,
    };
  }

  factory Income.fromMap(Map<String, dynamic> map) {
    return Income(
      id: map['id'],
      tanggal: map['tanggal'],
      nominal: map['nominal'],
      keterangan: map['keterangan'],
    );
  }
}

class Outcome {
  late int id;
  late String tanggal;
  late double nominal;
  late String keterangan;

  Outcome({
    required this.id,
    required this.tanggal,
    required this.nominal,
    required this.keterangan,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tanggal': tanggal,
      'nominal': nominal,
      'keterangan': keterangan,
    };
  }

  factory Outcome.fromMap(Map<String, dynamic> map) {
    return Outcome(
      id: map['id'],
      tanggal: map['tanggal'],
      nominal: map['nominal'],
      keterangan: map['keterangan'],
    );
  }
}

class DatabaseHelper {
  late Database _database;

  Future<void> initializeDatabase() async {
    final String dbPath = await getDatabasesPath();
    final String pathToDatabase = path.join(dbPath, 'android.db');

    _database = await openDatabase(
      pathToDatabase,
      version: 10,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE incomes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tanggal TEXT,
            nominal REAL,
            keterangan TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE outcomes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tanggal TEXT,
            nominal REAL,
            keterangan TEXT
          )
        ''');
      },
    );
  }

  // CRUD Pemasukan
  Future<List<Income>> getAllIncomes() async {
    await initializeDatabase();
    final List<Map<String, dynamic>> maps = await _database.query('incomes');
    return List.generate(maps.length, (i) {
      return Income.fromMap(maps[i]);
    });
  }

  Future<int> insertIncome(Income income) async {
    await initializeDatabase();
    return await _database.insert('incomes', income.toMap());
  }

  // CRUD Pengeluaran
  Future<List<Outcome>> getAllOutcomes() async {
    await initializeDatabase();
    final List<Map<String, dynamic>> maps = await _database.query('outcomes');
    return List.generate(maps.length, (i) {
      return Outcome.fromMap(maps[i]);
    });
  }

  Future<int> insertOutcome(Outcome outcome) async {
    await initializeDatabase();
    return await _database.insert('outcomes', outcome.toMap());
  }

  // Total Pemasukan dan Pengeluaran
  Future<double> getTotalIncome() async {
    await initializeDatabase();
    final List<Map<String, dynamic>> incomeMaps =
        await _database.query('incomes');
    double totalIncome = 0;
    for (var map in incomeMaps) {
      totalIncome += map['nominal'];
    }
    return totalIncome;
  }

  Future<double> getTotalOutcome() async {
    await initializeDatabase();
    final List<Map<String, dynamic>> outcomeMaps =
        await _database.query('outcomes');
    double totalOutcome = 0;
    for (var map in outcomeMaps) {
      totalOutcome += map['nominal'];
    }
    return totalOutcome;
  }
}
