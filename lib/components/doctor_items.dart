// components/doctor_items.dart

class DoctorItem {
  final String name;
  final String designation;

  DoctorItem({required this.name, required this.designation});

  // Factory constructor to handle null values
  factory DoctorItem.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return DoctorItem(name: 'Unknown', designation: 'Unknown');
    }
    return DoctorItem(
      name: map['name'] ?? 'Unknown',
      designation: map['designation'] ?? 'Unknown',
    );
  }
}
