import 'package:flutter/material.dart';

class ReusableTable extends StatelessWidget {
  final bool isLoading;
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final String emptyMessage;
  final int currentPage;
  final int totalPages;
  final String title; // Accept title as a parameter
  final VoidCallback? onExport;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;

  const ReusableTable({
    Key? key,
    required this.isLoading,
    required this.columns,
    required this.rows,
    this.emptyMessage = 'No data available',
    this.currentPage = 1,
    this.totalPages = 1,
    this.title = 'Default Title', // Default title value
    this.onExport,
    this.onPreviousPage,
    this.onNextPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (rows.isEmpty) {
      return Center(child: Text(emptyMessage));
    }

    return Column(
      children: [
        // Dynamic title based on passed parameter
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            title, // Display the title dynamically based on the screen context
            textAlign: TextAlign.center, // Center-align the title
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        // The DataTable with dynamic content
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // Table background color
              borderRadius: BorderRadius.circular(12), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 5,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: DataTable(
              columns: columns,
              rows: rows,
              columnSpacing: 16, // Space between columns
              dataTextStyle: TextStyle(fontSize: 14, color: Colors.black), // Text color
              headingRowColor: MaterialStateProperty.all(Colors.grey[200]), // Header background color
              headingTextStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Header text color
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), // Rounded corners
                color: Colors.transparent, // Transparent so the container background is visible
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: onExport,
              child: const Text('Export to CSV'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff7b1113),
                foregroundColor: Colors.white, // Set the text color to white
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4, // Optional: button elevation for shadow effect
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: currentPage > 1 ? onPreviousPage : null,
                ),
                Text('Page $currentPage of $totalPages'),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: currentPage < totalPages ? onNextPage : null,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
