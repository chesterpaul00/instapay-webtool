import 'package:flutter/material.dart';

class MultiDateSelector extends StatefulWidget {
  final Function(List<DateTime>) onSelectedDatesChanged;

  MultiDateSelector({required this.onSelectedDatesChanged});

  @override
  _MultiDateSelectorState createState() => _MultiDateSelectorState();
}

class _MultiDateSelectorState extends State<MultiDateSelector> {
  List<DateTime> _selectedDates = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2101),
            );
            if (selectedDate != null && !_selectedDates.contains(selectedDate)) {
              setState(() {
                _selectedDates.add(selectedDate);
              });
              widget.onSelectedDatesChanged(_selectedDates);
            }
          },
          child: Text('Select Date'),
        ),
        Wrap(
          children: _selectedDates.map((date) {
            return Chip(
              label: Text('${date.toLocal()}'),
              onDeleted: () {
                setState(() {
                  _selectedDates.remove(date);
                });
                widget.onSelectedDatesChanged(_selectedDates);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
