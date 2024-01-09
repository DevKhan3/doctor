// components/date_time_picker.dart
import 'package:flutter/material.dart';

class DateTimePicker extends StatelessWidget {
  final Function(DateTime?) onSelectedDate;
  final DateTime? selectedDate;

  const DateTimePicker({
    Key? key,
    required this.onSelectedDate,
    required this.selectedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        InkWell(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null) {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (pickedTime != null) {
                DateTime selectedDateTime = DateTime(
                  pickedDate.year,
                  pickedDate.month,
                  pickedDate.day,
                  pickedTime.hour,
                  pickedTime.minute,
                );
                onSelectedDate(selectedDateTime);
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              selectedDate == null
                  ? 'Select Date and Time'
                  : '${'${selectedDate?.toLocal()}'.split(' ')[0]} ${selectedDate?.toLocal().hour}:${selectedDate?.toLocal().minute}',
            ),
          ),
        ),
      ],
    );
  }
}
