import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'avatar.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE avatar_index(id INTEGER UNIQUE NOT NULL, ind INTEGER NOT NULL)');
      },
      version: 1,
    );
  }

  static insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(
    String table,
  ) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static update(
    String table,
    Map<String, Object> data,
    String where,
    int id,
  ) async {
    final db = await DBHelper.database();
    await db.update(
      table,
      data,
      where: where,
      whereArgs: [id],
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static delete(
    String table,
    String where,
    int id,
  ) async {
    final db = await DBHelper.database();
    await db.delete(table,where: where,whereArgs: [id]);
  }
}
