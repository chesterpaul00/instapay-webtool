import 'package:flutter/material.dart';

class ReusableTransactionTable extends StatelessWidget {
  final String title;
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final bool isLoading;
  final bool isEmpty;
  final int currentPage;
  final int totalPages;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;
  final VoidCallback? onExport;

  const ReusableTransactionTable({
    Key? key,
    required this.title,
    required this.columns,
    required this.rows,
    this.isLoading = false,
    this.isEmpty = false,
    this.currentPage = 1,
    this.totalPages = 1,
    this.onPreviousPage,
    this.onNextPage,
    this.onExport, required String emptyStateMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (isEmpty) {
      return Center(child: Text('No transactions found.'));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xff7b1113),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 30.0,
            headingRowColor: MaterialStateColor.resolveWith(
                  (states) => const Color(0xfff2f2f2),
            ),
            headingTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xff7b1113),
            ),
            dataRowColor: MaterialStateColor.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return const Color(0xfffdecec); // Highlight selected row
              }
              return const Color(0xffffffff); // Default row background
            }),
            dataTextStyle: const TextStyle(fontSize: 12, color: Colors.black87),
            columns: columns,
            rows: rows,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: onExport,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff7b1113),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: const Text('Export to CSV'),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: currentPage > 1 ? onPreviousPage : null,
                ),
                Text(
                  'Page $currentPage of $totalPages',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
