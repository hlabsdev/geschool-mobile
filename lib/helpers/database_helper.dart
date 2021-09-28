/* import 'dart:async';

import 'package:geschool/helpers/helpers_utils.dart';
import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;
  static Database _db;

  static Future<Database> get database async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  static initDb() async {
    //io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String documentsDirectory = await getDatabasesPath();
    String path = join(documentsDirectory, "geschool.db");
    var theDb = await openDatabase(path,
        version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return theDb;
  }

  static void _onCreate(Database db, int version) async {
    try {
      String sqlPublicite =
          'CREATE TABLE $TABLE_NAME_PUBLICITE($idPublicite INTEGER PRIMARY KEY AUTOINCREMENT,$etatPublicite INTEGER, '
          '$keyPublicite TEXT,$titrePublicite TEXT,$descriptionPublicite TEXT,$photoPublicite TEXT,$datePublicite TEXT,$timePublicite INTEGER)';

      String index1 =
          'CREATE UNIQUE INDEX idx_$TABLE_NAME_PUBLICITE ON $TABLE_NAME_PUBLICITE ($keyPublicite)';

      //creation des tables
      await db.execute(sqlPublicite);

      //creation des index
      await db.execute(index1);
    } catch (error) {
      print('error during database creation $error');
    }
  }

  static void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    try {} catch (error) {}
  }
}
 */