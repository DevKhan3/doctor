import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/button.dart';
import '../components/textformfield.dart';
import '../screens/Doctors_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khannasir/components/appbar.dart';

class doctor_login extends StatefulWidget {
  const doctor_login({Key? key}) : super(key: key);

  @override
  State<doctor_login> createState() => _doctor_loginState();
}

class _doctor_loginState extends State<doctor_login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final doctor = FirebaseFirestore.instance.collection('Doctor_login');
  String doctor_name = '';
  bool visibility = true;
  List<Map<String, dynamic>> doctorDataList = [];
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 120.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(33),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        child: Image.asset(
                          "assets/logo_s.png",
                          height: 80,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "HealthWise",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Login to your Account (Only for Doctors)",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormFieldWidget(
                      controller: _emailController,
                      prefixIcon: Icons.email,
                      hintText: "Email",
                      labelText: "Email",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your Email';
                        }
                        if (!_isValidEmail(value)) {
                          return 'Enter valid email Format!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormFieldWidget(
                      controller: _passwordController,
                      prefixIcon: Icons.lock,
                      hintText: "Enter your Password",
                      labelText: "Password",
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            visibility = !visibility;
                          });
                        },
                        child: Icon(
                          visibility
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: visibility
                              ? Colors.black
                              : Colors.grey.shade400,
                        ),
                      ),
                      obscure: visibility,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ButtonWidget(
                      backgroundColor: Colors.blue,
                      buttonTitle: const Text(
                        "Login",
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // If form is valid, proceed with login
                          _login();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _login() {
    // Retrieve entered email and password from the form
    String enteredEmail = _emailController.text;
    String enteredPassword = _passwordController.text;

    // Perform your login logic here
    // Retrieve data from Firestore
    doctor.get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        // Save data to variable
        Map<String, dynamic> doctorData = doc.data() as Map<String, dynamic>;
        doctorDataList.add(doctorData);
      }

      // Check if login is successful
      bool loginSuccess = _checkLoginSuccess(enteredEmail, enteredPassword);

      if (loginSuccess) {
        // Show success snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        // Update doctor_name and navigate to doctor_screen
        _updateDoctorName();
      } else {
        // Show error snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid credentials. Please try again.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    });
  }

  void _updateDoctorName() {
    for (var doctorData in doctorDataList) {
      String email = doctorData['email'];
      String password = doctorData['password'];
      String doctorNames = doctorData['Doctor_name'];

      if (_emailController.text == email && _passwordController.text == password) {
        setState(() {
          doctor_name = doctorNames;
        });

        // Navigate to doctor_screen with updated doctor_name
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorScreen(doctorName: doctor_name),
          ),
        );

        // Reset form
        _resetForm();
        break;
      }
    }
  }

  bool _isValidEmail(String email) {
    RegExp emailRegex =
    RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$");
    return emailRegex.hasMatch(email);
  }

  bool _checkLoginSuccess(String enteredEmail, String enteredPassword) {
    for (var doctorData in doctorDataList) {
      String email = doctorData['email'];
      String password = doctorData['password'];
      String doctorNames = doctorData['Doctor_name'];

      if (enteredEmail == email && enteredPassword == password) {

        return true; // Match found, login successful
      }
    }
    return false; // No matching credentials found
  }

  void _resetForm() {
    // Reset form logic here
    _formKey.currentState!.reset();
  }
}
