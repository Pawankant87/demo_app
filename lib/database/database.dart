import 'package:demo_app/model/customer_model.dart';
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
    String path = join(await getDatabasesPath(), 'customer_database.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE customers(
          id INTEGER PRIMARY KEY,
          name TEXT,
          mobile TEXT,
          email TEXT,
          address TEXT,
          imageUrl TEXT
        )
      ''');
    });
  }

  Future<int> insertCustomer(Customer customer) async {
    final db = await database;
    return await db.insert('customers', customer.toMap());
  }

  Future<void> deleteCustomer(int id) async {
    final db = await database;
    try {
      await db.delete(
        'customers',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Failed to delete customer: $e');
    }
  }

  Future<int> updateCustomer(Customer customer) async {
    final db = await database;
    try {
      return await db.update(
        'customers',
        customer.toMap(),
        where: 'id = ?',
        whereArgs: [customer.id],
      );
    } catch (e) {
      throw Exception('Failed to update customer: $e');
    }
  }

  Future<List<Customer>> getCustomers() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query('customers');
      return List.generate(maps.length, (index) => Customer.fromMap(maps[index]));
    } catch (e) {
      throw Exception('Failed to fetch customers: $e');
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
