import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'notification_add.dart';
import 'notification_edit.dart';
import 'map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'notification_controller.dart';
import 'package:intl/intl.dart';

class NotificationDemo extends StatefulWidget {
  final String username;
  final String email; // Add email parameter

  const NotificationDemo(
      {Key? key, required this.username, required this.email})
      : super(key: key);

  @override
  _NotificationDemoState createState() => _NotificationDemoState();
}

class _NotificationDemoState extends State<NotificationDemo> {
  List<String> tasks = [];
  List<IconData> icons = [];
  List<String> times = [];
  List<Color> iconColors = [];
  List<String?> alertTimes = [];

  IconData mapItemNameToIcon(String itemName) {
    // Define keywords and their corresponding icons
    Map<String, IconData> keywordsToIcons = {
      'laptop': Icons.laptop_mac,
      'key': Icons.vpn_key,
      'document': Icons.description,
      'water': Icons.water_drop,
      'light': Icons.lightbulb,
      'lock': Icons.lock,
      'gas': Icons.local_gas_station,
      'wallet': Icons.account_balance_wallet,
      'phone': Icons.phone,
      'call': Icons.phone,
      'book': Icons.menu_book,
      'medicine': Icons.local_pharmacy,
      'headphones': Icons.headphones,
      'umbrella': Icons.beach_access,
      'charger': Icons.battery_charging_full,
      'bag': Icons.shopping_bag,
      'id card': Icons.badge,
      'credit card': Icons.credit_card,
      'mask': Icons.masks,
      'snacks': Icons.fastfood,
      'hat': Icons.wb_sunny,
      'watch': Icons.watch,
      'pen': Icons.create,
      'brush': Icons.brush,
      'sunglasses': Icons.visibility,
    };

    // Loop through keywords and check if the itemName contains any of them
    for (var keyword in keywordsToIcons.keys) {
      if (itemName.toLowerCase().contains(keyword)) {
        return keywordsToIcons[keyword]!;
      }
    }

    // If no keyword matches, return a default icon
    return Icons.disabled_by_default;
  }

  @override
  void initState() {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);

    super.initState();

    // Initialize AwesomeNotifications
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'channelKey',
          channelName: 'channelName',
          channelDescription: 'channelDescription',
          defaultColor: Colors.blueAccent,
          ledColor: Colors.blueAccent,
          playSound: true,
          importance: NotificationImportance.Max,
          defaultRingtoneType: DefaultRingtoneType.Notification,
        ),
      ],
      debug: true, // Enable debug mode
    );
    _scheduleNotifications();
  }

// Schedule notifications based on alert time
  void _scheduleNotifications() {
    FirebaseFirestore.instance
        .collection('Item')
        .where('email', isEqualTo: widget.email)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        var data = document.data();
        String? itemName = data['itemName'];
        String? itemDescription = data['itemDescription'];
        String? alertTime = data['alertTime'];
        String? activeStatus = data['active'];
        List<String>? repeatOptions =
            List<String>.from(data['repeatOptions'] ?? []); //

        print('${itemName}');
        print('${itemDescription}');
        print('${alertTime}');
        print('${activeStatus}');
        print('${repeatOptions}');

        if (itemName != null &&
            itemDescription != null &&
            alertTime != null &&
            activeStatus == 'on') {
          try {
            String TimeString1 = alertTime.split(':')[0];
            String TimeString2 = alertTime.split(':')[1];

            int hour = int.parse(TimeString1);
            int minute = int.parse(TimeString2);

            print('${hour}:${minute}');
            // Check if repeatOptions include 'Never' or today's day of the week
            if (repeatOptions.isEmpty ||
                repeatOptions.contains(_getDayOfWeek(DateTime.now()))) {
              // Schedule notification

              print("sir yessir");
              AwesomeNotifications().createNotification(
                content: NotificationContent(
                  id: 0,
                  channelKey: 'channelKey',
                  title: itemName,
                  body: itemDescription,
                  displayOnBackground: true,
                  displayOnForeground: true,
                ),
                schedule: NotificationCalendar(
                  //    date: alertDateTime,
                  //   allowWhileIdle: true,
                  hour: hour,
                  minute: minute,
                  repeats: true,
                ),
              );
            }
          } catch (e) {
            print('Error parsing alertTime: $e');
            // Handle parsing error gracefully
          }
        }
      });
    });
  }

