import 'package:flutter/material.dart';

class CalendarButton extends StatelessWidget {
  final ValueChanged<DateTime?> onSelectDate;

  const CalendarButton({required this.onSelectDate, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2101),
        );
        onSelectDate(pickedDate);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff7b1113),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: const Icon(Icons.calendar_today, color: Colors.white),
    );
  }
}
