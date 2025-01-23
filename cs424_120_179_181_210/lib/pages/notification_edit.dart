import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'notification.dart';

class NotificationEdit extends StatefulWidget {
  final String username;
  final String itemName;

  NotificationEdit({Key? key, required this.username, required this.itemName})
      : super(key: key);

  @override
  _NotificationEditState createState() => _NotificationEditState();
}

class _NotificationEditState extends State<NotificationEdit> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TimeOfDay? alertTime;

  String itemName = '';
  String itemDescription = '';
  String selectedRepeatOption = 'Never';
  List<String> repeatOptions = [];

  @override
  void initState() {
    super.initState();
    // Fetch data from Firestore
    fetchDataFromFirestore();
  }

  Future<void> fetchDataFromFirestore() async {
    try {
      // Query Firestore to get the document with the specified itemName
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('Item')
              .where('itemName', isEqualTo: widget.itemName)
              .get();

      // Check if the document exists
      if (querySnapshot.docs.isNotEmpty) {
        // Extract data from the document
        var data = querySnapshot.docs.first.data();
        itemName = data['itemName'];
        itemDescription = data['itemDescription'];
        String alertTimeString = data['alertTime'];
        repeatOptions = List<String>.from(data['repeatOptions']);

        // Update the state with the fetched data
        setState(() {
          nameController.text = itemName;
          descriptionController.text = itemDescription;
          if (alertTimeString != null && alertTimeString.isNotEmpty) {
            var timeParts = alertTimeString.split(':');
            int hour = int.parse(timeParts[0]);
            int minute = int.parse(timeParts[1]);
            alertTime = TimeOfDay(hour: hour, minute: minute);
          }
          selectedRepeatOption =
              repeatOptions.isEmpty ? 'Never' : repeatOptions.join(', ');
        });
      } else {
        print('Document not found');
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  void showRepeatOptionsDialog(BuildContext context) async {
    List<String> result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        List<String> selectedOptions =
            repeatOptions.toList(); // Create a copy of repeatOptions
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15.0), // Adjust border radius as needed
            // You can also customize other properties like border color, etc.
          ),
          title: Text('Repeat Options'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 0),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (selectedOptions.contains('Sun')) {
                                selectedOptions.remove('Sun');
                              } else {
                                selectedOptions.add('Sun');
                              }
                            });
                          },
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            title: Text(
                              'Every Sunday',
                              style: TextStyle(
                                fontSize: 16,
                              ), // Adjust font size as needed
                            ),
                            trailing: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Material(
                                type: MaterialType.circle,
                                color: Colors.transparent,
                                child: Container(
                                  width: 26.0,
                                  height: 26.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.transparent,
                                      width: 2.0, // Thickness of the border
                                    ),
                                  ),
                                  child: Center(
                                    child: selectedOptions.contains('Sun')
                                        ? Icon(
                                            Icons.check,
                                            size: 20.0,
                                            color: const Color.fromARGB(
                                                255, 56, 56, 56), // Check color
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 0,
                          thickness: 0.5,
                          color: Colors.black,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (selectedOptions.contains('Mon')) {
                                selectedOptions.remove('Mon');
                              } else {
                                selectedOptions.add('Mon');
                              }
                            });
                          },
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            title: Text(
                              'Every Monday',
                              style: TextStyle(
                                fontSize: 16,
                              ), // Adjust font size as needed
                            ),
                            trailing: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Material(
                                type: MaterialType.circle,
                                color: Colors.transparent,
                                child: Container(
                                  width: 26.0,
                                  height: 26.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.transparent,
                                      width: 2.0, // Thickness of the border
                                    ),
                                  ),
                                  child: Center(
                                    child: selectedOptions.contains('Mon')
                                        ? Icon(
                                            Icons.check,
                                            size: 20.0,
                                            color: const Color.fromARGB(
                                                255, 56, 56, 56), // Check color
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 0,
                          thickness: 0.5,
                          color: Colors.black,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (selectedOptions.contains('Tue')) {
                                selectedOptions.remove('Tue');
                              } else {
                                selectedOptions.add('Tue');
                              }
                            });
                          },
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            title: Text(
                              'Every Tuesday',
                              style: TextStyle(
                                fontSize: 16,
                              ), // Adjust font size as needed
                            ),
                            trailing: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Material(
                                type: MaterialType.circle,
                                color: Colors.transparent,
                                child: Container(
                                  width: 26.0,
                                  height: 26.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.transparent,
                                      width: 2.0, // Thickness of the border
                                    ),
                                  ),
                                  child: Center(
                                    child: selectedOptions.contains('Tue')
                                        ? Icon(
                                            Icons.check,
                                            size: 20.0,
                                            color: const Color.fromARGB(
                                                255, 56, 56, 56), // Check color
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 0,
                          thickness: 0.5,
                          color: Colors.black,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (selectedOptions.contains('Wed')) {
                                selectedOptions.remove('Wed');
                              } else {
                                selectedOptions.add('Wed');
                              }
                            });
                          },
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            title: Text(
                              'Every Wednesday',
                              style: TextStyle(
                                fontSize: 16,
                              ), // Adjust font size as needed
                            ),
                            trailing: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Material(
                                type: MaterialType.circle,
                                color: Colors.transparent,
                                child: Container(
                                  width: 26.0,
                                  height: 26.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.transparent,
                                      width: 2.0, // Thickness of the border
                                    ),
                                  ),
                                  child: Center(
                                    child: selectedOptions.contains('Wed')
                                        ? Icon(
                                            Icons.check,
                                            size: 20.0,
                                            color: const Color.fromARGB(
                                                255, 56, 56, 56), // Check color
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 0,
                          thickness: 0.5,
                          color: Colors.black,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (selectedOptions.contains('Thu')) {
                                selectedOptions.remove('Thu');
                              } else {
                                selectedOptions.add('Thu');
                              }
                            });
                          },
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            title: Text(
                              'Every Thursday',
                              style: TextStyle(
                                fontSize: 16,
                              ), // Adjust font size as needed
                            ),
                            trailing: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Material(
                                type: MaterialType.circle,
                                color: Colors.transparent,
                                child: Container(
                                  width: 26.0,
                                  height: 26.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.transparent,
                                      width: 2.0, // Thickness of the border
                                    ),
                                  ),
                                  child: Center(
                                    child: selectedOptions.contains('Thu')
                                        ? Icon(
                                            Icons.check,
                                            size: 20.0,
                                            color: const Color.fromARGB(
                                                255, 56, 56, 56), // Check color
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 0,
                          thickness: 0.5,
                          color: Colors.black,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (selectedOptions.contains('Fri')) {
                                selectedOptions.remove('Fri');
                              } else {
                                selectedOptions.add('Fri');
                              }
                            });
                          },
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            title: Text(
                              'Every Friday',
                              style: TextStyle(
                                fontSize: 16,
                              ), // Adjust font size as needed
                            ),
                            trailing: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Material(
                                type: MaterialType.circle,
                                color: Colors.transparent,
                                child: Container(
                                  width: 26.0,
                                  height: 26.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.transparent,
                                      width: 2.0, // Thickness of the border
                                    ),
                                  ),
                                  child: Center(
                                    child: selectedOptions.contains('Fri')
                                        ? Icon(
                                            Icons.check,
                                            size: 20.0,
                                            color: const Color.fromARGB(
                                                255, 56, 56, 56), // Check color
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 0,
                          thickness: 0.5,
                          color: Colors.black,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (selectedOptions.contains('Sat')) {
                                selectedOptions.remove('Sat');
                              } else {
                                selectedOptions.add('Sat');
                              }
                            });
                          },
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            title: Text(
                              'Every Saturday',
                              style: TextStyle(
                                fontSize: 16,
                              ), // Adjust font size as needed
                            ),
                            trailing: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Material(
                                type: MaterialType.circle,
                                color: Colors.transparent,
                                child: Container(
                                  width: 26.0,
                                  height: 26.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.transparent,
                                      width: 2.0, // Thickness of the border
                                    ),
                                  ),
                                  child: Center(
                                    child: selectedOptions.contains('Sat')
                                        ? Icon(
                                            Icons.check,
                                            size: 20.0,
                                            color: const Color.fromARGB(
                                                255, 56, 56, 56), // Check color
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 0,
                          thickness: 0.5,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(selectedOptions); // Return selectedOptions
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        repeatOptions = result;
        selectedRepeatOption =
            repeatOptions.isEmpty ? 'Never' : repeatOptions.join(', ');
      });
    }
  }

  Future<void> updateItemInFirebase() async {
    try {
      // Query Firestore to get the document with the specified itemName
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('Item')
              .where('itemName', isEqualTo: widget.itemName)
              .get();

      // Extract document ID
      String? docId;
      if (querySnapshot.docs.isNotEmpty) {
        docId = querySnapshot.docs.first.id;
      }

      // Update item data if the document exists
      if (docId != null) {
        await FirebaseFirestore.instance.collection('Item').doc(docId).update({
          'itemName': nameController.text,
          'itemDescription': descriptionController.text,
          'alertTime': alertTime != null
              ? '${alertTime!.hour.toString().padLeft(2, '0')}:${alertTime!.minute.toString().padLeft(2, '0')}'
              : null,
          'repeatOptions': repeatOptions,
        });
        print('Item updated successfully');
      } else {
        // If the document doesn't exist, add a new document
        await FirebaseFirestore.instance.collection('Item').add({
          'itemName': nameController.text,
          'itemDescription': descriptionController.text,
          'alertTime': alertTime != null
              ? '${alertTime!.hour.toString().padLeft(2, '0')}:${alertTime!.minute.toString().padLeft(2, '0')}'
              : null,
          'repeatOptions': repeatOptions,
        });
        // Print the variables being added
        print('Adding new document:');
        print('itemName: ${nameController.text}');
        print('itemDescription: ${descriptionController.text}');
        print(
            'alertTime: ${alertTime != null ? '${alertTime!.hour.toString().padLeft(2, '0')}:${alertTime!.minute.toString().padLeft(2, '0')}' : null}');
        print('repeatOptions: $repeatOptions');
        print('Item added successfully (no docID)');
      }
    } catch (error) {
      print("Error updating item: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEFAED),
      appBar: AppBar(
        backgroundColor: Color(0xFFFEFAED),
        title: Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                ),
              ),
              Text(
                "Edit Item",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                "           ",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            // Input field for item name
            Card(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              color: Color(0xFFFEFAED),
              child: Padding(
                padding:
                    EdgeInsets.only(left: 20.0, top: 3, bottom: 3, right: 20.0),
                child: TextFormField(
                  controller: nameController,
                  onChanged: (value) {
                    setState(() {
                      itemName = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Item\'s name',
                    hintText: ' ',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            // Input field for item description
            Card(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              color: Color(0xFFFEFAED),
              child: Padding(
                padding:
                    EdgeInsets.only(left: 20.0, top: 3, bottom: 3, right: 20.0),
                child: TextFormField(
                  controller: descriptionController,
                  onChanged: (value) {
                    setState(() {
                      itemDescription = value;
                    });
                  },
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: ' ',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),

            // Input field for alert time
            Card(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              color: Color(0xFFFEFAED),
              child: ListTile(
                onTap: () async {
                  // Use onTap for ListTile instead of onPressed for TextButton
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (selectedTime != null) {
                    setState(() {
                      alertTime = selectedTime;
                    });
                  }
                },
                title: Text(
                  'Alert Time',
                ),
                trailing: Row(
                  // Change Row to Row for alignment of icon or text
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (alertTime != null)
                      Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${alertTime!.hour.toString().padLeft(2, '0')}:${alertTime!.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            color: Color.fromARGB(255, 49, 148, 206),
                            fontSize: 16,
                          ),
                        ),
                      )
                    else
                      Container(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.access_time,
                          color: Colors.blue,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            // Input field for repeat options
            Card(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              color: Color(0xFFFEFAED),
              child: ListTile(
                onTap: () {
                  showRepeatOptionsDialog(context);
                },
                title: Text('Repeat'),
                trailing: Text(
                  selectedRepeatOption,
                  style: TextStyle(
                      color: Color.fromARGB(255, 49, 148, 206),
                      fontSize: 16, // Set the desired font size here
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Button to save the item
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, top: 20, right: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        // Update item in Firebase
                        updateItemInFirebase();
                        // Clear text fields and reset state
                        //nameController.clear();
                        //descriptionController.clear();
                        setState(() {
                          nameController.text = itemName;
                          descriptionController.text = itemDescription;
                          // Setting alertTime to current value or null if it's not set
                          alertTime = alertTime ?? TimeOfDay.now();
                          // Update selectedRepeatOption to reflect the current state
                          selectedRepeatOption = repeatOptions.isEmpty
                              ? 'Never'
                              : repeatOptions.join(', ');
                        });

                        // Navigate back to notification page
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Edit Item',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
