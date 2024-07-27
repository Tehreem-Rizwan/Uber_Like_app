import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';

import 'package:uber_like_app/models/driver_model.dart';
import 'package:uber_like_app/services/driver_service.dart';
import 'package:uber_like_app/services/user_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  final TextEditingController _searchController = TextEditingController();
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _fetchDriversAndAddMarkers();
    _fetchUser();
  }

  void _requestLocationPermission() async {
    PermissionStatus permission = await Permission.location.request();

    if (permission.isGranted) {
      _getCurrentLocation();
    } else {
      // Handle permission denied
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Location permission is required to use this app')),
      );
    }
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
        _markers.add(
          Marker(
            markerId: const MarkerId("currentLocation"),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: const InfoWindow(title: "You are here"),
          ),
        );
      });
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          14.0,
        ),
      );
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to get current location')),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_currentPosition != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        ),
      );
    }
  }

  void _fetchDriversAndAddMarkers() async {
    final driverService = Provider.of<DriverService>(context, listen: false);
    await driverService.fetchDrivers();
    _addDriverMarkers(driverService.drivers);
  }

  void _fetchUser() async {
    final userService = Provider.of<UserService>(context, listen: false);
    await userService.fetchUser();
  }

  void _addDriverMarkers(List<DriverModel> drivers) {
    setState(() {
      _markers.addAll(drivers.map((driver) {
        return Marker(
          markerId: MarkerId(driver.id.toString()),
          position: LatLng(driver.latitude, driver.longitude),
          infoWindow: InfoWindow(
            title: driver.name,
            snippet: driver.carModel,
          ),
        );
      }).toList());
    });
  }

  void _searchDestination(String destination) async {
    try {
      List<Location> locations = await locationFromAddress(destination);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        _mapController?.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(location.latitude, location.longitude),
          ),
        );
        setState(() {
          _markers.add(
            Marker(
              markerId: const MarkerId("searchedLocation"),
              position: LatLng(location.latitude, location.longitude),
              infoWindow: InfoWindow(title: destination),
            ),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to find location')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to find location')),
      );
    }
  }

  void _requestRide() async {
    Map<String, dynamic> response = await simulateRideRequest();

    if (response['status'] == 'success') {
      // Display ride details
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Ride Requested Successfully'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Ride ID: ${response['ride_id']}'),
                Text('Driver: ${response['driver']['name']}'),
                Text('Car Model: ${response['driver']['car_model']}'),
                Text('Rating: ${response['driver']['rating']}'),
                Text(
                    'Estimated Arrival Time: ${response['estimated_arrival_time']}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Handle ride request failure
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to request ride')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final user = userService.user;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Uber-like App',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.grey[300],
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (user != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('User: ${user.name}'),
                        Text('Email: ${user.email}'),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search for a destination',
                      suffixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      _searchDestination(value);
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(_currentPosition!.latitude,
                          _currentPosition!.longitude),
                      zoom: 14,
                    ),
                    myLocationEnabled: true,
                    markers: _markers,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Consumer<DriverService>(
                    builder: (context, driverService, child) {
                      return ListView.builder(
                        itemCount: driverService.drivers.length,
                        itemBuilder: (context, index) {
                          DriverModel driver = driverService.drivers[index];
                          return ListTile(
                            title: Text(driver.name),
                            subtitle: Text(driver.carModel),
                            trailing: Text(driver.rating.toString()),
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                    ),
                    onPressed: _requestRide,
                    child: const Text('Request a Ride',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
              ],
            ),
    );
  }
}

Future<Map<String, dynamic>> simulateRideRequest() async {
  // Simulating a network delay
  await Future.delayed(const Duration(seconds: 2));

  // Sample ride request response
  final response = {
    "status": "success",
    "ride_id": 12345,
    "driver": {
      "id": 1,
      "name": "John Doe",
      "car_model": "Toyota Prius",
      "rating": 4.8,
      "location": {"latitude": 37.7749, "longitude": -122.4194}
    },
    "estimated_arrival_time": "5 minutes"
  };

  return response;
}
