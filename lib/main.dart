import 'package:ais_hackathon/db_sqlite.dart';
import 'package:ais_hackathon/screens/users_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // FirebaseDatabase database = FirebaseDatabase.instance;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Local Database demo app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const TestDBHelped(title: "Testing Database Helper"),
      home: const UsersScreen(),
    );
  }
}

class TestDBHelped extends StatefulWidget {
  const TestDBHelped({super.key, required this.title});

  final String title;

  @override
  State<TestDBHelped> createState() => _TestDBHelpedState();
}

class _TestDBHelpedState extends State<TestDBHelped> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: const FloatingActionButton(
        onPressed: testDatabaseHelper,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
