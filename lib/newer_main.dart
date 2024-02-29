import 'package:ais_hackathon/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase setup',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const TestDBHelped(title: "Testing Database Helper"),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong!'),
              );
            } else if (snapshot.hasData) {
              return const HomePage();
            } else {
              return const MicrosoftLoginWidget();
              // return const LoginWidget();
            }
          }),
    );
  }
}

class MicrosoftLoginWidget extends StatefulWidget {
  const MicrosoftLoginWidget({super.key});

  @override
  State<MicrosoftLoginWidget> createState() => _MicrosoftLoginWidgetState();
}

class _MicrosoftLoginWidgetState extends State<MicrosoftLoginWidget> {
  _loginWithMicrosoft() async {
    try {
      final provider = OAuthProvider("microsoft.com");
      provider.setCustomParameters({
        "tenant": "common",
      });

      debugPrint("Trying to pop-up microsoft login");
      var cred = await FirebaseAuth.instance.signInWithPopup(provider);
      debugPrint(cred.user?.displayName);
      debugPrint(cred.user?.email);
    } on FirebaseAuthException catch (e) {
      debugPrint("${e.code} - ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => _loginWithMicrosoft(),
        // onPressed: () {},
        child: const Text('Log in with Microsoft'),
      ),
    );
  }
}
