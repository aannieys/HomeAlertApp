import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location_package;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

import 'notification.dart'; // Import NotificationDemo screen

class MapPage extends StatefulWidget {
  final String userId; // Add this line
  const MapPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  location_package.Location _locationController = location_package.Location();

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  LatLng? _selectedLocation;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    // Check and request location permissions if not granted
    final location_package.PermissionStatus permissionStatus =
        await _locationController.requestPermission();
    if (permissionStatus != location_package.PermissionStatus.granted) {
      // Handle if permission not granted
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context); // Navigate back to the previous screen
              },
              child: CircleAvatar(
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) async {
              _mapController.complete(controller);
              _handleInitialLocation();
            },
            onTap: _handleMapTap,
            initialCameraPosition: CameraPosition(
              target: LatLng(0.0, 0.0), // Default to center of the map
              zoom: 15,
            ),
            markers: _selectedLocation != null
                ? {
                    Marker(
                      markerId: MarkerId("selectedLocation"),
                      position: _selectedLocation!,
                    ),
                  }
                : {},
            zoomControlsEnabled: true, // Disable default zoom controls
            myLocationButtonEnabled: false, // Disable default location button
            padding: EdgeInsets.only(
                top: 16.0, right: 16.0),
            myLocationEnabled: true, // Enable showing user's location
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Icon(Icons.search),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search Maps',
                        border: InputBorder.none,
                      ),
                      onSubmitted: _searchPlace,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                    },
                    icon: Icon(
                      Icons.star,
                      color: _isFavorite ? Colors.yellow : Colors.grey,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_selectedLocation != null) {
                        _saveLocationToFirestore(_selectedLocation!);
                        Navigator.pop(
                            context); // Navigate back to the previous screen
                      } else {
                        // Show a message indicating no location is selected
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Please select a location on the map.'),
                          ),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                    child: Text(
                      'Done',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleInitialLocation() async {
    try {
      final GoogleMapController controller = await _mapController.future;
      location_package.LocationData currentLocation =
          await _locationController.getLocation();
      if (currentLocation != null) {
        controller.animateCamera(
          CameraUpdate.newLatLng(LatLng(
            currentLocation.latitude!,
            currentLocation.longitude!,
          )),
        );
      } else {
        // Handle case where currentLocation is null
      }
    } catch (e) {
      // Handle error getting initial location
      print('Error getting initial location: $e');
    }
  }

  void _handleMapTap(LatLng tappedPoint) {
    setState(() {
      _selectedLocation = tappedPoint;
      // Update marker position
      _updateMarker(tappedPoint);
    });
  }

  void _updateMarker(LatLng position) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newLatLng(position),
    );
  }

  Future<void> _saveLocationToFirestore(LatLng location) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userId = user.uid;
        final userRef =
            FirebaseFirestore.instance.collection('User').doc(userId);
        await userRef.set({
          'location': GeoPoint(location.latitude, location.longitude),
        }, SetOptions(merge: true));
      } else {
        // Handle the case where user is not signed in
        print('User is not signed in.');
      }
    } catch (e) {
      // Handle any errors that occur during saving the location
      print('Error saving location: $e');
    }
  }

  Future<void> _searchPlace(String query) async {
    try {
      final results = await geocoding.locationFromAddress(query);
      if (results.isNotEmpty) {
        final location = results.first;
        final GoogleMapController controller = await _mapController.future;
        controller.animateCamera(
          CameraUpdate.newLatLng(LatLng(location.latitude, location.longitude)),
        );
        setState(() {
          _selectedLocation = LatLng(location.latitude, location.longitude);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No results found for the search query.'),
          ),
        );
      }
    } catch (e) {
      print('Error searching place: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error searching place. Please try again.'),
        ),
      );
    }
  }
}
