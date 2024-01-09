import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:khannasir/screens/home_screen.dart';
import 'package:khannasir/components/button.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Heading
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 60),
            child: Text(
              'Welcome Here!!',
              style: TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          // Subheading
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 8),
            child: Text(
              'Book your appointment now with your doctor in HealthWise Clinics and Medicos.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.redAccent,
              ),
            ),
          ),
          // Image (centered)
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/Logo.png',
                height: 400,
                width: 400,
              ),
            ),
          ),
          // Button at the end
          Padding(
            padding: const EdgeInsets.all(20),
            child: isLoading
                ? SpinKitCircle(color: Colors.blue, size: 50.0)
                : ButtonWidget(
              backgroundColor: Colors.blue,
              buttonTitle: const Text(
                "Want to book an Appointment?",
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                setState(() {
                  isLoading = true;
                });

                Future.delayed(const Duration(seconds: 3), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
