import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_drawer.dart';
import '../provider/user_provider.dart';

class UserTableScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (userProvider.loggedInUsername == "User") {
          userProvider.checkAuthentication(context);
        }

        return Scaffold(
          appBar: CustomAppBar(
            username: userProvider.loggedInUsername.isNotEmpty == true
                ? userProvider.loggedInUsername
                : "Guest", // Default to "Guest" if username is null or empty
            title: '', // Added a title for better context
          ),
          drawer: CustomDrawer(
            username: userProvider.loggedInUsername.isNotEmpty == true
                ? userProvider.loggedInUsername
                : "Guest", // Consistent handling of null or empty username
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
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text('Logout'),
                      ),
                    ],
                  );
                },
              );

              if (shouldLogout == true) {
                // Navigate to login screen
                Navigator.of(context).pushReplacementNamed('/login');
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('accessToken');
                await prefs.remove('username');
              }
            },
            menuItems: [
              DrawerMenuItem(
                title: 'Dashboard',
                icon: Icons.dashboard,
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/dashboard');
                },
              ),
              DrawerMenuItem(
                title: 'IPS Participants',
                icon: Icons.group,
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/ipstable');
                },
              )
            ], logoutCallback: () {  },
          ),
          body: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.jpg'), // Path to your background image
                  fit: BoxFit.cover, // Makes sure the image covers the entire screen
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: userProvider.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : userProvider.filteredUsers.isEmpty
                    ? Center(child: Text('No users found.'))
                    : _buildUserTable(context, userProvider),
              ),
            ),
          ),
        );
      },
    );
  }

  // Build the user table widget with pagination
  Widget _buildUserTable(BuildContext context, UserProvider userProvider) {
    final paginatedUsers = userProvider.getPaginatedUsers();

    return SingleChildScrollView(
      child: Center(
        child: Container(
          width: 800, // Set the width to 800 pixels
          child: Column(
            children: [
              Table(
                border: TableBorder.all(color: Colors.grey.shade300),
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(3),
                  2: FlexColumnWidth(2),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey.shade100),
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Center(child: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Center(child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Center(child: Text('Role', style: TextStyle(fontWeight: FontWeight.bold))),
                      ),
                    ],
                  ),
                  ...paginatedUsers.map((user) {
                    return TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(child: Text(user['id'].toString())),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(child: Text(user['username'] ?? 'N/A')),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(child: Text(user['role'] ?? 'N/A')),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: userProvider.currentPage > 1 ? Colors.black : Colors.black),
                    onPressed: userProvider.currentPage > 1
                        ? () {
                      userProvider.changePage(userProvider.currentPage - 1);
                    }
                        : null,
                  ),
                  Text(
                    'Page ${userProvider.currentPage} of ${userProvider.totalPages}',
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward, color: userProvider.currentPage < userProvider.totalPages ? Colors.black : Colors.black),
                    onPressed: userProvider.currentPage < userProvider.totalPages
                        ? () {
                      userProvider.changePage(userProvider.currentPage + 1);
                    }
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
