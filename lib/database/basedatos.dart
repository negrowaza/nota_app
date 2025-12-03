import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BaseDatos {
  static final BaseDatos instancia = BaseDatos._init();
  static Database? _database;

  BaseDatos._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('colegio.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _crearBD,
    );
  }

  Future _crearBD(Database db, int version) async {
    await db.execute('''
      CREATE TABLE materias (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE notas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        idMateria INTEGER NOT NULL,
        titulo TEXT NOT NULL,
        valor REAL NOT NULL,
        fecha TEXT NOT NULL,
        FOREIGN KEY(idMateria) REFERENCES materias(id)
      )
    ''');
  }

  // INSERTAR MATERIA
  Future<int> insertarMateria(String nombre) async {
    final db = await instancia.database;
    return db.insert('materias', {'nombre': nombre});
  }

  // LISTAR MATERIAS
  Future<List<Map<String, dynamic>>> obtenerMaterias() async {
    final db = await instancia.database;
    return db.query('materias');
  }

  // INSERTAR NOTA
  Future<int> insertarNota(Map<String, dynamic> data) async {
    final db = await instancia.database;
    return db.insert('notas', data);
  }

  // TRAER NOTAS POR MATERIA
  Future<List<Map<String, dynamic>>> obtenerNotasPorMateria(int idMateria) async {
    final db = await instancia.database;
    return db.query(
      'notas',
      where: 'idMateria = ?',
      whereArgs: [idMateria],
    );
  }

  // PROMEDIO POR MATERIA
  Future<double> promedioDeMateria(int idMateria) async {
    final db = await instancia.database;
    final resultado = await db.rawQuery('''
      SELECT AVG(valor) as promedio
      FROM notas
      WHERE idMateria = ?
    ''', [idMateria]);

    return resultado.first['promedio'] == null
        ? 0.0
        : resultado.first['promedio'] as double;
  }
}
