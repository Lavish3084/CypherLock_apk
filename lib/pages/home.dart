import 'package:flutter/material.dart';
import 'detailScreen.dart';
import 'package:cypherlock_new/services/googleSheets.dart';
import 'package:cypherlock_new/pages/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cypherlock_new/services/fire_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  List<List<dynamic>> _members = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchMembers();
  }

  Future<void> _fetchMembers() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final api = GoogleSheetsApi();
      await api.init();
      // Fetch columns A:D to include Member ID in column D
      final data = await api.getSpreadsheetData('1xRq1xRk26U5xnKyy-Ozkk21mftXdT7dVi_luyJwfhaM', 'CypherLock Club!A:D');

      if (data.isNotEmpty) {
        setState(() {
          _members = data;
          _isLoading = false;
        });
      } else {
        throw 'No data found in the sheet';
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
      print('Error fetching data: $e');
    }
  }

  // Function to add a member
  Future<void> _addMember(String name, String uid, String memberId) async {
    final api = GoogleSheetsApi();
    await api.init();
    List<dynamic> newMember = [name, uid, memberId];
    await api.addMember('1xRq1xRk26U5xnKyy-Ozkk21mftXdT7dVi_luyJwfhaM', newMember);
    await _fetchMembers(); // Refresh the member list after adding
  }

  // Function to delete a member
  Future<void> _deleteMember(int rowIndex) async {
    final api = GoogleSheetsApi();
    await api.init();
    await api.deleteMember('1xRq1xRk26U5xnKyy-Ozkk21mftXdT7dVi_luyJwfhaM', rowIndex);
    await _fetchMembers(); // Refresh the member list after deleting
  }

  // Logout function to clear login state
 Future<void> _logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('isLoggedIn'); // Clear the login state

  // Create an instance of FirebaseAuth
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance; // Initialize here

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => LoginPage(authService: FirebaseAuthService(firebaseAuth)), // Pass the required authService argument
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'CypherLock Club',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 232, 69, 69),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              // Show a confirmation dialog before logout
              bool? shouldLogout = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Logout'),
                  content: Text('Are you sure you want to log out?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('Logout'),
                    ),
                  ],
                ),
              );

              if (shouldLogout == true) {
                _logout(); // Call the logout function
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search members...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIconColor: Colors.black,
                hintStyle: TextStyle(color: const Color.fromARGB(255, 132, 132, 132)),
              ),
              style: TextStyle(color: Colors.black),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 232, 69, 69), // Background color
            ),
            onPressed: () {
              // Prompt to add a new member
              showDialog(
                context: context,
                builder: (context) {
                  TextEditingController nameController = TextEditingController();
                  TextEditingController uidController = TextEditingController();
                  TextEditingController memberIdController = TextEditingController();
                  return AlertDialog(
                    backgroundColor: Color.fromARGB(255, 252, 211, 211),
                    title: Text("Add New Member"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(labelText: 'Name'),
                        ),
                        TextField(
                          controller: uidController,
                          decoration: InputDecoration(labelText: 'UID'),
                        ),
                        TextField(
                          controller: memberIdController,
                          decoration: InputDecoration(labelText: 'Member ID'),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await _addMember(
                              nameController.text, uidController.text, memberIdController.text);
                          Navigator.pop(context); // Close the dialog after adding
                        },
                        child: Text('Add'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text(
              "Add Member",
              style: TextStyle(color: Colors.black),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _hasError
                    ? Center(child: Text('Failed to load data. Please try again.'))
                    : _members.length <= 1
                        ? Center(child: Text('No members found.'))
                        : (() {
                            // Skip the header row and filter members based on search query
                            List<List<dynamic>> filteredMembers = _members.skip(1).where((member) {
                              final name = member[1].toString().toLowerCase();
                              final uid = member[2].toString().toLowerCase();
                              return searchQuery.isEmpty ||
                                  name.contains(searchQuery) ||
                                  uid.contains(searchQuery);
                            }).toList();

                            // If no members match the search query, show a message
                            if (filteredMembers.isEmpty) {
                              return Center(child: Text('No members match your search.'));
                            }

                            return ListView.separated(
                              itemCount: filteredMembers.length,
                              itemBuilder: (context, index) {
                                final member = filteredMembers[index];
                                return ListTile(
                                  title: Text(
                                    member[1], // Display Name
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  subtitle: Text(
                                    'UID: ${member[2]}', // Display UID
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: const Color.fromARGB(255, 232, 69, 69),
                                    ),
                                    onPressed: () async {
                                      await _deleteMember(index + 2); // Adjust for row number
                                    },
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) => MemberDetailsScreen(
                                          name: member[1], // Pass Name
                                          uid: member[2],  // Pass UID
                                          memberId: member[3],  // Pass Member ID
                                        ),
                                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                          var begin = Offset(1.0, 0.0); // Start from the right
                                          var end = Offset.zero; // End at the center
                                          var curve = Curves.easeInOut; // Choose a curve for the animation

                                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                          var offsetAnimation = animation.drive(tween);

                                          return SlideTransition(
                                            position: offsetAnimation,
                                            child: child,
                                          );
                                        },
                                        transitionDuration: Duration(seconds: 1), // Set the desired transition duration
                                      ),
                                    );
                                  },
                                );
                              },
                              separatorBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Divider(),
                                );
                              },
                            );
                          }()),
          ),
        ],
      ),
    );
  }
}
