import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'dart:html' as html;
import '../services/api_services.dart';

class ExportInstapayTransactions {
  Future<void> downloadFile(
      BuildContext context,
      String startDate,
      String? endDate, // Make endDate optional
          {String? reasonCode, String? status, String? transactionType} // Named parameters
      ) async {
    try {
      // Use startDate as endDate if endDate is not provided
      endDate ??= startDate;

      // Fetch transactions based on provided dates
      final List transactions = await ApiService.fetchInstapay(startDate: startDate, endDate: endDate);

      // Filter transactions based on optional parameters
      final List filteredTransactions = transactions.where((transaction) {
        bool matchesReasonCode = reasonCode == null || transaction.reasonCode == reasonCode;
        bool matchesStatus = status == null || status.contains(transaction.status);
        bool matchesTransType = transactionType == null || transaction.transactionType == transactionType;
        return matchesReasonCode && matchesStatus && matchesTransType;
      }).toList();

      // Notify if no transactions were found
      if (filteredTransactions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No transactions found for the given criteria: $status, $reasonCode'),
          ),
        );
        return;
      }

      final excel = Excel.createExcel();
      final sheet = excel['Sheet1'];

      // Add headers to the Excel sheet
      sheet
        ..cell(CellIndex.indexByString("A1")).value = 'Transaction Datetime' as CellValue?
        ..cell(CellIndex.indexByString("B1")).value = 'Transaction Type' as CellValue?
        ..cell(CellIndex.indexByString("C1")).value = 'Status' as CellValue?
        ..cell(CellIndex.indexByString("D1")).value = 'Reference Id' as CellValue?
        ..cell(CellIndex.indexByString("E1")).value = 'Instruction Id' as CellValue?
        ..cell(CellIndex.indexByString("F1")).value = 'Reason Code' as CellValue?
        ..cell(CellIndex.indexByString("G1")).value = 'Local Instrument' as CellValue?
        ..cell(CellIndex.indexByString("H1")).value = 'Amount' as CellValue?;

      int row = 2;
      for (var transaction in filteredTransactions) {
        DateTime parsedDatetime = DateTime.parse(transaction.transactionDatetime);
        String formattedDatetime = DateFormat('yyyy MMM dd hh:mm a').format(parsedDatetime);

        // Populate data rows in the Excel sheet
        sheet
          ..cell(CellIndex.indexByString("A$row")).value = formattedDatetime as CellValue?
          ..cell(CellIndex.indexByString("B$row")).value = transaction.transactionType
          ..cell(CellIndex.indexByString("C$row")).value = transaction.status
          ..cell(CellIndex.indexByString("D$row")).value = transaction.referenceId
          ..cell(CellIndex.indexByString("E$row")).value = transaction.instructionId
          ..cell(CellIndex.indexByString("F$row")).value = transaction.reasonCode
          ..cell(CellIndex.indexByString("G$row")).value = transaction.localInstrument
          ..cell(CellIndex.indexByString("H$row")).value = transaction.amount;

        row++;
      }

      final bytes = excel.encode();
      if (bytes != null) {
        final blob = html.Blob([bytes]);
        final downloadUrl = html.Url.createObjectUrlFromBlob(blob);

        // Create dynamic filename based on provided parameters
        String filename = 'transactions';
        if (reasonCode != null) {
          filename += '_reason-$reasonCode';
        }
        if (status != null) {
          filename += '_status-$status';
        }
        if (transactionType != null) {
          filename += '_type-$transactionType';
        }
        filename += '.xlsx'; // Append file extension

        // Create an anchor element and trigger the download
        final anchor = html.AnchorElement(href: downloadUrl)
          ..setAttribute('download', filename) // Dynamic name of the downloaded file
          ..click(); // Simulate a click to download the file

        html.Url.revokeObjectUrl(downloadUrl); // Clean up the URL
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to generate the Excel file.'),
          ),
        );
      }
    } catch (e) {
      print("Error downloading file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while downloading the transactions report: $e'),
        ),
      );
    }
  }
}