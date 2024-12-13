import 'package:flutter/material.dart';

class SummaryTransactionsDialog extends StatelessWidget {
  final String transactionType,
      status,
      reasonCode,
      description,
      localInstrument,
      instructionId,
      transactionId,
      referenceId,
      senderBIC,
      senderName,
      senderAccount,
      amountCurrency,
      receivingBIC,
      receivingName,
      receivingAccount,
      transactionDateTime;

  const SummaryTransactionsDialog({
    super.key,
    required this.transactionType,
    required this.status,
    required this.reasonCode,
    required this.description,
    required this.localInstrument,
    required this.instructionId,
    required this.transactionId,
    required this.referenceId,
    required this.senderBIC,
    required this.senderName,
    required this.senderAccount,
    required this.amountCurrency,
    required this.receivingBIC,
    required this.receivingName,
    required this.receivingAccount,
    required this.transactionDateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          MouseRegion(
            onEnter: (_) => print("Mouse entered"), // Optional, just for debugging
            onExit: (_) => print("Mouse exited"),  // Optional, just for debugging
            child: Container(
              padding: EdgeInsets.fromLTRB(24.0, 5.0, 24.0, 5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  DataTable(
                    headingRowColor: MaterialStateColor.resolveWith(
                          (states) => Color(0xff7b1113),
                    ),
                    dataRowColor: MaterialStateColor.resolveWith(
                          (states) => Colors.white,
                    ),
                    columns: const [
                      DataColumn(
                        label: Text(
                          'TITLE',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Set color to 0xff7b1113
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'DATA',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Set color to 0xff7b1113
                          ),
                        ),
                      ),
                    ],
                    rows: [
                      DataRow(cells: [
                        const DataCell(Text("Transaction Type", style: TextStyle(color: Color(0xff7b1113)))),
                        DataCell(Text(transactionType, style: TextStyle(color: Color(0xff7b1113)))),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Status", style: TextStyle(color: Color(0xff7b1113)))),
                        DataCell(Text(status, style: TextStyle(color: Color(0xff7b1113)))),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Reason Code", style: TextStyle(color: Color(0xff7b1113)))),
                        DataCell(Text(reasonCode, style: TextStyle(color: Color(0xff7b1113)))),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Description", style: TextStyle(color: Color(0xff7b1113)))),
                        DataCell(Text(description, style: TextStyle(color: Color(0xff7b1113)))),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Local Instrument", style: TextStyle(color: Color(0xff7b1113)))),
                        DataCell(Text(localInstrument, style: TextStyle(color: Color(0xff7b1113)))),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Instruction ID", style: TextStyle(color: Color(0xff7b1113)))),
                        DataCell(Text(instructionId, style: TextStyle(color: Color(0xff7b1113)))),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Reference ID", style: TextStyle(color: Color(0xff7b1113)))),
                        DataCell(Text(referenceId, style: TextStyle(color: Color(0xff7b1113)))),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Sender BIC", style: TextStyle(color: Color(0xff7b1113)))),
                        DataCell(Text(senderBIC, style: TextStyle(color: Color(0xff7b1113)))),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Sender Account", style: TextStyle(color: Color(0xff7b1113)))),
                        DataCell(Text(senderAccount, style: TextStyle(color: Color(0xff7b1113)))),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Amount Currency", style: TextStyle(color: Color(0xff7b1113)))),
                        DataCell(Text(amountCurrency, style: TextStyle(color: Color(0xff7b1113)))),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Receiving BIC", style: TextStyle(color: Color(0xff7b1113)))),
                        DataCell(Text(receivingBIC, style: TextStyle(color: Color(0xff7b1113)))),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Receiving Name", style: TextStyle(color: Color(0xff7b1113)))),
                        DataCell(Text(receivingName, style: TextStyle(color: Color(0xff7b1113)))),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Receiving Account", style: TextStyle(color: Color(0xff7b1113)))),
                        DataCell(Text(receivingAccount, style: TextStyle(color: Color(0xff7b1113)))),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Transaction DateTime", style: TextStyle(color: Color(0xff7b1113)))),
                        DataCell(Text(transactionDateTime, style: TextStyle(color: Color(0xff7b1113)))),
                      ]),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0.0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 14.0,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.close, color: Color(0xff7b1113)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
