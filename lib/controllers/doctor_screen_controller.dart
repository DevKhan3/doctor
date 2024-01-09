import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorScreenController {
  final CollectionReference appointments =
  FirebaseFirestore.instance.collection('Appointments');

  Stream<QuerySnapshot<Object?>> getAppointmentsStream(String doctorName) {
    return appointments
        .where('doctor_name', isEqualTo: doctorName)
        .snapshots();

}

  Future<void> deleteAppointment(String appointmentId) async {
    try {
      await appointments.doc(appointmentId).delete();
    } catch (e) {
      print('Error deleting appointment: $e');
      // Handle the error as needed
    }
  }
}
