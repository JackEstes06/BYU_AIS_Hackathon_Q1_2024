import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import '../models/db_user_model.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "punchcard_database.db";
  static const String userTable = 'User';
  static const String userEventTable = 'UserEvent';
  static const String eventTable = 'Event';
  static const String eventDescriptionTable = 'EventDescription';
  static const String eventTypeTable = 'EventType';

  static Future<Database> _getDB() async {
    // Initialize FFI differently if using a web app
    if (kIsWeb) {
      databaseFactoryOrNull = null;
      databaseFactory = databaseFactoryFfiWeb;
    }

    return openDatabase(
      join(await getDatabasesPath(), '../assets/db/$_dbName'),
      onCreate: (db, version) async {
        // Run the CREATE TABLE statement on the database.
        return await db.execute(
          'CREATE TABLE $userTable(userID INTEGER PRIMARY KEY, username TEXT, password TEXT, fName TEXT, lName TEXT, email TEXT, isAdmin BOOLEAN)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: _version,
    );
  }

  // Function that inserts User objects into the database
  static Future<int> insertUser(User user) async {
    // Get reference to database
    final db = await _getDB();

    // Insert User into the correct table.
    // ConflictAlgorithm is utilized in case the same dog is
    // inserted multiple times.
    //
    // In this case, replace previous user.
    return await db.insert(
      userTable,
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Function that updates a User object from the user table
  static Future<int> updateUser(User user) async {
    // Get reference to database
    final db = await _getDB();

    // Update the giver User
    return await db.update(
      userTable,
      user.toJson(),
      // Ensure the the User has a matching id in the table
      where: 'userID = ?',
      // Pass the User's userID as a whereArg to prevent SQL injection
      whereArgs: [user.userID],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Function that deletes a User object from the user table
  static Future<int> deleteUser(int userID) async {
    // Get reference to the database
    final db = await _getDB();

    // Remove the User from the database
    return await db.delete(
      userTable,
      // Use a 'where' clause to delete a specific user
      where: 'userID = ?',
      // Pass the User's userID as a whereArg to prevent SQL injection
      whereArgs: [userID],
    );
  }

  // Function that retrieves all User objects from the user table
  static Future<List<User>?> users() async {
    // Get reference to database
    final db = await _getDB();

    // Query the table for all users
    final List<Map<String, dynamic>> userMaps = await db.query(userTable);

    if (userMaps.isEmpty) return null;
    return List.generate(
      userMaps.length,
      (index) => User.fromJson(userMaps[index]),
    );
  }
}
