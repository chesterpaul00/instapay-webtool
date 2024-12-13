import 'package:intl/intl.dart';

class DateFormatter {
  // Static method to format transaction date
  static String formatTransactionDate(String? date) {
    if (date == null || date.isEmpty) {
      return '-'; // Return a dash if no date is provided
    }

    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(parsedDate);
    } catch (e) {
      return '-'; // Return a dash if the date cannot be parsed
    }
  }
}
