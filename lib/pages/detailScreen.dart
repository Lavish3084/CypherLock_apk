import 'package:flutter/material.dart';

class MemberDetailsScreen extends StatelessWidget {
  final String name;
  final String uid;
  final String memberId;  // Add Member ID

  const MemberDetailsScreen({
    super.key,
    required this.name,
    required this.uid,
    required this.memberId,  // Receive Member ID
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25
        ),
        ),
        backgroundColor: const Color.fromARGB(255,211, 211, 211),
        toolbarHeight: 150.0, 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           /* Text(
              'Name: $name',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),*/
            SizedBox(height: 14),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'UID: ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
                 Text(
              ' $uid',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
              ],
            ),
           
            SizedBox(height: 14),
            Text(
              'Member ID: ', // Display Member ID here
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            ),
            Text(
              '$memberId ', // Display Member ID here
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
