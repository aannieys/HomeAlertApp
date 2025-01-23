import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

import 'package:google_fonts/google_fonts.dart';

class MainHome extends StatefulWidget {
  final String username;
  final String email;

  MainHome({required this.username, required this.email});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  // Define room data
  int current = 0; // Index of the current room
  late PageController pageController;
  List<String> rooms = [
    "Bathroom",
    "Bedroom",
    "Dining",
    "Garage",
    "Kitchen",
    "Laundry",
    "Living",
  ];

  List<String> roomImages = [
    "assets/Bath.png",
    "assets/bedroom.png",
    "assets/dining.png",
    "assets/garage.png",
    "assets/kitchen.png",
    "assets/laundry.png",
    "assets/living.png",
  ];

  List<IconData> icons = [
    Icons.bathtub,
    Icons.bed,
    Icons.dinner_dining,
    Icons.directions_car,
    Icons.kitchen,
    Icons.local_laundry_service,
    Icons.weekend,
  ];

  List<List<Map<String, dynamic>>> devices = [
    [
      {
        "name": "Light",
        "iconPath": "assets/icons/light-bulb.png",
        "properties": {"powerOn": false}
      },
      {
        "name": "Tap",
        "iconPath": "assets/icons/water-tap.png",
        "properties": {"powerOn": false}
      },
      {"name": "Tub", "iconPath": "assets/icons/bathtub.png", "powerOn": false},
    ],
    [
      {
        "name": "Air Con",
        "iconPath": "assets/icons/air-conditioner.png",
        "properties": {"powerOn": false}
      },
      {
        "name": "Lamp",
        "iconPath": "assets/icons/BedsideLamp.png",
        "properties": {"powerOn": false}
      },
      {
        "name": "Clock",
        "iconPath": "assets/icons/alarm.png",
        "properties": {"powerOn": false}
      },
    ],
    [
      {
        "name": "Light",
        "iconPath": "assets/icons/light-bulb.png",
        "properties": {"powerOn": false}
      },
    ],
    [
      {
        "name": "Light",
        "iconPath": "assets/icons/light-bulb.png",
        "properties": {"powerOn": false}
      },
      {
        "name": "Door",
        "iconPath": "assets/icons/door.png",
        "properties": {"powerOn": false}
      },
    ],
    [
      {
        "name": "Fan",
        "iconPath": "assets/icons/fan.png",
        "properties": {"powerOn": false}
      },
      {
        "name": "Gas",
        "iconPath": "assets/icons/gas.png",
        "properties": {"powerOn": false}
      },
      {
        "name": "Light",
        "iconPath": "assets/icons/light-bulb.png",
        "properties": {"powerOn": false}
      },
    ],
    [
      {
        "name": "Tap",
        "iconPath": "assets/icons/water-tap.png",
        "properties": {"powerOn": false}
      },
      {
        "name": "Light",
        "iconPath": "assets/icons/light-bulb.png",
        "properties": {"powerOn": false}
      },
      {
        "name": "Washer",
        "iconPath": "assets/icons/washing.png",
        "properties": {"powerOn": false}
      },
    ],
    [
      {"name": "TV", "iconPath": "assets/icons/tv.png", "powerOn": false},
      {
        "name": "Light",
        "iconPath": "assets/icons/light-bulb.png",
        "properties": {"powerOn": false}
      },
    ],
  ];

  // List to hold retrieved room data
  List<Map<String, dynamic>> roomsData = [];

  @override
  void initState() {
    super.initState();
    // Call function to add user room data only if it hasn't been added before
    _checkAndAddRoomsAndDevices();
    pageController =
        PageController(initialPage: current); // Initialize pageController here
    // Call function to retrieve user room data
    retrieveUserRooms(widget.email);
  }

