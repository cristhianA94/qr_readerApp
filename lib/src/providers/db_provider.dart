import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:qr_reader/src/models/scan_model.dart';
export 'package:qr_reader/src/models/scan_model.dart';

class DBProvider {
  // TODO Patron Singleton
  static Database _database;
  static final DBProvider db = DBProvider._();
  // Constructor privado
  DBProvider._();

  Future<Database> get database async {
    // Valida que se regrese la misma BD
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  Future<Database> initDB() async {
    // Path de BD
    Directory documetsDirectory = await getApplicationDocumentsDirectory();

    /// `join` Permite unir varios paths
    final path = join(documetsDirectory.path, 'ScansDB.db');

    // TODO Crear BD Sqlite
    /// `version` incrementar version cada vez que haya cambios
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(''' 
      CREATE TABLE Scans(
        id INTEGER PRIMARY KEY,
        tipo TEXT,
        valor TEXT
      );
          ''');
    });
  }

  // Version tediosa
  Future<int> nuevoScanRaw(ScanModel nuevoScan) async {
    final id = nuevoScan.id;
    final tipo = nuevoScan.tipo;
    final valor = nuevoScan.valor;

    // Verificar si esta lista la DB
    final db = await database;

    final res = await db.rawInsert('''
      INSERT INTO Scans(id, tipo, valor)
      VALUES(${id}, ${tipo}, ${valor});
      ''');
    return res;
  }

  // **INSERT
  Future<int> nuevoScan(ScanModel nuevoScan) async {
    // Verificar si esta lista la DB
    final db = await database;
    final res = await db.insert('Scans', nuevoScan.toJson());
    // Res es el ID del ultimo registro insertado
    return res;
  }

  // **UPDATE
  Future<int> updateScan(ScanModel scan) async {
    // Verificar si esta lista la DB
    final db = await database;
    final res = await db
        .update('Scans', scan.toJson(), where: 'id = ?', whereArgs: [scan.id]);

    return res;
  }

  // **DELETE
  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);

    return res;
  }

  // Borra todos los registros
  Future<int> deleteAllScans() async {
    final db = await database;
    final res = await db.rawDelete('''
    DELETE FROM Scans;
    ''');

    return res;
  }

  // **GET
  Future<List<ScanModel>> getTodosScans() async {
    final db = await database;
    final res = await db.query('Scans');

    return res.isNotEmpty
        ? res.map((scans) => ScanModel.fromJson(scans)).toList()
        : [];
  }

  // Obtener un registro
  Future<ScanModel> getScanById(int id) async {
    final db = await database;
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  // Obtiene todos los registros por tipo
  Future<List<ScanModel>> getScansPorTipo(String tipo) async {
    final db = await database;
    final res = await db.rawQuery('''
    SELECT * FROM Scans WHERE tipo = '$tipo';
    ''');

    return res.isNotEmpty
        ? res.map((scans) => ScanModel.fromJson(scans)).toList()
        : [];
  }
}
