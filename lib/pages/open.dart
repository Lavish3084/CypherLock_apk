import 'package:flutter/material.dart';
import 'home.dart';
class OpenPage extends StatefulWidget {
  const OpenPage({super.key});

  @override
  State<OpenPage> createState() => _OpenPageState();
}

class _OpenPageState extends State<OpenPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children:<Widget>[ 
        
        Image.asset('lib/assets/bg.jpg',
         fit: BoxFit.contain),
        Scaffold(
        backgroundColor: Colors.transparent,
        
        body: Center( 
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget> [
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: ClipOval(
                     
                      
                      child: Image.asset('lib/assets/logo.png',
                      
                      ),
                    ),
                  ),
                  Container(
                    padding:EdgeInsets.all(10),
                    
                    child: Text(
                      'CypherLock Club',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
                icon: Icon(Icons.search, color: Colors.black),
                label: Text(
                  'Search',
                  style: TextStyle(color: Colors.black),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 252, 211, 211), // Add background color
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              SizedBox(height: 100,),
            ],
          ),
        ),
      ),
      ],
    );
  }
}