  Future<void> _checkAndAddRoomsAndDevices() async {
    try {
      // Get a reference to the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Reference to the UserRoom collection
      CollectionReference userRoomCollection = firestore.collection('UserRoom');

      // Get the user's rooms
      QuerySnapshot querySnapshot =
          await userRoomCollection.doc(widget.email).collection('rooms').get();

      if (querySnapshot.docs.isNotEmpty) {
        // Rooms exist for the user's email, no need to add rooms and devices
        print('Rooms already exist for email: ${widget.email}');
      } else if (querySnapshot.docs.isEmpty) {
        // Rooms don't exist for the user's email, add rooms and devices
        await _addRoomsAndDevices();
        print(
            'Rooms and devices added successfully for email: ${widget.email}');
      }
    } catch (e) {
      print('Error checking or adding user data: $e');
    }
  }

  // Function to add user room data to Firestore
  Future<void> _addRoomsAndDevices() async {
    try {
      // Get a reference to the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Reference to the UserRoom collection
      CollectionReference userRoomCollection = firestore.collection('UserRoom');

      // Iterate through rooms and add data
      for (int i = 0; i < rooms.length; i++) {
        // Room data
        Map<String, dynamic> roomData = {
          'roomName': rooms[i],
          'roomImage': roomImages[i],
          'icon': icons[i].codePoint,
          'devices': devices[i],
        };

        // Add room data to Firestore
        await userRoomCollection
            .doc(widget.email)
            .collection('rooms')
            .doc(rooms[i])
            .set(roomData);
      }

      print('User room data added successfully');
    } catch (e) {
      print('Error adding user room data: $e');
    }
  }

