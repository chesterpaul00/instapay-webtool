import 'package:instapay_webtool_provider_test/models/transaction_model_prod.dart';


class InstapayFilterProd {
  final List<instapayModelProd> transactions;

  // Constructor takes a List<instapayModel> or a String (representing a filter condition)
  InstapayFilterProd(this.transactions);

  // Alternatively, you can add a constructor that initializes with a filter string if needed
  InstapayFilterProd.fromString(String filterCode, List<instapayModelProd> transactions)
      : transactions = transactions.where((transaction) => transaction.reasonCode == filterCode).toList();

  // Filter by reasonCode
  List<instapayModelProd> filterByReasonCode(String code) {
    return transactions.where((transaction) => transaction.reasonCode == code).toList();
  }

  // Filter by transactionType
  List<instapayModelProd> filterByTransactionType(String type) {
    return transactions.where((transaction) => transaction.transactionType == type).toList();
  }

  // Filter by status
  List<instapayModelProd> filterByStatus(String status) {
    return transactions.where((transaction) => transaction.status == status).toList();
  }

  // Combine multiple filters
  List<instapayModelProd> filterByMultipleConditions({
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
