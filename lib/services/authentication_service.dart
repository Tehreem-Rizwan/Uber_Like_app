import 'package:flutter/material.dart';

class AuthenticationService with ChangeNotifier {
  bool isAuthenticated = false;

  void login(String email, String password) {
    // Simulate a login by setting isAuthenticated to true
    isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    isAuthenticated = false;
    notifyListeners();
  }
}
