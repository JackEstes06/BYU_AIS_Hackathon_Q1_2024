import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String errorMessage = "";

  // // Configure Microsoft Authentication
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final Config config = Config(
  //   tenant: 'b0098fe3-326a-4c31-9f71-5282d460328d',
  //   clientId: '8860a5e0-8038-4444-aa57-122065d20189',
  //   scope: 'openid profile email',
  //   redirectUri: 'https://byu-ais-hackathon.firebaseapp.com/__/auth/handler',
  //   navigatorKey: navigatorKey,
  // );
  //
  // Future<void> azureSignInApi(bool redirect) async {
  //   final AadOAuth oauth = AadOAuth(config);
  //
  //   config.webUseRedirect = redirect;
  //   final result = await oauth.login();
  //
  //   result.fold(
  //     (l) => errorMessage = "Microsoft Auth Failed!",
  //     (r) async {
  //       http.Response response;
  //       response = await http.get(
  //         Uri.parse("https://graph.microsoft.com/v1.0/me"),
  //         headers: {"Authorization": "Bearer ${r.accessToken}"},
  //       );
  //       final result = json.decode(response.body);
  //     },
  //   );
  // }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          TextField(
            controller: emailController,
            cursorColor: Colors.black,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: "Email"),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: passwordController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: "Password"),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          if (errorMessage != "")
            Column(
              children: [
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              icon: const Icon(Icons.lock_open),
              label: const Text(
                "Sign In",
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () async {
                errorMessage = await signIn(context);
                setState(() {});
              }),
        ],
      ),
    );
  }

  Future<String> signIn(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      debugPrint("Firebase Error: $e");
      if (context.mounted) Navigator.of(context).pop();
      return e.toString();
    } on Exception catch (e) {
      debugPrint("Error: $e");
      if (context.mounted) Navigator.of(context).pop();
      return e.toString();
    }

    // Use when Navigator.of(context) not working
    // navigatorKey.currentState!.popUntil((route) => route)
    if (context.mounted) Navigator.of(context).pop();
    return "";
  }
}
