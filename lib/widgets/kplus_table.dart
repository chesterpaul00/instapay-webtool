import 'package:flutter/material.dart';
import '../models/kPlus_model.dart';

class ReusableTransactionTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<KPlusModel> data; // List of KPlusModel
  final bool isLoading;
  final bool isEmpty;
  final int currentPage;
  final int totalPages;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;
  final VoidCallback? onExport;

  const ReusableTransactionTable({
    super.key,
    required this.columns,
    required this.data, // Pass KPlusModel data here
    this.isLoading = false,
    this.isEmpty = false,
    this.currentPage = 1,
    this.totalPages = 1,
    this.onPreviousPage,
    this.onNextPage,
    this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (isEmpty) {
      return Center(child: Text('No transactions found.'));
    }

    // Map KPlusModel data to DataRow for the table
    List<DataRow> rows = data.map((item) {
      return DataRow(cells: [
        DataCell(Text(item.trnId.toString())),
        DataCell(Text(item.trnType ?? '')),
        DataCell(Text(item.amount.toString())),
        DataCell(Text(item.status ?? '')),
        DataCell(Text(item.trnDate ?? '')),
        DataCell(Text(item.accountNumber ?? '')),
        DataCell(Text(item.refId ?? '')),
      ]);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
