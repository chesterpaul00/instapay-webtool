import '../models/transaction_model.dart';

class InstapayFilter {
  final List<instapayModel> transactions;

  // Constructor takes a List<instapayModel> or a String (representing a filter condition)
  InstapayFilter(List<instapayModel> transactions) : transactions = transactions;

  // Alternatively, you can add a constructor that initializes with a filter string if needed
  InstapayFilter.fromString(String filterCode, List<instapayModel> transactions)
      : transactions = transactions.where((transaction) => transaction.reasonCode == filterCode).toList();

  // Filter by reasonCode
  List<instapayModel> filterByReasonCode(String code) {
    return transactions.where((transaction) => transaction.reasonCode == code).toList();
  }

  // Filter by transactionType
  List<instapayModel> filterByTransactionType(String type) {
    return transactions.where((transaction) => transaction.transactionType == type).toList();
  }

  // Filter by status
  List<instapayModel> filterByStatus(String status) {
    return transactions.where((transaction) => transaction.status == status).toList();
  }

  // Combine multiple filters
  List<instapayModel> filterByMultipleConditions({
    String? reasonCode,
    String? transactionType,
    String? status,
  }) {
    return transactions.where((transaction) {
      bool matchReasonCode = reasonCode == null || transaction.reasonCode == reasonCode;
      bool matchTransactionType = transactionType == null || transaction.transactionType == transactionType;
      bool matchStatus = status == null || transaction.status == status;
      return matchReasonCode && matchTransactionType && matchStatus;
    }).toList();
  }
}
