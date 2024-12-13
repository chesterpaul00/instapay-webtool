import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

void showCalendarDialog(BuildContext context, Function(DateTime? singleDate, PickerDateRange? dateRange) onDateFilter) {
  DateRangePickerSelectionMode selectionMode = DateRangePickerSelectionMode.single;
  DateTime? selectedSingleDate;
  PickerDateRange? selectedRange;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: SizedBox(
              width: 450,
              height: 450,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Select Date(s)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Selection Mode:",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 70,
                          width: 120,
                          child: DropdownButtonFormField<DateRangePickerSelectionMode>(
                            value: selectionMode,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            ),
                            items: [
                              DropdownMenuItem(
                                value: DateRangePickerSelectionMode.single,
                                child: Text("Single Date"),
                              ),
                              DropdownMenuItem(
                                value: DateRangePickerSelectionMode.range,
                                child: Text("Date Range"),
                              ),
                            ],
                            isExpanded: true,
                            onChanged: (DateRangePickerSelectionMode? mode) {
                              if (mode != null) {
                                setState(() {
                                  selectionMode = mode;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SfDateRangePicker(
                      selectionMode: selectionMode,
                      initialSelectedDate: DateTime.now(),
                      initialSelectedRange: selectionMode == DateRangePickerSelectionMode.range
                          ? PickerDateRange(
                        DateTime.now(),
                        DateTime.now().add(Duration(days: 7)),
                      )
                          : null,
                      onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                        setState(() {
                          if (selectionMode == DateRangePickerSelectionMode.single) {
                            selectedSingleDate = args.value;
                          } else if (selectionMode == DateRangePickerSelectionMode.range) {
                            selectedRange = args.value;
                          }
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Close",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          onDateFilter(selectedSingleDate, selectedRange);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff7b1113),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Apply Filter",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
