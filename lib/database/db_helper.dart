import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {

  final int dbVersion = 2;
  DBHelper._internal();
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;

  static Database? _database;

  Future<Database> get database async{
    if(_database != null) return _database!;
    _database = await _initDB("tng_articles_app.db");
    return _database!;
  }

  Future<Database?> _initDB(String dbFileName) async {
    final path = join(await getDatabasesPath(), dbFileName);
    return await openDatabase(
        path,
        version: dbVersion,
        onCreate: _onCreate,
      onUpgrade: _onUpgrade
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if(oldVersion < dbVersion){
      await db.execute('ALTER TABLE articles ADD COLUMN author TEXT');
      await db.execute('ALTER TABLE save_articles ADD COLUMN author TEXT');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE articles (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    author TEXT,
    description TEXT,
    url TEXT UNIQUE,
    urlToImage TEXT,
    publishedAt TEXT,
    content TEXT,
    source TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE save_articles (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    author TEXT,
    description TEXT,
    url TEXT UNIQUE,
    urlToImage TEXT,
    publishedAt TEXT,
    content TEXT,
    source TEXT
    )
    ''');
  }


}