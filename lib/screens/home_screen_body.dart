// screens/home/home_screen_body.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/doctor_items.dart';
import '../components/date_time_picker.dart';
import '../components/dropdown_menu.dart';
import 'package:khannasir/components/button.dart';

class HomeScreenBody extends StatefulWidget {
  const HomeScreenBody({Key? key}) : super(key: key);

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  final doctors = FirebaseFirestore.instance.collection('Doctor_login');
  final appointment = FirebaseFirestore.instance.collection('Appointments');

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String _selectedSpecialist = '';
  DateTime? _selectedDate;

  final Map<String, bool> _fieldValidation = {
    'first_name': true,
    'last_name': true,
    'email': true,
    'phone': true,
    'specialist': true,
    'date_time': true,
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              const SizedBox(height: 16,),
              Text('Welcome to HealthWise',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.blue
              ),),
              const SizedBox(height: 16,),
              Text('Book your appointment now.',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.red
                ),),
              const SizedBox(height: 16,),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'Your First Name${_fieldValidation['first_name'] == false ? '*' : ''}',
                  labelStyle: TextStyle(color: _fieldValidation['first_name'] == false ? Colors.red : null),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Your Last Name${_fieldValidation['last_name'] == false ? '*' : ''}',
                  labelStyle: TextStyle(color: _fieldValidation['last_name'] == false ? Colors.red : null),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Enter Your Email${_fieldValidation['email'] == false ? '*' : ''}',
                  labelStyle: TextStyle(color: _fieldValidation['email'] == false ? Colors.red : null),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Enter Phone number${_fieldValidation['phone'] == false ? '*' : ''}',
                  labelStyle: TextStyle(color: _fieldValidation['phone'] == false ? Colors.red : null),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Your Doctor',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        FutureBuilder<List<DoctorItem>>(
                          future: doctor(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Text('No doctors available');
                            } else {
                              return CustomDropdownMenu<DoctorItem>(
                                initialValue: snapshot.data!.first,
                                onSelected: (DoctorItem? value) {
                                  setState(() {
                                    _selectedSpecialist = value!.name;
                                  });
                                },
                                itemBuilder: (BuildContext context) {
                                  return snapshot.data!.map<DropdownMenuItem<DoctorItem>>((DoctorItem item) {
                                    return DropdownMenuItem<DoctorItem>(
                                      value: item,
                                      child: Text('${item.name} - ${item.designation}'),
                                    );
                                  }).toList();
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 16,),
                  const Text(
                    'Select Your Doctor',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Expanded(

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        DateTimePicker(
                          onSelectedDate: (date) {
                            setState(() {
                              _selectedDate = date;
                            });
                          },
                          selectedDate: _selectedDate,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 50,
                  child: ButtonWidget(
                      backgroundColor: Colors.blue,
                      buttonTitle: const Text(
                        "Book Appointment",
                        style: TextStyle(fontSize: 18),
                      ),
                    onPressed: () async {
                      if (_validateFields()) {
                        appointment.doc().set({
                          'first_name': _firstNameController.text,
                          'last_name': _lastNameController.text,
                          'email': _emailController.text,
                          'phone': double.parse(_phoneController.text),
                          'doctor_name': _selectedSpecialist,
                          'date_time': _selectedDate,
                        }).then((value) {
                          print('Appointment booked successfully');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Appointment Booked Successfully.'),
                              duration: Duration(seconds: 3),
                              backgroundColor: Colors.green,
                            ),
                          );
                          // Reset form
                          _resetForm();
                        }).onError((error, stackTrace) {
                          print('Error booking appointment: $error');
                          print(stackTrace);
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<DoctorItem>> doctor() async {
    QuerySnapshot querySnapshot = await doctors.get();
    List<DoctorItem> updatedList = [];

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> doctorData = doc.data() as Map<String, dynamic>;
      updatedList.add(DoctorItem(name: doctorData['Doctor_name'], designation: doctorData['designation']));
    }

    // Return the updated list
    return updatedList;
  }

  // Function to validate fields and display error messages
  bool _validateFields() {
    bool isValid = true;

    if (_firstNameController.text.isEmpty) {
      isValid = false;
      _showError('Please enter your first name', 'first_name', _firstNameController);
    } else {
      _resetError('first_name');
    }

    if (_lastNameController.text.isEmpty) {
      isValid = false;
      _showError('Please enter your last name', 'last_name', _lastNameController);
    } else {
      _resetError('last_name');
    }

    if (_emailController.text.isEmpty || !_isValidEmail(_emailController.text)) {
      isValid = false;
      _showError('Please enter a valid email address', 'email', _emailController);
    } else {
      _resetError('email');
    }

    if (_phoneController.text.isEmpty || _phoneController.text.length != 11) {
      isValid = false;
      _showError('Please enter a valid 11-digit phone number', 'phone', _phoneController);
    } else {
      _resetError('phone');
    }

    if (_selectedSpecialist.isEmpty) {
      isValid = false;
      _showError('Please select a specialist', 'specialist', _firstNameController);
    } else {
      _resetError('specialist');
    }

    if (_selectedDate == null) {
      isValid = false;
      _showError('Please select a date and time', 'date_time', _emailController);
    } else {
      _resetError('date_time');
    }

    setState(() {});

    return isValid;
  }

  // Function to display error message below the field
  void _showError(String errorMessage, String fieldName, TextEditingController controller) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
          if (_fieldValidation[fieldName] == true) ...{
            const Text(
              '*',
              style: TextStyle(color: Colors.red),
            ),
          },
        ],
      ),
      backgroundColor: Colors.red,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    _fieldValidation[fieldName] = true;
  }

  // Function to reset the form
  void _resetForm() {
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _selectedSpecialist = '';
    _selectedDate = null;
    _fieldValidation.forEach((key, value) {
      _fieldValidation[key] = true;
    });
  }

  // Function to reset the error status for a field
  void _resetError(String fieldName) {
    _fieldValidation[fieldName] = true;
  }

  // Function to validate email format
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
    );
    return emailRegex.hasMatch(email);
  }
}
