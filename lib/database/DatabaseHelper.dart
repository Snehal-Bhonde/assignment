import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static late Database _db;
  final String tableUser = "User";
  final String columnName = "name";
  final String columnUserName = "username";
  final String columnPassword = "password";

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "main.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE User(id INTEGER PRIMARY KEY, name TEXT, username TEXT, password TEXT, flaglogged TEXT)");
    print("Table is created");
  }

  //insertion
  Future<int> saveUser(User user) async {
    var dbClient = await db;
    print(user.name);
    int res = await dbClient.insert("User", user.toMap());
    List<Map> list = await dbClient.rawQuery('SELECT * FROM User');
    print(list);
    return res;
  }

  //deletion
  Future<int> deleteUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.delete("User");
    return res;
  }
  Future<User?> selectUser(User user) async{
    print("Select User");
    print(user.username);
    print(user.password);
    var dbClient = await db;
    List<Map> maps = await dbClient.query(tableUser,
        columns: [columnUserName, columnPassword],
        where: "$columnUserName = ? and $columnPassword = ?",
        whereArgs: [user.username,user.password]);
    print(maps);
    if (maps.length > 0) {
      print("User Exist !!!");
      return user;
    }else {
      return null;
    }
  }

  Future<User?> getLogin(String user, String password) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery("SELECT * FROM user WHERE username = '$user' and password = '$password'");

    if (res.length > 0) {
      //return new User.fromMap(res.first);
    }

    return null;
  }
}

class User {
  late String _name;
  late String _username;
  late String _password;
  late String _flaglogged;



  User(this._name, this._username, this._password, this._flaglogged);

  User.map(dynamic obj) {
    this._name = obj['name'];
    this._username = obj['username'];
    this._password = obj['password'];
    this._flaglogged = obj['password'];
  }

  String get name => _name;
  String get username => _username;
  String get password => _password;
  String get flaglogged => _flaglogged;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = _name;
    map["username"] = _username;
    map["password"] = _password;
    map["flaglogged"] = _flaglogged;
    return map;
  }
}

class DatabaseRepository {
  Database?_database;
  static final DatabaseRepository instance = DatabaseRepository
      ._init(); // our class will always have one instane only to make sure the database is only one
  DatabaseRepository._init();


  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB("friend_formdb.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
create table ${AppConst.tableName} ( 
  ${AppConst.uid} integer primary key autoincrement, 
  ${AppConst.Name} text not null,
   ${AppConst.mobNo} integer not null,
   ${AppConst.email} text not null
''');
  }

  Future<void> insert({required FriendForm registerForm}) async {
    try {
      final db = await database;
      db.insert(AppConst.tableName, registerForm.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<FriendForm>> getAllFriends() async {
    final db = await instance.database;

    final result = await db.query(AppConst.tableName);

    return result.map((json) => FriendForm.fromJson(json)).toList();
  }

  Future<void> delete(int id) async {
    try {
      final db = await instance.database;
      await db.delete(
        AppConst.tableName,
        where: '${AppConst.uid} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> update(FriendForm registerForm) async {
    try {
      final db = await instance.database;
      db.update(
        AppConst.tableName,
        registerForm.toMap(),
        where: '${AppConst.uid} = ?',
        whereArgs: [registerForm.userId],
      );
    } catch (e) {
      print("update failed");
      print(e.toString());
    }
  }

}
class AppConst {
  static const String uid = 'userId';
  static const String Name = 'Name';
  static const String mobNo = 'mobNo';
  static const String email = 'email';
  static const String tableName = 'RegFormTable';
}


class FriendForm {
  int? userId;
  String? Name;
  int? mobNo;
  String? email;


  FriendForm({this.userId, this.Name,this.mobNo,this.email,});
  factory FriendForm.fromJson(Map<String, dynamic> data) => FriendForm(
    //This will be used to convert JSON objects that
    //are coming from querying the database and converting
    //it into a Todo object
    userId: data['userId'],
    Name: data['Name'],
    mobNo: data['mobNo'],
    email: data['email'],

  );
  Map<String, dynamic> toMap() => {
    //This will be used to convert Todo objects that
    //are to be stored into the datbase in a form of JSON
    "userId": this.userId,
    "Name": this.Name,
    "mobNo": this.mobNo,
    "email": this.email,
  };
}