import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('bookstore.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        correo TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE pedidos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fecha TEXT NOT NULL,
        total REAL NOT NULL,
        metodoPago TEXT NOT NULL,
        estado TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertarUsuario(
    String correo,
    String password,
  ) async {
    final db = await database;

    return await db.insert(
      'usuarios',
      {
        'correo': correo,
        'password': password,
      },
    );
  }

  Future<Map<String, dynamic>?> buscarUsuario(
    String correo,
    String password,
  ) async {
    final db = await database;

    final resultado = await db.query(
      'usuarios',
      where: 'correo = ? AND password = ?',
      whereArgs: [correo, password],
      limit: 1,
    );

    if (resultado.isNotEmpty) {
      return resultado.first;
    }

    return null;
  }

  Future<int> insertarPedido({
    required String fecha,
    required double total,
    required String metodoPago,
    required String estado,
  }) async {
    final db = await database;

    return await db.insert(
      'pedidos',
      {
        'fecha': fecha,
        'total': total,
        'metodoPago': metodoPago,
        'estado': estado,
      },
    );
  }

  Future<List<Map<String, dynamic>>> obtenerPedidos() async {
    final db = await database;

    return await db.query(
      'pedidos',
      orderBy: 'id DESC',
    );
  }

  Future<void> cerrar() async {
    final db = await database;
    await db.close();

    _database = null;
  }
}