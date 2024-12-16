// ignore_for_file: unused_field, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:instapay_webtool_provider_test/utils/date_formatter.dart';
import 'package:instapay_webtool_provider_test/widgets/summary_card_clear.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../models/transaction_model.dart';
import '../services/api_services.dart';
import '../utils/calendar_dialog.dart';
import '../utils/filtration.dart';
import '../widgets/custom_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/summary_cards.dart';
import '../widgets/summary_transactions_dialog.dart';
import '../widgets/transaction_table.dart';
import 'dashboard_screen_prod.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<instapayModel> _users = [];
  List<instapayModel> _transactions = [];
  final _allTransactions = <instapayModel>[]; // All transactions
  List<instapayModel> _filteredTransactions = [];
  bool _isLoading = true;
  final bool _isAuthenticated = false;
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  int _totalPages = 1;
  String _username = '';
  final int _techCount = 0;
  late InstapayFilter _instapayFilter;
  String? startDate;
  String? endDate;
  String? _currentFilter;

  @override
  void initState() {
    super.initState();
    _loadCurrentTransactions();
    _loadUsername();
    _instapayFilter = InstapayFilter(_transactions);
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'User';
    });
  }

  void resetTransactions() {
    setState(() {
      // Reset any filters (e.g., if you are using filters as variables, reset them)
      _currentFilter = null; // Example: Resetting a filter variable
      _transactions.clear(); // Example: Clearing any existing transaction list

      // Reload or fetch the default transactions (this can vary depending on your logic)
      _loadCurrentTransactions(); // Assuming _loadTransactions is the method to reload data
    });
  }

  // New reusable fetch method
  Future<void> _fetchTransactions({required String startDate, required String endDate}) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final transactions = await ApiService.fetchInstapay(
        startDate: startDate,
        endDate: endDate,
      );
      _processTransactions(transactions);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError('Error loading transactions: $e');
    }
  }

  // Load transactions with a specified range
  Future<void> _loadTransactions() async {
    final now = DateTime.now();
    final start = DateTime(2023, 9, 1);
    await _fetchTransactions(
      startDate: start.toIso8601String(),
      endDate: now.toIso8601String(),
    );
  }

  // Load current day's transactions
  Future<void> _loadCurrentTransactions() async {
    final now = DateTime.now();
    await _fetchTransactions(
      startDate: now.toIso8601String(),
      endDate: now.toIso8601String(),
    );
  }

  void _processTransactions(List<instapayModel> transactions) {
    transactions.sort((a, b) {
      DateTime dateA = DateTime.parse(a.transactionDate);
      DateTime dateB = DateTime.parse(b.transactionDate);
      return dateB.compareTo(dateA);
    });

    setState(() {
      _transactions = transactions;
      _filteredTransactions = transactions;
      _allTransactions.addAll(transactions);
      _isLoading = false;
      _totalPages = (transactions.length / _itemsPerPage).ceil();
    });
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  List<instapayModel> getPaginatedTransactions() {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    return _filteredTransactions.skip(startIndex).take(_itemsPerPage).toList();
  }

  void _changePage(int newPage) {
    setState(() {
      _currentPage = newPage;
    });
  }

  void _filterTransactionsByDate(DateTime? singleDate, PickerDateRange? dateRange) {
    setState(() {
      if (singleDate != null) {
        // Filter transactions by single date
        _filteredTransactions = _transactions.where((transaction) {
          final DateTime transactionDate = DateTime.parse(transaction.transactionDate);
          return transactionDate.year == singleDate.year &&
              transactionDate.month == singleDate.month &&
              transactionDate.day == singleDate.day;
        }).toList();
      } else if (dateRange != null) {
        // Filter transactions by date range
        _filteredTransactions = _transactions.where((transaction) {
          final DateTime transactionDate = DateTime.parse(transaction.transactionDate);
          return transactionDate.isAfter(dateRange.startDate!) &&
              transactionDate.isBefore(dateRange.endDate!);
        }).toList();
      } else {
        // If no filter applied, reset to show all transactions
        _filteredTransactions = List.from(_transactions);
      }

      // Sort transactions in ascending order by date
      _filteredTransactions.sort((a, b) {
        final DateTime dateA = DateTime.parse(a.transactionDate);
        final DateTime dateB = DateTime.parse(b.transactionDate);
        return dateA.compareTo(dateB);
      });

      _currentPage = 1; // Reset to the first page after filtering
      _totalPages = (_filteredTransactions.length / _itemsPerPage).ceil(); // Recalculate total pages
    });
  }

  void _searchTransactions(String filter) {
    setState(() {
      if (filter.isEmpty) {
        _filteredTransactions = _transactions; // Reset to all transactions
      } else {
        _filteredTransactions = _transactions.where((transaction) {
          return transaction.referenceId.startsWith(filter) ||
              transaction.instructionId.startsWith(filter);
        }).toList();
      }
      _currentPage = 1;
      _totalPages = (_filteredTransactions.length / _itemsPerPage).ceil();
    });
  }

  Widget _buildSummaryCards() {
    return Center(
      child: SizedBox(
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 15.0,
          runSpacing: 20.0,
          children: [
            // All Transactions button
            SummaryButton(
              icon: Icons.folder,
              title: 'All Transactions',
              count: _transactions.length, // Count of all transactions
              color: const Color(0xff7b1113),
              onTap: () {
                setState(() {
                  _loadTransactions();
                });
              },
            ),

            // All Success button
            SummaryButton(
              icon: Icons.check,
              title: 'All Success',
              count: _filteredTransactions
                  .where((transaction) => transaction.status == "SUCCESS")
                  .length, // Count of success transactions
              color: const Color(0xff7b1113),
              onTap: () {
                setState(() {
                  _filteredTransactions = _transactions
                      .where((transaction) => transaction.status == "SUCCESS")
                      .toList();
                  _currentPage = 1;
                  _totalPages =
                      (_filteredTransactions.length / _itemsPerPage).ceil();
                });
              },
            ),

            // All Failed button
            SummaryButton(
              icon: Icons.folder_outlined,
              title: 'All Failed',
              count: _filteredTransactions
                  .where((transaction) => transaction.status == "FAILED")
                  .length, // Count of failed transactions
              color: const Color(0xff7b1113),
              onTap: () {
                setState(() {
                  _filteredTransactions = _transactions
                      .where((transaction) => transaction.status == "FAILED")
                      .toList();
                  _currentPage = 1;
                  _totalPages =
                      (_filteredTransactions.length / _itemsPerPage).ceil();
                });
              },
            ),

            // Success/Sender button
            SummaryButton(
              icon: Icons.folder_shared_rounded,
              title: 'Success/Sender',
              count: _filteredTransactions
                  .where((transaction) =>
                      transaction.transactionType == "SENDER" &&
                      transaction.status == "SUCCESS")
                  .length, // Count of success transactions and sender
              color: const Color(0xff7b1113),
              onTap: () {
                setState(() {
                  _filteredTransactions = _transactions
                      .where((transaction) =>
                          transaction.transactionType == "SENDER" &&
                          transaction.status == "SUCCESS")
                      .toList();
                  _currentPage = 1;
                  _totalPages =
                      (_filteredTransactions.length / _itemsPerPage).ceil();
                });
              },
            ),

            // Failed/Sender button
            SummaryButton(
              icon: Icons.folder_shared_outlined,
              title: 'Failed/Sender',
              count: _filteredTransactions
                  .where((transaction) =>
                      transaction.transactionType == "SENDER" &&
                      transaction.status == "FAILED")
                  .length, // Count of failed transactions and sender
              color: const Color(0xff7b1113),
              onTap: () {
                setState(() {
                  // _filteredTransactions = _transactions
                  //     .where((transaction) =>
                  //         transaction.transactionType == "SENDER" &&
                  //         transaction.status == "FAILED")
                  //     .toList();
                  // _currentPage = 1;
                  // _totalPages =
                  //     (_filteredTransactions.length / _itemsPerPage).ceil();
                  DashboardScreenProd();
                });
              },
            ),

            // Failed Receiver button
            SummaryButton(
              icon: Icons.folder_shared_outlined,
              title: 'Failed Receiver',
              count: _filteredTransactions
                  .where((transaction) =>
                      transaction.transactionType == "RECEIVER" &&
                      transaction.status == "FAILED")
                  .length, // Count of failed transactions and receiver
              color: const Color(0xff7b1113),
              onTap: () {
                setState(() {
                  _filteredTransactions = _transactions
                      .where((transaction) =>
                          transaction.transactionType == "RECEIVER" &&
                          transaction.status == "FAILED")
                      .toList();
                  _currentPage = 1;
                  _totalPages =
                      (_filteredTransactions.length / _itemsPerPage).ceil();
                });
              },
            ),

            // Reversed button
            SummaryButton(
              icon: Icons.sync_alt,
              title: 'Reversed',
              count: _filteredTransactions
                  .where((transaction) => transaction.status == "REVERSED")
                  .length, // Count of reversed transactions
              color: const Color(0xff7b1113),
              onTap: () {
                setState(() {
                  _filteredTransactions = _transactions
                      .where((transaction) => transaction.status == "REVERSED")
                      .toList();
                  _currentPage = 1;
                  _totalPages =
                      (_filteredTransactions.length / _itemsPerPage).ceil();
                });
              },
            ),

            // DS24 button
            SummaryButton(
              icon: Icons.error_outline,
              title: 'DS24',
              count: _filteredTransactions
                  .where((transaction) => transaction.reasonCode == "DS24")
                  .length, // Count of DS24 reason code transactions
              color: const Color(0xff7b1113),
              onTap: () {
                setState(() {
                  _filteredTransactions = _transactions
                      .where((transaction) => transaction.reasonCode == "DS24")
                      .toList();
                  _currentPage = 1;
                  _totalPages =
                      (_filteredTransactions.length / _itemsPerPage).ceil();
                });
              },
            ),

            // 9912 button
            SummaryButton(
              icon: Icons.error_outline,
              title: '9912',
              count: _filteredTransactions
                  .where((transaction) => transaction.reasonCode == "9912")
                  .length, // Count of 9912 reason code transactions
              color: const Color(0xff7b1113),
              onTap: () {
                setState(() {
                  _filteredTransactions = _transactions
                      .where((transaction) => transaction.reasonCode == "9912")
                      .toList();
                  _currentPage = 1;
                  _totalPages =
                      (_filteredTransactions.length / _itemsPerPage).ceil();
                });
              },
            ),

            // AC01 button
            SummaryButton(
              icon: Icons.error_outline,
              title: 'AC01',
              count: _filteredTransactions
                  .where((transaction) => transaction.reasonCode == "AC01")
                  .length, // Count of AC01 reason code transactions
              color: const Color(0xff7b1113),
              onTap: () {
                setState(() {
                  _filteredTransactions = _transactions
                      .where((transaction) => transaction.reasonCode == "AC01")
                      .toList();
                  _currentPage = 1;
                  _totalPages =
                      (_filteredTransactions.length / _itemsPerPage).ceil();
                });
              },
            ),

            // Clear Filter button
            SummaryButtonClear(
              icon: Icons.clear,
              title: 'Clear Filter',
              color: const Color(0xff7b1113),
              onTap: () {
                setState(() {
                  // Reset or reload your transactions
                  resetTransactions();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTable() {
    if (_isLoading) {
      return ReusableTransactionTable(
        title: '',
        columns: _buildColumns(),
        rows: [], // Empty rows while loading
        isLoading: true,
        emptyStateMessage: '',
      );
    }

    // Check if filtered transactions are empty and show appropriate message
    if (_filteredTransactions.isEmpty) {
      return ReusableTransactionTable(
        title: '',
        columns: _buildColumns(),
        rows: _generateRows(), // Generate empty rows when no data
        isEmpty: true,
        emptyStateMessage: 'No transactions found.',
      );
    }

    final List<DataRow> rows =
        _generateRows(); // Generate rows based on the filtered transactions

    return ReusableTransactionTable(
      title: '',
      columns: _buildColumns(),
      rows: rows,
      currentPage: _currentPage,
      totalPages: _totalPages,
      onPreviousPage: () => _changePage(_currentPage - 1),
      onNextPage: () => _changePage(_currentPage + 1),
      emptyStateMessage: '',
      // onExport: _exportToCSV, // Uncomment and implement the export function if needed
    );
  }

  List<DataColumn> _buildColumns() {
    return [
      const DataColumn(label: Text('Date')),
      const DataColumn(label: Text('Type')),
      const DataColumn(label: Text('Instruction Id')),
      const DataColumn(label: Text('Reference Id')),
      const DataColumn(label: Text('Local Instrument')),
      const DataColumn(label: Text('Reason Code')),
      const DataColumn(label: Text('Description')),
      const DataColumn(label: Text('Amount')),
      const DataColumn(label: Text('Status')),
      const DataColumn(label: Text('Action')),
    ];
  }

  List<DataRow> _generateRows() {
    final int startIndex = (_currentPage - 1) * _itemsPerPage;

    // Safeguard: If there are no transactions or the index is out of bounds, return empty rows
    if (_filteredTransactions.isEmpty ||
        startIndex >= _filteredTransactions.length) {
      return List.generate(10, (_) {
        return DataRow(
          cells: [
            DataCell(SelectableText('-')),
            DataCell(SelectableText('-')),
            DataCell(SelectableText('-')),
            DataCell(SelectableText('-')),
            DataCell(SelectableText('-')),
            DataCell(SelectableText('-')),
            DataCell(SizedBox(
              width: 150.0,
              child: SelectableText('-'),
            )),
            DataCell(SelectableText('-')),
            DataCell(SelectableText('-')),
            DataCell(Icon(null)), // Empty icon when no data
          ],
        );
      });
    }

    // Define the range of transactions to display on the current page
    final int endIndex =
        (startIndex + _itemsPerPage).clamp(0, _filteredTransactions.length);

    // Generate rows from the filtered transactions
    final rows =
        _filteredTransactions.sublist(startIndex, endIndex).map((transaction) {
      return DataRow(
        cells: <DataCell>[
          DataCell(SelectableText(
            DateFormatter.formatTransactionDate(transaction.transactionDate),
          )),
          DataCell(SelectableText(transaction.transactionType)),
          DataCell(SelectableText(transaction.instructionId)),
          DataCell(SelectableText(transaction.referenceId)),
          DataCell(SelectableText(transaction.localInstrument)),
          DataCell(SelectableText(transaction.reasonCode)),
          DataCell(SizedBox(
            width: 150.0,
            child: SelectableText(transaction.description),
          )),
          DataCell(SelectableText(transaction.amount.toString())),
          DataCell(SelectableText(transaction.status)),
          DataCell(
            GestureDetector(
              onTap: () {
                // Show the custom dialog when the icon is tapped
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SummaryTransactionsDialog(
                      transactionId: transaction.transactionId,
                      transactionDateTime: transaction.transactionDate,
                      senderBIC: transaction.senderBic,
                      senderAccount: transaction.senderAccount,
                      senderName: transaction.senderName,
                      referenceId: transaction.referenceId,
                      receivingName: transaction.receivingName,
                      receivingBIC: transaction.receivingBic,
                      receivingAccount: transaction.receivingAccount,
                      reasonCode: transaction.reasonCode,
                      description: transaction.description,
                      localInstrument: transaction.localInstrument,
                      instructionId: transaction.instructionId,
                      amountCurrency: transaction.currency,
                      transactionType: transaction.transactionType,
                      status: transaction.status,
                    );
                  },
                );
              },
              child: Icon(Icons.info_outline,
                  color: Color(0xff7b1113)), // Action icon
            ),
          ),
        ],
      );
    }).toList();

    // If there are fewer than 10 rows, add empty rows to make up the difference
    final int remainingRows = 10 - rows.length;
    if (remainingRows > 0) {
      rows.addAll(List.generate(remainingRows, (_) {
        return DataRow(
          cells: [
            DataCell(SelectableText('-')),
            DataCell(SelectableText('-')),
            DataCell(SelectableText('-')),
            DataCell(SelectableText('-')),
            DataCell(SelectableText('-')),
            DataCell(SelectableText('-')),
            DataCell(SizedBox(
              width: 150.0,
              child: SelectableText('-'),
            )),
            DataCell(SelectableText('-')),
            DataCell(SelectableText('-')),
            DataCell(Icon(null)), // Empty icon for empty rows
          ],
        );
      }));
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '',
        height: 68.0,
        showGradient: true,
        actions: null,
        leading: null,
        username: _username,
      ),
      drawer: CustomDrawer(
        username: _username.isNotEmpty ? _username : "Guest",
        onLogout: () async {
          final shouldLogout = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Confirm Logout'),
                content: Text('Are you sure you want to log out?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text('Logout'),
                  ),
                ],
              );
            },
          );
          if (shouldLogout == true) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('accessToken');
            await prefs.remove('username');
            if (mounted) {
              Navigator.pushReplacementNamed(context, '/login');
            }
          }
        },
        menuItems: [
          DrawerMenuItem(
            title: "Users",
            icon: Icons.group,
            onTap: () {
              Navigator.pushNamed(context, '/usertable', arguments: _users);
            },
          ),
          DrawerMenuItem(
            title: "Dashboard",
            icon: Icons.dashboard,
            onTap: () {
              Navigator.pushNamed(context, '/dashboard', arguments: _users);
            },
          ),
          DrawerMenuItem(
            title: "IPS Participants",
            icon: Icons.group,
            onTap: () {
              Navigator.pushNamed(context, '/ipstable', arguments: _users);
            },
          ),
          DrawerMenuItem(
            title: "Dashboard Prod",
            icon: Icons.dashboard,
            onTap: () {
              Navigator.pushNamed(context, '/dashboardprod', arguments: _users);
            },
          ),
          DrawerMenuItem(
            title: "kPlus",
            icon: Icons.dashboard,
            onTap: () {
              Navigator.pushNamed(context, '/kplus', arguments: _users);
            },
          ),
        ],
        logoutCallback: () {},
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Add top space here
              SizedBox(height: 20), // Adjust height for top space
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.start, // Align them beside each other
                  children: [
                    // Search Bar with border radius
                    Container(
                      height: 50, // Set a fixed height for consistency
                      width: 500, // You can adjust the width as needed
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(20), // Apply border radius
                        border: Border.all(
                            color: Colors.grey), // Optional: add a border color
                      ),
                      child: TextField(
                        onChanged:
                            _searchTransactions, // Use this method to filter transactions as the user types
                        decoration: InputDecoration(
                          labelText: 'Search Transactions',
                          border: InputBorder
                              .none, // Remove the default border to use our custom border
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    SizedBox(
                        width:
                            20), // Add space between the search bar and the button
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          showCalendarDialog(
                            context,
                            _filterTransactionsByDate, // Pass the filter function
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff7b1113),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_today, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              "Select Date Transaction",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Add the other UI elements below
              SizedBox(height: 20), // Space between search and content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildSummaryCards(),
                    SizedBox(height: 20),
                    _buildTransactionTable(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

