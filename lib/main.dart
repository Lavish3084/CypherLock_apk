import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cypherlock_new/pages/open.dart';
import 'package:cypherlock_new/pages/home.dart';
import 'package:cypherlock_new/pages/loginpage.dart';
import 'package:cypherlock_new/services/fire_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cypherlock_new/pages/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuthService authService = FirebaseAuthService(FirebaseAuth.instance); // Create an instance of FirebaseAuthService

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/splash',
      routes: {
        '/splash': (context)=> SplashScreen(),
        '/': (context) => OpenPage(),
        '/home': (context) => Home(),
        '/login': (context) => LoginPage(authService: authService), // Inject authService into LoginPage
      },
    );
  }
}
class AuthCheck extends StatelessWidget {
  final FirebaseAuthService authService = FirebaseAuthService(FirebaseAuth.instance);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authService.authStateChanges(), // Now we are using the exposed method
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return Home(); // User is authenticated
        } 
        else{
          return OpenPage();
        }
      },
    );
  }
}
