import 'package:demo_app/model/blogs_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  factory DatabaseHelper() {
    return instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'blogs_database.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE blogs(
          id INTEGER PRIMARY KEY,
          title TEXT,
          body TEXT,
          imageUrl TEXT
        )
      ''');
    });
  }

  Future<int> insertBlogs(BlogsModel blogs) async {
    final db = await database;
    return await db.insert('blogs', blogs.toMap());
  }

  Future<void> deleteBlogs(int id) async {
    final db = await database;
    try {
      await db.delete(
        'blogs',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Failed to delete blogs: $e');
    }
  }

  Future<int> updateBlogs(blogs) async {
    final db = await database;
    try {
      return await db.update(
        'blogs',
        blogs.toMap(),
        where: 'id = ?',
        whereArgs: [blogs.id],
      );
    } catch (e) {
      throw Exception('Failed to update blogs: $e');
    }
  }

  Future<List<BlogsModel>> getblogs() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query('blogs');
      List<BlogsModel> blogs = List.generate(maps.length, (index) => BlogsModel.fromMap(maps[index]));
      return blogs.reversed.toList();
    } catch (e) {
      throw Exception('Failed to fetch blogs: $e');
    }
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
