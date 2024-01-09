
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khannasir/components/appbar.dart';
import '../components/button.dart';
import '../components/textformfield.dart';

class add_doctor extends StatefulWidget {
  const add_doctor({Key? key}) : super(key: key);

  @override
  State<add_doctor> createState() => _add_doctorState();
}

class _add_doctorState extends State<add_doctor> {
  final doctor = FirebaseFirestore.instance.collection('Doctor_login');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  bool passwordsMatch = true;
  bool visibility = true;
  bool isPress = false;

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 78.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(33),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(child: Image.asset("assets/logo_s.png",height: 80,)),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Add Doctor Here",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormFieldWidget(
                      prefixIcon: Icons.person,
                      hintText: "Enter Doctor's Name",
                      labelText: "Doctor Name",
                      controller: _userNameController,
                    ),
                    const SizedBox(height: 20),
                    TextFormFieldWidget(
                      controller: _emailController,
                      prefixIcon: Icons.email,
                      hintText: "someone@mail.com",
                      labelText: "Doctor's Email",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your Email';
                        }
                        if (!_isValidEmail(value)) {
                          return 'Enter a valid email Format!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormFieldWidget(
                      controller: _designationController,
                      prefixIcon: Icons.local_hospital_rounded,
                      hintText: "Child Specialist",
                      labelText: "Doctor's Specialization",
                    ),
                    const SizedBox(height: 20),
                    TextFormFieldWidget(
                      controller: _passwordController,
                      prefixIcon: Icons.lock,
                      hintText: "Select your Password",
                      labelText: "Password",
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            visibility = !visibility;
                          });
                        },
                        child: Icon(
                          visibility ? Icons.visibility : Icons.visibility_off,
                          color:
                          visibility ? Colors.black : Colors.grey.shade400,
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
                    TextFormFieldWidget(
                      controller: _confirmPasswordController,
                      prefixIcon: Icons.lock,
                      hintText: "Confirm Password",
                      labelText: "Confirm Password",
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            visibility = !visibility;
                          });
                        },
                        child: Icon(
                          visibility ? Icons.visibility : Icons.visibility_off,
                          color:
                          visibility ? Colors.black : Colors.grey.shade400,
                        ),
                      ),
                      obscure: visibility,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Confirm Password is required';
                        } else if (value != _passwordController.text) {
                          passwordsMatch = false;
                          return 'Passwords do not match';
                        } else {
                          passwordsMatch = true;
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: passwordsMatch ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ButtonWidget(
                      backgroundColor: const Color(0xff216af9),
                      buttonTitle: const Text(
                        "Add Doctor",
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await _addDoctor();
                        }
                      },
                    ),
                    const SizedBox(height: 60,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addDoctor() async {
    try {
      final existingDoctor = await doctor
          .where('Doctor_name', isEqualTo: _userNameController.text)
          .get();

      final existingEmail = await doctor
          .where('email', isEqualTo: _emailController.text)
          .get();

      if (existingDoctor.docs.isNotEmpty || existingEmail.docs.isNotEmpty) {
        // Doctor with the same name or email already exists
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Doctor Already Exists'),
            duration: Duration(seconds: 3),
            backgroundColor:Colors.red, // Default to red if no color provided
          ),
        );
        return;
      }

      // Doctor doesn't exist, add a new one
      await doctor.add({
        'Doctor_name': _userNameController.text,
        'designation': _designationController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Doctor added Successfully.'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );

      _resetForm();
    } on FirebaseException catch (e) {
      if (e.code == 'weak-password') {
        _showErrorSnackbar('The password provided is too weak.');
      } else {
        _showErrorSnackbar('Error: ${e.message}');
      }
    } catch (e) {
      _showErrorSnackbar('Error: $e');
    }
  }

  void _resetForm() {
    _emailController.clear();
    _designationController.clear();
    _userNameController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  bool _isValidEmail(String email) {
    // Simple regex for a valid email format
    RegExp emailRegex =
    RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$");
    return emailRegex.hasMatch(email);
  }
}
