import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/button.dart';
import '../components/textformfield.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  bool passwordsMatch = true;
  bool visibility = true;
  bool isPress = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffefecf9),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 120.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(33),
                      decoration: BoxDecoration(
                        color: const Color(0xff216af9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        child: Image.asset(
                          "assets/home2.png",
                          height: 80,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(right: 74.0),
                      child: Text(
                        "Access your Account",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
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
                        // Validate the password field
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
                      backgroundColor: const Color(0xff216af9),
                      buttonTitle: const Text(
                        "Login",
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await _auth.signInWithEmailAndPassword(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                            );

                            // Navigate to HomeScreen if login is successful
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          } on FirebaseAuthException catch (e) {
                            // Handle authentication-related errors
                            String errorMessage =
                                "An error occurred during login. Please try again.";

                            if (e.code == 'user-not-found') {
                              errorMessage = "No user found with this email.";
                            } else if (e.code == 'wrong-password') {
                              errorMessage = "Incorrect password.";
                            }

                            _showErrorSnackbar(errorMessage);
                          } catch (e) {
                            // Handle other unexpected errors
                            _showErrorSnackbar(
                                "An unexpected error occurred. Please try again.");
                          }
                        }
                      },
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/logo_s.png',
                fit: BoxFit.contain,
                height: 32,
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: const Text('\t HealthWise'),
              ),
            ],
          ),

        ),
      ),
    );
  }
}

bool _isValidEmail(String email) {
  // Simple regex for a valid email format
  RegExp emailRegex =
  RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$");
  return emailRegex.hasMatch(email);
}
