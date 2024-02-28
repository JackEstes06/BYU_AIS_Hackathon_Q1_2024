// Package Imports
import 'dart:async';

import 'package:ais_hackathon/services/database_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'models/db_user_model.dart';

void testDatabase() async {
  String userTable = 'User';
  String userEventTable = 'UserEvent';
  String eventTable = 'Event';
  String eventDescriptionTable = 'EventDescription';
  String eventTypeTable = 'EventType';

  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize FFI differently if using a web app
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }
  // |---- NOT NEEDED ATM, MAY BE UTILIZED LATER ----|
  // else {
  //   sqfliteFfiInit();
  //   databaseFactory = databaseFactoryFfi;
  // }
  // |-----------------------------------------------|

  // Open the database and store the reference.
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), '../assets/db/punchcard_database.db'),
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE $userTable(userID INTEGER PRIMARY KEY, username TEXT, password TEXT, fName TEXT, lName TEXT, email TEXT, isAdmin BOOLEAN)',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );
  debugPrint('Path to DB: ${await getDatabasesPath()}');

  // |-------- Database functions --------|
  // Function that inserts User objects into the database
  Future<void> insertUser(User user) async {
    // Get reference to database
    final db = await database;

    // Insert User into the correct table.
    // ConflictAlgorithm is utilized in case the same dog is
    // inserted multiple times.
    //
    // In this case, replace previous user.
    await db.insert(
      userTable,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Function that retrieves all User objects from the user table
  Future<List<User>> users() async {
    // Get reference to database
    final db = await database;

    // Query the table for all users
    final List<Map<String, Object?>> userMaps = await db.query(userTable);

    // Convert the list of each user's fields into a list of 'User' objects.
    return [
      for (final {
            'userID': userID as int,
            'username': username as String,
            'password': password as String,
            'fName': fName as String,
            'lName': lName as String,
            'email': email as String,
            'isAdmin': isAdmin as int,
          } in userMaps)
        User(
            userID: userID,
            username: username,
            password: password,
            fName: fName,
            lName: lName,
            email: email,
            isAdmin: isAdmin)
    ];
  }

  // Function that updates a User object from the user table
  Future<void> updateUser(User user) async {
    // Get reference to database
    final db = await database;

    // Update the giver User
    await db.update(
      userTable,
      user.toMap(),
      // Ensure the the User has a matching id in the table
      where: 'userID = ?',
      // Pass the User's userID as a whereArg to prevent SQL injection
      whereArgs: [user.userID],
    );
  }

  // Function that deletes a User object from the user table
  Future<void> deleteUser(int userID) async {
    // Get reference to the database
    final db = await database;

    // Remove the User from the database
    await db.delete(
      userTable,
      // Use a 'where' clause to delete a specific user
      where: 'userID = ?',
      // Pass the User's userID as a whereArg to prevent SQL injection
      whereArgs: [userID],
    );
  }
  // |-------- End Database Functions --------|

  // Create a user and add it to user table
  var jack = User(
    userID: 0,
    username: 'estesj10',
    password: '1234',
    fName: 'Jack',
    lName: 'Etses',
    email: 'estesj10@byu.edu',
    // 0 -> false
    isAdmin: 0,
  );
  await insertUser(jack);
  for (int i = 1; i < 5; i++) {
    await (insertUser(User(
        userID: i,
        username: 'estesj1$i',
        password: '${i}234',
        fName: 'Jack',
        lName: 'Estes',
        email: 'estesj10@byu.edu',
        isAdmin: 0)));
  }

  // Retrieve and print all users
  debugPrint('Users:\n${await users()}\n');

  // Updates jack's lastname and saves it to the database
  jack = User(
    userID: 0,
    username: 'estesj10',
    password: '1234',
    fName: 'Jack',
    lName: 'Estes',
    email: 'estesj10@byu.edu',
    isAdmin: 0,
  );
  await updateUser(jack);
  // Retrieve and print the updated results
  debugPrint(
    'Post Update:\n${await users()}\n',
  ); // Prints jack w/ lastname Estes instead of Etses

  // Delete jack from the database
  await deleteUser(jack.userID);
  // Retrieve and print the updated results
  debugPrint('Post Deletion:\n${await users()}\n');
}

void testDatabaseHelper() async {
  // Create a user and add it to user table
  var jack = User(
    userID: 0,
    username: 'estesj10',
    password: '1234',
    fName: 'Jack',
    lName: 'Etses',
    email: 'estesj10@byu.edu',
    // 0 -> false
    isAdmin: 0,
  );
  await DatabaseHelper.insertUser(jack);
  for (int i = 1; i < 5; i++) {
    await (DatabaseHelper.insertUser(User(
        userID: i,
        username: 'estesj1$i',
        password: '${i}234',
        fName: 'Jack',
        lName: 'Estes',
        email: 'estesj10@byu.edu',
        isAdmin: 0)));
  }

  // Retrieve and print all users
  debugPrint('Users:\n${await DatabaseHelper.users()}\n');

  // Updates jack's lastname and saves it to the database
  jack = User(
    userID: 0,
    username: 'estesj10',
    password: '1234',
    fName: 'Jack',
    lName: 'Estes',
    email: 'estesj10@byu.edu',
    isAdmin: 0,
  );
  await DatabaseHelper.updateUser(jack);
  // Retrieve and print the updated results
  debugPrint(
    'Post Update:\n${await DatabaseHelper.users()}\n',
  ); // Prints jack w/ lastname Estes instead of Etses

  // Delete jack from the database
  await DatabaseHelper.deleteUser(jack.userID);
  // Retrieve and print the updated results
  debugPrint('Post Deletion:\n${await DatabaseHelper.users()}\n');
}
