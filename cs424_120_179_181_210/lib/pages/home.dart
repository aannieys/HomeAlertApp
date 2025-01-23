import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HomePage extends StatefulWidget {
  final String username;

  HomePage({required this.username});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Icon(Icons.notifications_on_outlined),
              iconSize: 30,
              onPressed: () {
                // Add your notification action here
              },
            ),
          ),
        ],
        backgroundColor: const Color(0xFFF8FAED),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Row(
                    children: <Widget>[
                      Expanded(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('User')
                                  .doc(user!.uid)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                }
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                }
                                if (!snapshot.hasData ||
                                    snapshot.data == null) {
                                  return Text('Username not available');
                                }
                                final username = snapshot.data!['username'];
                                return Text(
                                  'Hi $username!',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.poppins(
                                    fontSize: 50.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Welcome to your Home',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(fontSize: 15.0),
                  ),
                ),
              ),
              SizedBox(height: 60.0),
              Stack(
                children: <Widget>[
                  // Widget in the background (e.g., your existing house.png)
                  Image.asset(
                    'assets/house.png',
                  ),
                  // Image to be displayed in front of the background
                  Positioned(
                    top: 0, // Adjust the position as per your requirement
                    left: 30, // Adjust the position as per your requirement
                    child: Image.asset(
                      'assets/sky2.png', // Replace 'your_image.png' with the name of your image
                      //width: 300, // Adjust width as per your requirement
                      height: 50, // Adjust height as per your requirement
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF8FAED),
    );
  }
}
