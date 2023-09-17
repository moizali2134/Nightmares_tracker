import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:terrortracker/db/Childs.dart';
import 'package:terrortracker/db/report_model.dart';
import 'package:terrortracker/db/user.dart';

class DatabaseHelper {

  static final _databaseName = "terrordb.db";
  static final _databaseVersion = 1;

  static final table = 'daily_terrortable';
  static final usertable = 'Usertable';
  static final iosusertable = 'usertable';
  static final childtable = 'childtable';

  static final columnId = 'id';
  static final columnName = 'name';
  static final columnuName = 'username';
  static final columnpass = 'pass';
  static final columnemail = 'email';
  static final columnstime = 'time';
  static final columnchild = 'child_name';
  static final columnchd_color = 'child_color';
  static final columnparent_id = 'parent_id';


  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {

    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();

    String path = join(await databasesPath, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {

    await db.execute('''
          CREATE TABLE $iosusertable (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName TEXT NOT NULL,
            $columnpass  TEXT NOT NULL,
            $columnemail  TEXT NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName TEXT NOT NULL,
            $columnstime  TEXT NOT NULL,
            $columnchild  TEXT NOT NULL,
            $columnchd_color TEXT NOT NULL,
            $columnparent_id  INTEGER NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE $childtable (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName TEXT NOT NULL,
            $columnchd_color  TEXT NOT NULL,
            $columnparent_id  INTEGER NOT NULL
          )
          ''');
   // await db.insert(childtable, {'name': "All", 'child_color': "Color(0xff00b0ff)" });
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
//  insertion
  Future<int> saveUser(String usr,String pss,String eml) async {
    print(usr);
    print(pss);
    print(eml);
    var dbClient = await instance.database;
    return await dbClient.insert(iosusertable, {'name': usr, 'pass': pss, 'email': eml,});


  }
  //deletion
  Future<int> deleteUser(user user) async {
    var dbClient = await instance.database;
    int res = await dbClient.delete(iosusertable);
    return res;
  }
  Future<user?> getLogin(String usr, String password) async {
    var dbClient = await instance.database;
    var res = await dbClient.rawQuery("SELECT * FROM $iosusertable WHERE email = '$usr' and pass = '$password'");

    if (res.isNotEmpty) {
      return  user.fromMap(res.first);
    }
    else{
      return null;
    }

  }
  Future<int> insert(DailyReport dailyReport) async {
    Database db = await instance.database;
    return await db.insert(table, {'name': dailyReport.name, 'time': dailyReport.start_time, 'child_name': dailyReport.child_name,'child_color':dailyReport.child_color,'parent_id':dailyReport.parent_id});
  }
  Future<int> insertchild(Child c) async {
    Database db = await instance.database;
    return await db.insert(childtable, {'name': c.name, 'child_color': c.colr,'parent_id':c.parent_id});
  }
  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows(int i) async {
    Database db = await instance.database;
     return await db.query(table, where: "$columnparent_id LIKE '%$i%'");
  }
  Future<List<Map<String, dynamic>>> querychildAllRows(int i) async {
    Database db = await instance.database;
    return await db.rawQuery(
        'SELECT * FROM $childtable WHERE parent_id=$i '
    );
      await db.query(childtable, where: "$columnparent_id LIKE '%$i%'");
  }

  // Queries rows based on the argument received
  Future<List<Map<String, dynamic>>> queryRows(name,int i) async {
    Database db = await instance.database;
    return  await db.rawQuery(
        'SELECT * FROM $table WHERE child_name=? and parent_id=?',
        ['$name', i]
    );
    // return await db.query(table, where: "$columnchild LIKE '%$name%'&&'%$i%'");
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int?> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> updateuser(user usr) async {
    Database db = await instance.database;
    int id = usr.toMap()['id'];
    return await db.update(iosusertable, usr.toMap(), where: '$columnId = ?', whereArgs: [id]);
  }
  Future<int> update(DailyReport dailyReport) async {
    Database db = await instance.database;
    int id = dailyReport.toMap()['id'];
    return await db.update(table, dailyReport.toMap(), where: '$columnId = ?', whereArgs: [id]);
  }
  Future<int> updateChild(Child ch) async {
    Database db = await instance.database;
    int id = ch.toMap()['id'];
    return await db.update(childtable, ch.toMap(), where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
  Future<int> deletechild(int id) async {
    Database db = await instance.database;
    return await db.delete(childtable, where: '$columnId = ?', whereArgs: [id]);
  }
}