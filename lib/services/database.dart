import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:expotenderos_app/models/User.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if(_db != null)
      return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path, version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return theDb;
  }
  

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute("CREATE TABLE User(id INTEGER  PRIMARY KEY NOT NULL, username TEXT NOT NULL, password TEXT NOT NULL, loggedIn INT, token TEXT)");
    await db.execute("CREATE TABLE Shopkeepers(id INTEGER PRIMARY KEY NOT NULL, id_server INT, type INT NOT NULL, name TEXT NOT NULL, email TEXT NOT NULL, phone TEXT NOT NULL, gender INT, age INT, alpura INT DEFAULT 0 NOT NULL, fridge_doors INT DEFAULT 0 NOT NULL, shop_name TEXT NOT NULL, shop_address TEXT NOT NULL, shop_postal_code INT NOT NULL, shop_picture TEXT NOT NULL, shop_location TEXT NOT NULL, code TEXT NOT NULL, privacy INT NOT NULL, synced INT DEFAULT 0 NOT NULL, combo INT, referred_name TEXT, referred_code INT)");
    await db.execute("CREATE TABLE Activity(id INTEGER PRIMARY KEY NOT NULL, capacity_site INT NOT NULL, activity TEXT NOT NULL, speaker TEXT, description TEXT, type INT NOT NULL, subtype INT, status INT, hour_ini TEXT, hour_fin TEXT, id_combo INT)");
    await db.execute("CREATE TABLE Combos(id INTEGER PRIMARY KEY NOT NULL, name TEXT, hour TEXT)");
    print("Created tables");
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    print("Upgrading DB");
    print("Old version: $oldVersion. New version: $newVersion");
    if (oldVersion < newVersion) {
      if (oldVersion == 1 && newVersion >= 2) {
        db.execute("ALTER TABLE Shopkeepers ADD COLUMN alpura INT DEFAULT 0 NOT NULL");
        db.execute("ALTER TABLE Shopkeepers ADD COLUMN fridge_doors INT DEFAULT 0 NOT NULL");
      }
    }
    print("Upgraded DB");
  }

  Future<int> saveUser(User user) async {
    var dbClient = await db;
    user.loggedIn = true;
    int res = await dbClient.insert("User", user.toMap());
    return res;
  }

  Future<int> deleteUsers() async {
    var dbClient = await db;
    int res = await dbClient.delete("User");
    return res;
  }

  Future<bool> isLoggedIn() async {
    var dbClient = await db;
    var res = await dbClient.query("User");
    return res.length > 0? true: false;
  }

  void delete() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getApplicationDocumentsDirectory();
    String path = join(databasesPath.path, 'main.db');

    await ((await openDatabase(path)).close());
    await deleteDatabase(path); 

    print("Database deleted");
  }

}