  Future<void> retrieveUserRooms(String userEmail) async {
    try {
      // Get a reference to the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Reference to the UserRoom collection
      CollectionReference userRoomCollection = firestore.collection('UserRoom');

      // Get the user's rooms
      QuerySnapshot querySnapshot =
          await userRoomCollection.doc(userEmail).collection('rooms').get();

      // Extract data from the query snapshot
      final List<QueryDocumentSnapshot> roomDocuments = querySnapshot.docs;
      roomDocuments.forEach((doc) {
        print('Room Name: ${doc['roomName']}');
        print('Room Image: ${doc['roomImage']}');
        print('Icon: ${String.fromCharCode(doc['icon'])}');
        print('Devices: ${doc['devices']}');
      });
      print('User room data retrieved successfully');
    } catch (e) {
      print('Error retrieving user room data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Color(0xFFFEFAED),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF50A65C),
        title: Column(
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('User')
                  .doc(user!.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return Text('Username not available');
                }
                final username = snapshot.data!['username'];
                return Text(
                  'Hi $username!',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
            SizedBox(
                height: 8), // Add spacing between username and welcome message
            Text(
              "Welcome to your home",
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Color(0xFF232323),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        margin: const EdgeInsets.all(5),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 80,
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: rooms.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              current = index;
                            });
                            pageController.animateToPage(
                              current,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.ease,
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.all(5),
                            width: 100,
                            height: 55,
                            decoration: BoxDecoration(
                              color: current == index
                                  ? Colors.white70
                                  : Colors.white54,
                              borderRadius: current == index
                                  ? BorderRadius.circular(12)
                                  : BorderRadius.circular(7),
                              border: current == index
                                  ? Border.all(
                                      color: Color(0xFF50A65C), width: 2.5)
                                  : null,
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    icons[index],
                                    size: current == index ? 23 : 20,
                                    color: current == index
                                        ? Colors.black
                                        : Colors.grey.shade400,
                                  ),
                                  Text(
                                    rooms[index],
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      color: current == index
                                          ? Colors.black
                                          : Colors.grey.shade400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: current == index,
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                                color: Color(0xFF50A65C),
                                shape: BoxShape.circle),
                          ),
                        )
                      ],
                    );
                  }),
            ),
            Container(
              margin: const EdgeInsets.only(top: 0),
              width: double.infinity,
              height: 510,
              child: PageView.builder(
                itemCount: rooms.length,
                controller: pageController,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RoomImage(
                        roomImages[index],
                        rooms[index], // Pass room name from the items list
                        widget.email,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoomImage extends StatelessWidget {
  final String imagePath;
  final String roomName;
  final String email;

  RoomImage(this.imagePath, this.roomName, this.email);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('UserRoom')
          .doc(email) // Assuming 'UserRoom' is the collection name
          .collection('rooms')
          .doc(roomName) // Document for the current room
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Loading indicator
        }
        if (!snapshot.hasData || snapshot.data?.data() == null) {
          return Text('No devices found'); // No data available
        }

        Map<String, dynamic> roomData = snapshot.data!.data()!;
        List<SmartDeviceBox> devices =
            List<SmartDeviceBox>.from(roomData['devices'].map(
          (device) => SmartDeviceBox(
            email: email,
            roomName: roomName,
            smartDeviceName: device['name'],
            iconPath: device['iconPath'],
            powerOn: device['properties']?['powerOn'] ??
                false, // Assuming initial state is off
            onChanged: (value) {
              // Handle device state change here
            },
          ),
        ));

        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: 300,
                    height: 300,
                    alignment: Alignment.topCenter,
                    child: FractionalTranslation(
                      translation: Offset(0, -0.05),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  // Display devices for the current room
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: devices.map((device) {
                        return Container(
                          width: 200, // Fixed width
                          height: 200, // Fixed height
                          child: device,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              bottom: 200,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, bottom: 10.0), // Adjusted padding
                child: Text(
                  '   Devices',
                  style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class SmartDeviceBox extends StatefulWidget {
  final String email;
  final String roomName;
  final String smartDeviceName;
  final String iconPath;
  final bool powerOn;
  final void Function(bool)? onChanged;

  SmartDeviceBox({
    required this.email,
    required this.roomName,
    required this.smartDeviceName,
    required this.iconPath,
    required this.powerOn,
    required this.onChanged,
  });

  @override
  _SmartDeviceBoxState createState() => _SmartDeviceBoxState();
}

class _SmartDeviceBoxState extends State<SmartDeviceBox> {
  late bool _powerOn;

  @override
  void initState() {
    super.initState();
    _powerOn = widget.powerOn;
  }

  Future<void> updatePowerOnValue(
      String roomName, String deviceName, bool newValue) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference roomCollection = firestore.collection('UserRoom');

      // Get the reference to the specific room document
      DocumentReference<Map<String, dynamic>> roomRef =
          roomCollection.doc(widget.email).collection('rooms').doc(roomName);

      // Get the room document
      DocumentSnapshot<Map<String, dynamic>> roomDoc = await roomRef.get();

      if (roomDoc.exists) {
        // Retrieve the devices array from the room document
        List<dynamic> devices = roomDoc.data()?['devices'] ?? [];

        // Find the device within the devices array
        int deviceIndex =
            devices.indexWhere((device) => device['name'] == deviceName);

        if (deviceIndex != -1) {
          // If the device is found, update its powerOn property
          devices[deviceIndex]['properties']['powerOn'] = newValue;

          // Update the devices array in Firestore
          await roomRef.update({'devices': devices});

          print('PowerOn value updated successfully');
        } else {
          print('Device $deviceName not found in room $roomName');
        }
      } else {
        print('Room $roomName not found');
      }
    } catch (e) {
      print('Error updating powerOn value: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _powerOn = !_powerOn;
          if (widget.onChanged != null) {
            widget.onChanged!(_powerOn);
          }
          print(
              'Room Name: ${widget.roomName}, Smart Device Name: ${widget.smartDeviceName}, Power On: $_powerOn');
          updatePowerOnValue(widget.roomName, widget.smartDeviceName, _powerOn);
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color:
                _powerOn ? Colors.grey[900] : Color.fromARGB(44, 164, 167, 189),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // icon
                Image.asset(
                  widget.iconPath,
                  height: 65,
                  color: _powerOn ? Colors.white : Colors.grey.shade700,
                ),

                // smart device name + switch
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          widget.smartDeviceName,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: _powerOn ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Transform.rotate(
                      angle: pi / 2,
                      child: Container(
                        width: 45.0,
                        height: 25.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color:
                              _powerOn ? Colors.green[300] : Colors.grey[300],
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              left: _powerOn ? 20.0 : 0.0,
                              child: Container(
                                width: 25.0,
                                height: 25.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _powerOn ? Colors.white : Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
