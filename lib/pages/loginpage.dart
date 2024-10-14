import 'package:flutter/material.dart';
import 'package:cypherlock_new/services/fire_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cypherlock_new/pages/open.dart';

class LoginPage extends StatefulWidget {
  final FirebaseAuthService authService; // Inject FirebaseAuthService

  LoginPage({required this.authService});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String errorMessage = '';

  Future<void> _signInWithEmailAndPassword() async {
    try {
      User? user = await widget.authService.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (user == null) {
        setState(() {
          errorMessage = 'Login failed';
        });
      } else {
        // Save login state
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        // Navigate to OpenPage and replace the current page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OpenPage()),
        );
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Login failed';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset('lib/assets/CypherLock_Club-removebg.png',
              width: 200,
              height: 200,
              fit: BoxFit.contain),
            Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signInWithEmailAndPassword,
              child: Text('Login'),
            ),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
