// services/user_service.dart
import 'package:flutter/material.dart';
import '../models/user.dart';

class UserService with ChangeNotifier {
  User? _user;

  User? get user => _user;

  Future<void> fetchUser() async {
    // Simulated user data
    _user = User(
      id: 1,
      name: 'User One',
      email: 'userone@example.com',
      latitude: 37.7749,
      longitude: -122.4194,
    );
    notifyListeners();
  }
}
