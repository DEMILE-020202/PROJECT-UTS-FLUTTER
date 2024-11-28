import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:assigner/models/user_model.dart';
import 'package:assigner/models/assignments_model.dart';
import 'package:assigner/models/students_assignment_model.dart';

class DbConn {
  static final DbConn instance = DbConn._instance();
  static Database? _db;

  DbConn._instance();

  String userTable = 'user_table';
  String assignmentTable = 'assignment_table';
  String studentsAssTable = 'students_assignment_table';

  Future<Database?> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    String dir = await getDatabasesPath();
    String path = join(dir, 'database.db');
    final assignmentDb = await openDatabase(path, version: 1, onCreate: _createDb);
    return assignmentDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
      '''CREATE TABLE user_table(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL UNIQUE,
      email TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL,
      profession TEXT NOT NULL
      )
      '''
    );
    await db.execute(
      '''CREATE TABLE assignment_table(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      creator TEXT NOT NULL,
      description TEXT,
      dueDate TEXT NOT NULL,
      file TEXT
      )
      '''
    );
    await db.execute(
      '''CREATE TABLE students_assignment_table(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      studentId INTEGER,
      assignmentId INTEGER,
      studentFile TEXT,
      turnedInBool INTEGER DEFAULT 0,
      grade INTEGER,
      comment TEXT,
      FOREIGN KEY(studentId) REFERENCES user_table(id),
      FOREIGN KEY(assignmentId) REFERENCES assignment_table(id),
      UNIQUE(studentId, assignmentId)
      )
      '''
    );
    await db.execute(
      '''CREATE TRIGGER enforce_student_profession
      BEFORE INSERT ON students_assignment_table
      FOR EACH ROW
      WHEN (SELECT profession FROM user_table WHERE id = NEW.studentId) != 'Student'
      BEGIN
       SELECT RAISE(ABORT, 'studentId must belong to a student');
      END;
      '''
    );
  }

  //Methods for user_table
  Future<int> insertUser(User user) async {
    Database? db = await this.db;
    final int result = await db!.insert(userTable, user.toMap());
    return result;
  }

  Future<Map<String, dynamic>?> getUser(String email, String password) async {
    Database? db = await this.db;
    final List<Map<String, dynamic>> result = await db!.query(
      userTable,
      where: 'email = ? AND password = ?',
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
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<void> importUserData(List<User> user) async {
    final dbConn = DbConn.instance;

    for (User user in user) {
      await dbConn.insertUser(user);
    }
  }


  //Methods for assignment_table
  Future<void> insertAssignment(Assignments assignment) async {
    Database? db = await this.db;
    await db!.insert(
      assignmentTable,
      assignment.toMap(),
    );
  }

  Future<void> updateAssignment(Assignments assignment) async {
    Database? db = await this.db;
    await db!.update(
      assignmentTable,
      assignment.toMap(),
      where: 'id = ?',
      whereArgs: [assignment.id],
    );
  }

  Future<List<Assignments>> getAssignments() async {
    Database? db = await this.db;
    final List<Map<String, dynamic>> maps = await db!.query(
        assignmentTable
    );
    return List.generate(maps.length, (i) {
      return Assignments.fromMap(maps[i]);
    });
  }

  Future<int> deleteAssignment(int assignmentId) async {
    Database? db = await this.db;
    await deleteStudentAssignmentsByAssignmentId(assignmentId);
    return await db!.delete(
      assignmentTable,
      where: 'id = ?',
      whereArgs: [assignmentId],
    );
  }


  //Methods for students_assignment_table
  Future<void> insertStudentAssignment(StudentsAssignment stuAss) async {
    Database? db = await this.db;
    await db!.insert(
        studentsAssTable,
        stuAss.toMap(),
    conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<StudentsAssignment?> getStudentAssignmentById(int id) async {
    Database? db = await this.db;
    List<Map<String, dynamic>> maps = await db!.query(
      studentsAssTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return StudentsAssignment.fromMap(maps.first);
    }
    return null;
  }

  Future<List<StudentsAssignment>> getAssignmentsForStudent(int studentId) async {
    Database? db = await this.db;
    List<Map<String, dynamic>> maps = await db!.query(
      studentsAssTable,
      where: 'studentId = ?',
      whereArgs: [studentId],
    );
    return List.generate(maps.length, (i) {
      return StudentsAssignment.fromMap(maps[i]);
    });
  }

  Future<List<StudentsAssignment>> getStudentsForAssignment(int assignmentId) async {
    Database? db = await this.db;
    List<Map<String, dynamic>> maps = await db!.query(
      studentsAssTable,
      where: 'assignmentId = ?',
      whereArgs: [assignmentId],
    );
    return List.generate(maps.length, (i) {
      return StudentsAssignment.fromMap(maps[i]);
    });
  }

  Future<StudentsAssignment?> getStudentAssignmentByAssAndStu(int assignmentId, int studentId) async {
    Database? db = await this.db;
    List<Map<String, dynamic>> maps = await db!.query(
      studentsAssTable,
      where: 'assignmentId = ? AND studentId = ?',
      whereArgs: [assignmentId, studentId],
    );
    if (maps.isNotEmpty) {
      return StudentsAssignment.fromMap(maps.first);
    }
    return null;
  }

  Future<void> updateStudentAssignment(StudentsAssignment stuAss) async {
    Database? db = await this.db;
    await db!.update(
      studentsAssTable,
      stuAss.toMap(),
      where: 'id = ? AND assignmentId = ?',
      whereArgs: [stuAss.id, stuAss.assignmentId],
    );
  }

  Future<int> deleteStudentAssignment(int id) async {
    Database? db = await this.db;
    return await db!.delete(
      studentsAssTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteStudentAssignmentsByAssignmentId(int assignmentId) async {
    Database? db = await this.db;
    return await db!.delete(
      studentsAssTable,
      where: 'assignmentId = ?',
      whereArgs: [assignmentId],
    );
  }

}