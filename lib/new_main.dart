import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'home_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // FirebaseDatabase database = FirebaseDatabase.instance;

  runApp(const MicrosoftLoginWidget());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
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
                child: Text(
              'Something went wrong!',
            ));
          } else if (snapshot.hasData) {
            return const HomePage();
          } else {
            return MicrosoftLoginWidget();
            // return const LoginWidget();
          }
        },
      ),
    );
  }
}

class MicrosoftLoginWidget extends StatefulWidget {
  const MicrosoftLoginWidget({super.key});

  @override
  State<MicrosoftLoginWidget> createState() => _MicrosoftLoginWidgetState();
}

class _MicrosoftLoginWidgetState extends State<MicrosoftLoginWidget> {
  late final AadOAuth _microsoftSignIn;

  @override
  void initState() {
    super.initState();
    _microsoftSignIn = AadOAuth(Config(
      // If you dont have a special tenant id, use "common"
      tenant: "b0098fe3-326a-4c31-9f71-5282d460328d",
      clientId: "8860a5e0-8038-4444-aa57-122065d20189",
      // Replace this with your client id ("Application (client) ID" in the Azure Portal)
      responseType: "code",
      scope: "User.Read",
      redirectUri: 'https://byu-ais-hackathon.firebaseapp.com/__/auth/handler',
      // redirectUri: "msal{YOUR-CLIENT-ID-HERE}://auth",
      loader: const Center(child: CircularProgressIndicator()),
      navigatorKey: navigatorKey,
    ));
  }
  //
  // _loginWithMicrosoft() async {
  //   var result = await _microsoftSignIn.login();
  //
  //   result.fold(
  //     (Failure failure) {
  //       // Auth failed, show error
  //     },
  //     (Token token) async {
  //       if (token.accessToken == null) {
  //         // Handle missing access token, show error or whatever
  //         return;
  //       }
  //
  //       // Handle successful login
  //       debugPrint(
  //           'Logged in successfully, your access token: ${token.accessToken!}');
  //
  //       // Perform necessary actions with the access token, such as API calls or storing it securely.
  //
  //       await _microsoftSignIn.logout();
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        // onPressed: () => _loginWithMicrosoft(),
        onPressed: () {},
        child: const Text('Log in with Microsoft'),
      ),
    );
  }
}
