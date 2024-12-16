import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/kPlus_model.dart';
import '../services/api_services.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/kplus_table.dart';

class KplusScreen extends StatefulWidget {
  const KplusScreen({super.key});

  @override
  _KplusScreenState createState() => _KplusScreenState();
}

class _KplusScreenState extends State<KplusScreen> {
  final List<KPlusModel> _transactions = [];
  List<KPlusModel> _filteredTransactions = [];
  String _username = 'Guest';
  bool _isLoading = false;
  int _currentPage = 1;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _fetchTransactions();
  }

  /// Load username from SharedPreferences
  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'Guest';
    });
  }

  /// Fetch transactions from the API
  Future<void> _fetchTransactions() async {
    setState(() => _isLoading = true);
    try {
      final fetchedTransactions = await ApiService.fetchKplus();
      setState(() {
        _transactions.clear();
        _transactions.addAll(fetchedTransactions);
        _filteredTransactions = _transactions;
        _totalPages = (_filteredTransactions.isEmpty) ? 1 : (_filteredTransactions.length / 10).ceil();
      });
    } catch (e) {
      _showErrorSnackbar('Failed to load transactions. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Show error snackbar
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  /// Handle logout action
  Future<void> _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Logout')),
        ],
      ),
    );

    if (shouldLogout ?? false) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      if (mounted) Navigator.pushReplacementNamed(context, '/login');
    }
  }

  /// Pagination logic: Go to previous page
  void _goToPreviousPage() {
    if (_currentPage > 1) setState(() => _currentPage--);
  }

  /// Pagination logic: Go to next page
  void _goToNextPage() {
    if (_currentPage < _totalPages) setState(() => _currentPage++);
  }

  /// Dummy export to CSV functionality
  void _exportToCSV() {
    print("Exporting data to CSV...");
    // Add CSV export logic here
  }

  @override
  Widget build(BuildContext context) {
    final startIndex = (_currentPage - 1) * 10;
    final endIndex = (_currentPage * 10).clamp(0, _filteredTransactions.length);
    final paginatedTransactions = _filteredTransactions.sublist(startIndex, endIndex);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'KPlus Transactions',
        height: 68.0,
        showGradient: true,
        username: _username,
      ),
      drawer: CustomDrawer(
        username: _username,
        onLogout: _handleLogout,
        menuItems: [
          DrawerMenuItem(title: "Users", icon: Icons.group, onTap: () => Navigator.pushNamed(context, '/usertable')),
          DrawerMenuItem(title: "Dashboard", icon: Icons.dashboard, onTap: () => Navigator.pushNamed(context, '/dashboard')),
          DrawerMenuItem(title: "IPS Participants", icon: Icons.group, onTap: () => Navigator.pushNamed(context, '/ipstable')),
          DrawerMenuItem(title: "Dashboard Prod", icon: Icons.dashboard, onTap: () => Navigator.pushNamed(context, '/dashboardprod')),
          DrawerMenuItem(title: "kPlus", icon: Icons.dashboard, onTap: () => Navigator.pushNamed(context, '/kplus')),
        ], logoutCallback: () {  },
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const SizedBox(height: 16),
              ReusableTransactionTable(
                columns: const [
                  DataColumn(label: Text('Transaction ID')),
                  DataColumn(label: Text('Transaction Type')),
                  DataColumn(label: Text('Amount')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Transaction Date')),
                  DataColumn(label: Text('Account Number')),
                  DataColumn(label: Text('Reference ID')),
                ],
                data: paginatedTransactions.isNotEmpty ? paginatedTransactions : [],
                isLoading: _isLoading,
                isEmpty: _transactions.isEmpty,
                currentPage: _currentPage,
                totalPages: _totalPages,
                onPreviousPage: _goToPreviousPage,
                onNextPage: _goToNextPage,
                onExport: _exportToCSV,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
