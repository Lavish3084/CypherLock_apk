import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cypherlock_new/pages/open.dart';
import 'package:cypherlock_new/pages/home.dart';
import 'package:cypherlock_new/services/fire_auth_services.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
    //  theme:ThemeData(
          //colorSchemeSeed: const Color(0xff6750a4), useMaterial3: true),
      initialRoute: '/',
      routes: {
        
        '/': (context) => OpenPage(),
        '/home': (context) => Home(),
      /*  '/LoginScreen':(context) => LoginPage(),
        'Signupscreen': (context)=> SignUpPage()*/
      },
    );
  }
}
