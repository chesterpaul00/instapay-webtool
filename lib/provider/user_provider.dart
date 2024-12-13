import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_services.dart';

class UserProvider with ChangeNotifier {
  // Private fields
  List<dynamic> _users = []; // Complete user list
  List<dynamic> _filteredUsers = []; // Filtered/Paginated user list
  bool _isLoading = false;
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  int _totalPages = 1;
  String _loggedInUsername = 'User'; // Default username
  int _page = 1;

  int get page => _page;

  // Public getters
  List<dynamic> get filteredUsers => _filteredUsers;
  bool get isLoading => _isLoading;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  String get loggedInUsername => _loggedInUsername;

  void nextPage() {
    _page++;
    notifyListeners(); // Notify listeners to rebuild UI when page changes
  }

  void previousPage() {
    if (_page > 1) {
      _page--;
      notifyListeners();
    }
  }

  // Check if the user is authenticated
  Future<void> checkAuthentication(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('accessToken');
    if (token != null) {
      await _loadUsername();
      await loadUsers();
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  // Load username from SharedPreferences
  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    _loggedInUsername = prefs.getString('username') ?? 'User'; // Default if null
    notifyListeners();
  }

  // Fetch and load users from API
  Future<void> loadUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      final users = await ApiService.getUsers();
      _users = users;
      _filteredUsers = List.from(users);
      _totalPages = (_users.length / _itemsPerPage).ceil();
    } catch (e) {
      print('Error loading users: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Change current page
  void changePage(int newPage) {
    if (newPage > 0 && newPage <= _totalPages) {
      _currentPage = newPage;
      notifyListeners();
    }
  }

  // Get users for the current page
  List<dynamic> getPaginatedUsers() {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = (_currentPage * _itemsPerPage).clamp(0, _filteredUsers.length);
    return _filteredUsers.sublist(startIndex, endIndex);
  }

  // Search users by name or role
  void searchUsers(String query) {
    if (query.isEmpty) {
      clearFilter();
    } else {
      _filteredUsers = _users.where((user) {
        final name = user['name']?.toLowerCase() ?? '';
        final role = user['role']?.toLowerCase() ?? '';
        return name.contains(query.toLowerCase()) || role.contains(query.toLowerCase());
      }).toList();
      _totalPages = (_filteredUsers.length / _itemsPerPage).ceil();
      notifyListeners();
    }
  }

  // Logout the user
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all stored data
    Navigator.of(context).pushReplacementNamed('/login');
  }

  // Clear all filters and show full user list
  void clearFilter() {
    _filteredUsers = List.from(_users);
    _totalPages = (_filteredUsers.length / _itemsPerPage).ceil();
    notifyListeners();
  }

  // Placeholder for showing a calendar
  void showCalendar() {
    print('Calendar functionality is not implemented yet.');
  }
}
