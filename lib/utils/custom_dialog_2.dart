import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDialog2 extends StatelessWidget {
  final String trnType,
      status,
      trnDate,
      lastUpdate,
      accountNumber,
      refId,
      url,
      source,
      target,
      sourceStatus,
      sourceTarget,
      targetCid,
      sourceCid,

  ///paymentDetails,
  ///Request

      pReferenceNumber,
      pDebitAccount,
      pDebitBranchCode,
      pTargetBankCode,
      pTargetBankName,
      pTargetAccountNumber,
      pIBFTreference,
      pDescription,
      pCurrency,
      pResponseCode,
      pDebitAccountName,
      pCreditAccount,
      pTransferReference,
      pCoreReference,
      pResponseDebitBranchCode,
      pDebitNarrative,
      pARNumber,
      pAdminFee;

  ///Response

  final double bankFee,
      totalFee,
      amount,
      pTransactionAmount,
      agentFee,
      pDebitAvailBalance,
      pAmount;

  final int cid, id, trnId, pAvailableBalance;

  const CustomDialog2({
    super.key,
    required this.id,
    required this.trnId,
    this.trnType = '',
    required this.amount,
    this.status = '',
    this.trnDate = '',
    this.lastUpdate = '',
    this.accountNumber = '',
    required this.cid,
    this.refId = '',
    this.url = '',
    this.source = '',
    this.target = '',
    this.sourceStatus = '',
    this.sourceTarget = '',
    required this.totalFee,
    required this.agentFee,
    required this.bankFee,
    this.targetCid = '',
    this.sourceCid = '',
    // this.paymentDetails,
    required this.pAdminFee,
    this.pTransactionAmount = 0.0,
    required this.pCurrency,
    required this.pReferenceNumber,
    required this.pAvailableBalance,
    required this.pDebitAccount,
    required this.pDebitBranchCode,
    required this.pTargetBankCode,
    required this.pTargetBankName,
    required this.pTargetAccountNumber,
    required this.pIBFTreference,
    required this.pDescription,
    required this.pAmount,
    required this.pResponseCode,
    required this.pDebitAccountName,
    required this.pCreditAccount,
    required this.pTransferReference,
    required this.pCoreReference,
    required this.pResponseDebitBranchCode,
    required this.pDebitAvailBalance,
    required this.pDebitNarrative,
    required this.pARNumber,
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
            Container(
              width: 700,
              padding: const EdgeInsets.only(
                top: 18.0,
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 0.0,
                      offset: Offset(0.0, 0.0),
                    ),
                  ]),
              child: SelectionArea(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: const Column(
                        children: [
                          // Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Center(
                              child: Text(
                                'TRANSACTION DETAILS',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          // Expanded(child: Divider()),
                        ],
                      ),
                    ),
                    DataTable(
                      //  decoration: const BoxDecoration(color: Colors.white),
                      //  border: TableBorder.all(),
                      columns: const [
                        DataColumn(
                          label: Text(
                            '',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            '',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      rows: [
                        DataRow(cells: [
                          const DataCell(Text("Transaction ID")),
                          DataCell(Text('$trnId')),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text("Transaction Type")),
                          DataCell(Text(trnType)),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text("Amount")),
                          DataCell(Text('$amount')),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text("Status")),
                          DataCell(Text(status)),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text("Transaction Date")),
                          DataCell(Text(trnDate)),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text("Last Update")),
                          DataCell(Text(lastUpdate)),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text("Account Number")),
                          DataCell(Text(accountNumber)),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text("CID")),
                          DataCell(Text('$cid')),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text("Reference Id")),
                          DataCell(Text(refId)),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text("URL")),
                          DataCell(Text(url)),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text("Source")),
                          DataCell(Text(source)),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text("Target")),
                          DataCell(Text(target)),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text("Source Status")),
                          DataCell(Text(sourceStatus)),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text("Source Target")),
                          DataCell(Text(sourceTarget)),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text("Total Fee")),
                          DataCell(Text('$totalFee')),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text("Agent Fee")),
                          DataCell(Text("$agentFee")),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text("Bank Fee")),
                          DataCell(Text("$bankFee")),
                        ]),
                        // const DataRow(cells: [
                        //   DataCell(Text(
                        //     "PAYMENT DETAILS",
                        //     style: TextStyle(fontWeight: FontWeight.bold),
                        //   )),
                        //   DataCell(Text('')),
                        // ]),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: const Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'PAYMENT DETAILS',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: const Column(
                        children: [
                          // Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Center(
                              child: Text(
                                'REQUEST',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          // Expanded(child: Divider()),
                        ],
                      ),
                    ),
                    DataTable(columns: const [
                      DataColumn(
                        label: Text(
                          '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ], rows: [
                      DataRow(cells: [
                        const DataCell(Text("Reference Number")),
                        DataCell(Text(pReferenceNumber)),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Debit Account")),
                        DataCell(Text(pDebitAccount)),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Debit Branch Code")),
                        DataCell(Text(pDebitBranchCode)),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Target Bank Code")),
                        DataCell(Text(pTargetBankCode)),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Target Bank Name")),
                        DataCell(Text(pTargetBankName)),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Target Account Number")),
                        DataCell(Text(pTargetAccountNumber)),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Instruction ID")),
                        DataCell(Text(pIBFTreference)),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Description")),
                        DataCell(Text(pDescription)),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Currency")),
                        DataCell(Text(pCurrency)),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Amount")),
                        DataCell(Text(pAdminFee)),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Admin Fee")),
                        DataCell(Text(pAdminFee)),
                      ]),
                    ]),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: const Column(
                        children: [
                          // Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Center(
                              child: Text(
                                'RESPONSE',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          // Expanded(child: Divider()),
                        ],
                      ),
                    ),
                    DataTable(columns: const [
                      DataColumn(
                        label: Text(
                          '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ], rows: [
                      DataRow(cells: [
                        const DataCell(Text("Response Code")),
                        DataCell(Text(pResponseCode)),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Reference Number")),
                        DataCell(Text(pReferenceNumber)),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Debit Account")),
                        DataCell(Text(pDebitAccount)),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Debit Account Name")),
                        DataCell(Text(pDebitAccountName)),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Credit Account")),
                        DataCell(Text(pCreditAccount)),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Amount")),
                        DataCell(Text(pAmount.toString())),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Admin Fee")),
                        DataCell(Text(pAdminFee)),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Transfer Reference")),
                        DataCell(Text(pTransferReference)),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Core Reference")),
                        DataCell(Text(pCoreReference)),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Debit BranchCode")),
                        DataCell(Text(pResponseDebitBranchCode)),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Debit Avail Balance")),
                        DataCell(
                          Text(pDebitAvailBalance.toString()),
                        )
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Debit Narrative")),
                        DataCell(Text(pDebitNarrative)),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("AR Number")),
                        DataCell(Text(pARNumber)),
                      ]),
                    ]),
                    InkWell(
                      child: Container(
                        width: 700,
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16.0),
                              bottomRight: Radius.circular(16.0)),
                        ),
                        child: const Text(
                          "REVERSE",
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: -0.0,
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
        ));
  }
}