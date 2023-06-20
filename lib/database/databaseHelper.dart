//https://suragch.medium.com/simple-sqflite-database-example-in-flutter-e56a5aaa3f91
import 'package:catch_me_if_you_can/database/entities/userScore.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "catchMeIfYouCanDatabase.db";
  static const _databaseVersion = 1;

  static const table = 'userScore';

  static const columnId = '_id';
  static const columnName = 'name';
  static const columnScore = 'score';

  late Database _db;

  // this opens the database (and creates it if it doesn't exist)
  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT,
            $columnScore INTEGER NOT NULL
          )
          ''');
  }

  // Helper methods

  Future<int> insert(String table, Map<String, dynamic> row) async {
    return await _db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    return await _db.query(table);
  }

  Future<int> queryRowCount() async {
    final results = await _db.rawQuery('SELECT COUNT(*) FROM $table');
    return Sqflite.firstIntValue(results) ?? 0;
  }

  // List top five score
  Future<List<UserScore>> queryTop5Scores(String table) async {
    var query = await _db.query(table, orderBy: "score DESC", limit: 5);
    List<UserScore> userScores = [];
    query.forEach((element) => userScores.add(UserScore.fromMap(element)));
    return userScores;
  }


  Future<int> update(Map<String, dynamic> row) async {
    int id = row[columnId];
    return await _db.update(
      table,
      row,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    return await _db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

}
