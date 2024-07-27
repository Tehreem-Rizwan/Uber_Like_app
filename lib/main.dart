import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_like_app/services/user_service.dart';
import 'screens/login_screen.dart';
import 'services/driver_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserService()),
        ChangeNotifierProvider(create: (_) => DriverService()),
      ],
      child: MaterialApp(
        title: 'Uber-like App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      ),
    );
  }
}
