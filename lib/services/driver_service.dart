// services/driver_service.dart
import 'package:flutter/material.dart';
import '../models/driver_model.dart';

class DriverService with ChangeNotifier {
  List<DriverModel> _drivers = [];

  List<DriverModel> get drivers => _drivers;

  Future<void> fetchDrivers() async {
    // Simulated driver data
    _drivers = [
      DriverModel(
        id: 1,
        name: 'John Doe',
        carModel: 'Toyota Prius',
        rating: 4.8,
        latitude: 37.7749,
        longitude: -122.4194,
      ),
      DriverModel(
        id: 2,
        name: 'Jane Smith',
        carModel: 'Honda Civic',
        rating: 4.6,
        latitude: 37.7750,
        longitude: -122.4183,
      ),
      DriverModel(
        id: 3,
        name: 'Mike Johnson',
        carModel: 'Ford Fusion',
        rating: 4.7,
        latitude: 37.7751,
        longitude: -122.4172,
      ),
    ];
    notifyListeners();
  }
}
