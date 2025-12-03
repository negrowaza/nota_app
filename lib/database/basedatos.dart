import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class BaseDatos {
  static final BaseDatos instancia = BaseDatos._init();
  static Database? _database;
  BaseDatos._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('colegio_app.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, fileName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    // Usuarios: rol -> 'alumno' | 'profesor' | 'admin'
    await db.execute('''
      CREATE TABLE usuarios(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        rol TEXT NOT NULL,
        foto TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE materias(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE notas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        idMateria INTEGER NOT NULL,
        idUsuario INTEGER NOT NULL, -- alumno id
        titulo TEXT NOT NULL,
        valor REAL NOT NULL,
        fecha TEXT NOT NULL,
        FOREIGN KEY (idMateria) REFERENCES materias(id),
        FOREIGN KEY (idUsuario) REFERENCES usuarios(id)
      )
    ''');

    // seed demo users + materias
    await db.insert('usuarios', {
      'nombre': 'Carlos Estudiante',
      'email': 'alumno@demo.com',
      'password': '123456',
      'rol': 'alumno',
      'foto': 'https://i.pravatar.cc/150?img=12'
    });
    await db.insert('usuarios', {
      'nombre': 'Ana Profesor',
      'email': 'profesor@demo.com',
      'password': '123456',
      'rol': 'profesor',
      'foto': 'https://i.pravatar.cc/150?img=5'
    });
    await db.insert('usuarios', {
      'nombre': 'Admin',
      'email': 'admin@demo.com',
      'password': 'admin123',
      'rol': 'admin',
      'foto': 'https://i.pravatar.cc/150?img=1'
    });

    await db.insert('materias', {'nombre': 'Matemáticas'});
    await db.insert('materias', {'nombre': 'Ciencias'});
    await db.insert('materias', {'nombre': 'Historia'});
  }

  // ---------- Usuarios ----------
  Future<int> crearUsuario(Map<String, dynamic> u) async {
    final db = await database;
    return await db.insert('usuarios', u);
  }

  Future<Map<String, dynamic>?> obtenerUsuarioPorEmail(String email) async {
    final db = await database;
    final res = await db.query('usuarios', where: 'email = ?', whereArgs: [email]);
    if (res.isEmpty) return null;
    return res.first;
  }

  Future<Map<String, dynamic>?> obtenerUsuarioPorId(int id) async {
    final db = await database;
    final res = await db.query('usuarios', where: 'id = ?', whereArgs: [id]);
    if (res.isEmpty) return null;
    return res.first;
  }

  Future<List<Map<String, dynamic>>> listarUsuariosPorRol(String rol) async {
    final db = await database;
    return await db.query('usuarios', where: 'rol = ?', whereArgs: [rol]);
  }

  // ---------- Materias ----------
  Future<int> insertarMateria(String nombre) async {
    final db = await database;
    return await db.insert('materias', {'nombre': nombre});
  }

  Future<List<Map<String, dynamic>>> obtenerMaterias() async {
    final db = await database;
    return await db.query('materias', orderBy: 'nombre');
  }

  // ---------- Notas ----------
  Future<int> insertarNota(Map<String, dynamic> nota) async {
    final db = await database;
    return await db.insert('notas', nota);
  }

  Future<List<Map<String, dynamic>>> obtenerNotasPorMateriaYAlumno(int idMateria, int idUsuario) async {
    final db = await database;
    return await db.query('notas',
        where: 'idMateria = ? AND idUsuario = ?', whereArgs: [idMateria, idUsuario], orderBy: 'fecha DESC');
  }

  Future<List<Map<String, dynamic>>> obtenerNotasPorMateria(int idMateria) async {
    final db = await database;
    return await db.query('notas', where: 'idMateria = ?', whereArgs: [idMateria], orderBy: 'fecha DESC');
  }

  Future<double> promedioAlumnoMateria(int idMateria, int idUsuario) async {
    final db = await database;
    final res = await db.rawQuery('SELECT AVG(valor) as prom FROM notas WHERE idMateria = ? AND idUsuario = ?',
        [idMateria, idUsuario]);
    final prom = res.first['prom'];
    if (prom == null) return 0.0;
    return (prom as num).toDouble();
  }

  Future<double> promedioMateriaGeneral(int idMateria) async {
    final db = await database;
    final res =
        await db.rawQuery('SELECT AVG(valor) as prom FROM notas WHERE idMateria = ?', [idMateria]);
    final prom = res.first['prom'];
    if (prom == null) return 0.0;
    return (prom as num).toDouble();
  }

  Future<List<Map<String, dynamic>>> obtenerAlumnosConNotasEnMateria(int idMateria) async {
    final db = await database;
    final res = await db.rawQuery('''
      SELECT u.id, u.nombre, u.foto, AVG(n.valor) as promedio
      FROM usuarios u
      LEFT JOIN notas n ON u.id = n.idUsuario AND n.idMateria = ?
      WHERE u.rol = 'alumno'
      GROUP BY u.id
    ''', [idMateria]);
    return res;
  }

  // Editar / borrar nota
  Future<int> actualizarNota(int id, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update('notas', data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> eliminarNota(int id) async {
    final db = await database;
    return await db.delete('notas', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
