import 'package:flutter/material.dart';
import '../components/appbar.dart';
import '../controllers/doctor_screen_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khannasir/screens/adddoctor.dart';

class DoctorScreen extends StatefulWidget {
  final String doctorName;

  const DoctorScreen({Key? key, required this.doctorName}) : super(key: key);

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  final DoctorScreenController _controller = DoctorScreenController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
          onAddDoctorPressed: () {
            Navigator.push(context,
            MaterialPageRoute(builder: (context)=>const add_doctor()));
          },
        ),
        body: StreamBuilder<QuerySnapshot>(

          stream: _controller.getAppointmentsStream(widget.doctorName),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // Display the list of appointments
            final appointmentsList = snapshot.data?.docs ?? [];

            return SingleChildScrollView(

              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SizedBox(height: 25,),
                  Text('Welcome '+ widget.doctorName+".",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,

                  ),),
                  SizedBox(height: 25,),
                  DataTable(
                    columnSpacing: 20, // Adjust this value as needed
                    columns: const [
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Details')),
                    ],
                    rows: appointmentsList.map<DataRow>((appointmentData) {
                      final data = appointmentData.data() as Map<String, dynamic>;
                      final appointmentId = appointmentData.id; // Extract document ID

                      return DataRow(
                        cells: [
                          DataCell(Text("${data['first_name']} ${data['last_name']}")),
                          DataCell(Text(data['email'].toString())),
                          DataCell(
                            ElevatedButton(
                              onPressed: () {
                                showDetailsPopup(data, appointmentId);
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all(Colors.blue),
                              ),
                              child: const Text('Details'),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate(); // Assuming 'timestamp' is of type Timestamp
    String formattedDate =
        '${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
    return formattedDate;
  }

  void showDetailsPopup(Map<String, dynamic> data, String appointmentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Details for ${data['first_name']}'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('First Name: ${data['first_name']}'),
              Text('Last Name: ${data['last_name']}'),
              Text('Email: ${data['email']}'),
              Text('Phone: ${data['phone'].toString()}'),
              Text('Time: ${formatTimestamp(data['date_time'])}'),
              // Add more details as needed
            ],
          ),
          actions: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the popup
                  },
                  child: const Text('Close'),
                ),
                TextButton(
                  onPressed: () {
                    _deleteAppointment(appointmentId);
                    Navigator.of(context).pop(); // Close the popup
                  },
                  child: const Text(
                    'Delete Appointment',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAppointment(String appointmentId) async {
    await _controller.deleteAppointment(appointmentId);
  }
}
