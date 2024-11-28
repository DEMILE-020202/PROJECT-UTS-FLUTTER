import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:assigner/models/user_model.dart';

class DbConn {
  static final DbConn instance = DbConn._instance();
  static Database? _db;

  DbConn._instance();

  String userTable = 'user_table';
  String dataId = 'id';
  String dataUsername = 'username';
  String dataEmail = 'email';
  String dataPassword = 'password';
  String dataProfession = 'profession';

  Future<Database?> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    String dir = await getDatabasesPath();
    String path = join(dir, 'user_table.db');
    final userDb = await openDatabase(path, version: 1, onCreate: _createDb);
    return userDb;
  }

    void _createDb(Database db, int version) async {
      await db.execute(
        'CREATE TABLE user_table(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT NOT NULL UNIQUE, email TEXT NOT NULL UNIQUE, password TEXT NOT NULL, profession TEXT NOT NULL)',
      );
    }

    Future<int> insertUser(User user) async {
      Database? db = await this.db;
      final int result = await db!.insert(userTable, user.toMap());
      return result;
    }

    Future<Map<String, dynamic>?> getUser(String email, String password) async {
      Database? db = await this.db;
      final List<Map<String, dynamic>> result = await db!.query(
        userTable,
        where: '$dataEmail = ? AND $dataPassword = ?',
        whereArgs: [email, password],
      );
      if (result.isNotEmpty) {
        return result.first;
      }
      return null;
    }

    Future<Map<String, dynamic>?> getUserID(int id) async {
      Database? db = await this.db;
      final List<Map<String, dynamic>> result = await db!.query(
        userTable,
        where: '$dataId = ?',
        whereArgs: [id],
      );
      if (result.isNotEmpty) {
        return result.first;
      }
      return null;
    }
  }