// Method to get the day of the week as a three-letter abbreviation (e.g., Mon, Tue, etc.)
  String _getDayOfWeek(DateTime dateTime) {
    List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[dateTime.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('Item')
          .orderBy('alertTime')
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child:
                CircularProgressIndicator(), // Show loading indicator while data is being fetched
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
                'Error: ${snapshot.error}'), // Show error message if data fetching fails
          );
        }

        // Extract data from snapshot
        List<String> tasks = [];
        List<IconData> icons = [];
        List<String> times = [];
        List<String?> alertTimes = [];
        List<String> activeStatus = [];
        List<String> userEmails = [];
        List<String> repeatOptionsList = [];
        List<String> documentIds = [];

        snapshot.data!.docs.forEach((document) {
          var data = document.data();
          String? itemName = data['itemName'];
          String? itemDescription = data['itemDescription'];
          String? alertTime = data['alertTime'];
          String? active = data['active']; //
          String? email = data['email']; //
          List<String>? repeatOptions =
              List<String>.from(data['repeatOptions'] ?? []); //

          if (email == widget.email &&
              itemName != null &&
              itemDescription != null) {
            tasks.add(itemName);
            times.add(itemDescription);
            alertTimes.add(alertTime);
            activeStatus.add(active ?? ''); // Added
            userEmails.add(email ?? ''); // Added
            if (repeatOptions == null || repeatOptions.isEmpty) {
              repeatOptionsList.add('Never');
            } else {
              repeatOptionsList.add(repeatOptions.join(','));
            }
            documentIds.add(document.id);
            IconData iconData = mapItemNameToIcon(itemName);
            icons.add(iconData);
          }
        });

        return Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: IconButton(
                  icon: Icon(Icons.notifications_on_outlined),
                  iconSize: 30,
                  onPressed: () {},
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
                        'Let me help remind you',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(fontSize: 15.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Stack(
                    children: <Widget>[
                      Image.asset(
                        'assets/Noti.png',
                      ),
                      Positioned(
                        top: 50,
                        left: 160,
                        child: Image.asset(
                          'assets/sky.png',
                          width: 120,
                          height: 100,
                        ),
                      ),
                      Positioned(
                        top: 230,
                        left: 80,
                        child: StreamBuilder<User?>(
                          stream: FirebaseAuth.instance.authStateChanges(),
                          builder: (BuildContext context,
                              AsyncSnapshot<User?> authSnapshot) {
                            if (authSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (authSnapshot.hasError) {
                              return Text('Error: ${authSnapshot.error}');
                            }
                            if (!authSnapshot.hasData ||
                                authSnapshot.data == null) {
                              return Text('User not logged in');
                            }
                            final user = authSnapshot.data!;
                            return StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('User')
                                  .doc(user.uid)
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
                                  return Text('Location not available');
                                }
                                final location = snapshot.data!['location'];
                                double lat = 0.0;
                                double lng = 0.0;
                                if (location != null) {
                                  lat = location.latitude;
                                  lng = location.longitude;
                                }
                                return Text(
                                  'Home (${lat.toStringAsFixed(2)}, ${lng.toStringAsFixed(2)})',
                                  style: GoogleFonts.poppins(
                                    fontSize: 25,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 190,
                        left: 5,
                        child: IconButton(
                          icon: Icon(Icons.location_on),
                          iconSize: 70,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MapPage(
                                      userId: "")), // Navigate to MapPage
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        for (int i = 0; i < tasks.length; i++)
                          Dismissible(
                            key: Key(tasks[i]), // Unique key for each item
                            direction: DismissDirection
                                .endToStart, // Allow swipe from end to start (right to left)
                            onDismissed: (direction) async {
                              // Find the document ID based on the task name
                              QuerySnapshot<Map<String, dynamic>>
                                  querySnapshot = await FirebaseFirestore
                                      .instance
                                      .collection('Item')
                                      .where('itemName', isEqualTo: tasks[i])
                                      .get();

                              // Check if there's a matching document
                              if (querySnapshot.docs.isNotEmpty) {
                                // Delete the document
                                await FirebaseFirestore.instance
                                    .collection('Item')
                                    .doc(querySnapshot.docs.first.id)
                                    .delete();

                                // Update local state to reflect the change
                                setState(() {
                                  tasks.removeAt(i);
                                  icons.removeAt(i);
                                  times.removeAt(i);
                                  alertTimes.removeAt(i);
                                });
                              }
                            },
                            background: Container(
                              color:
                                  Colors.red, // Red background color for delete
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(
                                  right: 20.0), // Adjust padding as needed
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NotificationEdit(
                                      username: widget.username,
                                      itemName: tasks[i],
                                    ),
                                  ),
                                ).then((_) {
                                  _scheduleNotifications();
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(15.0),
                                margin: EdgeInsets.symmetric(vertical: 10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: const Color(0xFFF1F3E6),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            color: const Color(0xFFE6E9D6),
                                          ),
                                          child: Icon(
                                            icons[i],
                                            color: const Color(0xFF232323),
                                          ),
                                        ),
                                        SizedBox(width: 8.0),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                SizedBox(width: 8.0),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                      children: [
                                                        Text(
                                                          tasks[i],
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(width: 8.0),
                                                        Icon(
                                                          Icons.access_time,
                                                          size:
                                                              15, // Change the size to your desired value
                                                        ),
                                                        Text(
                                                          " (" +
                                                              (alertTimes[i] ??
                                                                  'Default Time') +
                                                              ")",
                                                          style: GoogleFonts
                                                              .poppins(
                                                            color:
                                                                Color.fromARGB(
                                                                    228,
                                                                    51,
                                                                    51,
                                                                    51),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      repeatOptionsList[i],
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color:
                                                            Color(0xFFDB36AD),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Switch(
                                          value: activeStatus[i] == 'on',
                                          onChanged: (newValue) async {
                                            setState(() {
                                              activeStatus[i] =
                                                  newValue ? 'on' : 'off';
                                            });

                                            // Update Firestore document
                                            await FirebaseFirestore.instance
                                                .collection('Item')
                                                .doc(documentIds[
                                                    i]) // Replace documentId with the actual document ID
                                                .update({
                                              'active': newValue ? 'on' : 'off'
                                            });
                                          },
                                          activeColor: Colors
                                              .green, // Change the color of the active switch
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 16.0, // Adjust bottom margin as needed
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddItemPage(
                                  username: widget.username,
                                  email: widget.email)),
                        );
                      },
                      tooltip: 'Add Task',
                      child: Icon(Icons.add),
                      backgroundColor: Color(0xFF232323),
                      foregroundColor: Colors.white,
                      shape: CircleBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          backgroundColor: const Color(0xFFF8FAED),
        );
      },
    );
  }
}
