import 'package:flutter/material.dart';
import 'package:instapay_webtool_provider_test/models/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String _username = '';
  List<instapayModel> _transactions = [];
  List<instapayModel> _filteredTransactions = [];
  int _currentPage = 1;
  int _totalPages = 1;
  final int _itemsPerPage = 10;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String get username => _username;
  List<instapayModel> get transactions => _transactions;
  List<instapayModel> get filteredTransactions => _filteredTransactions;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;

  int get itemsPerPage => _itemsPerPage;

  set transactions(List<instapayModel> transactions) {
    _transactions = transactions;
    _filteredTransactions = transactions;
    _totalPages = (_filteredTransactions.length / _itemsPerPage).ceil();
    notifyListeners();
  }

  set filteredTransactions(List<instapayModel> transactions) {
    _filteredTransactions = transactions;
    _totalPages = (_filteredTransactions.length / _itemsPerPage).ceil();
    _currentPage = 1; // Reset to first page when filtering
    notifyListeners();
  }

  set currentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  set totalPages(int pages) {
    _totalPages = pages;
    notifyListeners();
  }

  Future<void> loadTransactions() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call or loading from database
    await Future.delayed(Duration(seconds: 2));
    // Replace with actual data fetching logic
    _transactions = await fetchTransactions();  // Example fetch method

    _isLoading = false;
    notifyListeners();
  }

  // Example of how you might fetch transactions from an API
  Future<List<instapayModel>> fetchTransactions() async {
    // Replace with real API fetching logic
    return [];  // Return an actual list of transactions
  }

  void searchTransactions(String query) {
    if (query.isEmpty) {
      _filteredTransactions = _transactions;
    } else {
      _filteredTransactions = _transactions
          .where((transaction) => transaction.instructionId.contains(query) || transaction.referenceId.contains(query))
          .toList();
    }
    _totalPages = (_filteredTransactions.length / _itemsPerPage).ceil();
    notifyListeners();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username') ?? 'Guest';
    _isAuthenticated = _username != 'Guest';
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('username');
    _isAuthenticated = false;
    _username = 'Guest';
    notifyListeners();
  }

  void filterByStatus(String status) {
    _filteredTransactions = _transactions
        .where((transaction) => transaction.status == status)
        .toList();
    _totalPages = (_filteredTransactions.length / _itemsPerPage).ceil();
    _currentPage = 1; // Reset to the first page after filtering
    notifyListeners();
  }

  void filterByMultipleConditions({required String transactionType, required String status}) {
    _filteredTransactions = _transactions
        .where((transaction) =>
    transaction.transactionType == transactionType && transaction.status == status)
        .toList();
    _totalPages = (_filteredTransactions.length / _itemsPerPage).ceil();
    _currentPage = 1; // Reset to the first page after filtering
    notifyListeners();
  }

  void filterByReasonCode(String reasonCode) {
    _filteredTransactions = _transactions
        .where((transaction) => transaction.reasonCode == reasonCode)
        .toList();
    _totalPages = (_filteredTransactions.length / _itemsPerPage).ceil();
    _currentPage = 1; // Reset to the first page after filtering
    notifyListeners();
  }

  void clearFilters() {
    _filteredTransactions = _transactions;
    _totalPages = (_filteredTransactions.length / _itemsPerPage).ceil();
    _currentPage = 1; // Reset to the first page after clearing filters
    notifyListeners();
  }

  void exportToCSV() {
    // Implement CSV export logic here
  }

  void setTransactions(List<instapayModel> transactions) {}

  void changePage(int i) {}
}
