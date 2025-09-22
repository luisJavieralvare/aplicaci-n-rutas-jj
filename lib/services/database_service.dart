import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/models.dart';

class DatabaseService {
  static Database? _database;
  static const String _databaseName = 'rutas_jj_offline.db';
  static const int _databaseVersion = 1;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDatabase,
    );
  }

  static Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE mercancia_offline (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        producto_id INTEGER NOT NULL,
        producto_data TEXT NOT NULL,
        cantidad INTEGER NOT NULL,
        tipo_registro TEXT NOT NULL,
        fecha TEXT NOT NULL,
        sincronizado INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE productos_cache (
        id INTEGER PRIMARY KEY,
        data TEXT NOT NULL,
        fecha_cache TEXT NOT NULL
      )
    ''');
  }

  // Guardar mercancía offline
  static Future<int> guardarMercanciaOffline(MercanciaRequest request, Producto producto) async {
    final db = await database;
    return await db.insert('mercancia_offline', {
      'producto_id': request.productoId,
      'producto_data': jsonEncode(producto.toJson()),
      'cantidad': request.cantidad,
      'tipo_registro': request.tipoRegistro,
      'fecha': DateTime.now().toIso8601String(),
      'sincronizado': 0,
    });
  }

  // Obtener mercancía no sincronizada
  static Future<List<Map<String, dynamic>>> getMercanciaNoSincronizada() async {
    final db = await database;
    return await db.query(
      'mercancia_offline',
      where: 'sincronizado = ?',
      whereArgs: [0],
    );
  }

  // Marcar mercancía como sincronizada
  static Future<void> marcarComoSincronizado(int id) async {
    final db = await database;
    await db.update(
      'mercancia_offline',
      {'sincronizado': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Cache de productos
  static Future<void> guardarProductosEnCache(List<Producto> productos) async {
    final db = await database;
    await db.delete('productos_cache'); // Limpiar cache anterior
    
    for (Producto producto in productos) {
      await db.insert('productos_cache', {
        'id': producto.id,
        'data': jsonEncode(producto.toJson()),
        'fecha_cache': DateTime.now().toIso8601String(),
      });
    }
  }

  static Future<List<Producto>> getProductosDesdeCache() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('productos_cache');
    
    return maps.map((map) {
      final data = jsonDecode(map['data'] as String);
      return Producto.fromJson(data);
    }).toList();
  }
}