// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:khannasir/screens/home_screen_body.dart';
import '../screens/Doctor_login.dart';
import '../components/appbar.dart'; // Import the custom AppBar

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
          onLoginPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const doctor_login()),
            );
          },
        ), // Use the custom AppBar
        body: const HomeScreenBody(),
      ),
    );
  }
}
