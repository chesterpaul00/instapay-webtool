import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_drawer.dart';
import '../services/api_services.dart';
import '../models/ips_model.dart';
import '../provider/user_provider.dart';
import '../widgets/custom_table.dart'; // Ensure this is imported

class IpsScreen extends StatefulWidget {
  const IpsScreen({super.key});

  @override
  _IpsScreenState createState() => _IpsScreenState();
}

class _IpsScreenState extends State<IpsScreen> {
  bool isLoading = true;
  List<IpsParticipant> participants = [];
  int currentPage = 1;
  int totalPages = 1;
  final int itemsPerPage = 10;


  @override
  void initState() {
    super.initState();
    _fetchIpsParticipants();
  }

  Future<void> _fetchIpsParticipants() async {
    try {
      List<IpsParticipant> fetchedParticipants = await ApiService.fetchIPSParticipants();
      setState(() {
        participants = fetchedParticipants;
        totalPages = (fetchedParticipants.length / itemsPerPage).ceil(); // Calculate total pages
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Get the list of participants to display based on currentPage and itemsPerPage
  List<IpsParticipant> _getPaginatedParticipants() {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    return participants.sublist(startIndex, endIndex > participants.length ? participants.length : endIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Scaffold(
          appBar: CustomAppBar(
            username: userProvider.loggedInUsername.isNotEmpty
                ? userProvider.loggedInUsername
                : "Guest", // Default to "Guest" if username is null or empty
            title: '', // Set the title for this screen
          ),
          drawer: CustomDrawer(
            username: userProvider.loggedInUsername.isNotEmpty
                ? userProvider.loggedInUsername
                : "Guest", // Ensure username is properly handled
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
                // Perform logout action and navigate to login screen
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
                  title: 'Users',
                  icon: Icons.group,
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/usertable');
                  },
                ),
                DrawerMenuItem(
                  title: 'Dashboard Prod', // Add the new menu item
                  icon: Icons.settings,
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/dashboardprod'); // Navigate to settings screen
                  },
                ),
              ],
              logoutCallback: () {
              // You can handle any additional actions here
            },
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : participants.isEmpty
                  ? Center(child: Text('No participants found.'))
                  : ReusableTable(
                title: 'IPS Participants', // Pass the dynamic title here
                isLoading: isLoading,
                columns: [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Display Name')),
                  DataColumn(label: Text('Bank Code')),
                  DataColumn(label: Text('BIC')),
                  DataColumn(label: Text('Mnemonic')),
                  DataColumn(label: Text('Connection Type')),
                  DataColumn(label: Text('Type')),
                ],
                rows: _getPaginatedParticipants()
                    .map((participant) => DataRow(cells: [
                  DataCell(Text(participant.name)),
                  DataCell(Text(participant.displayName)),
                  DataCell(Text(participant.bankCode)),
                  DataCell(Text(participant.bic)),
                  DataCell(Text(participant.mnemonic)),
                  DataCell(Text(participant.connectionType)),
                  DataCell(Text(participant.type)),
                ]))
                    .toList(),
                currentPage: currentPage,
                totalPages: totalPages,
                onExport: () {
                  // Implement export logic here
                  print('Exporting data...');
                },
                onPreviousPage: () {
                  if (currentPage > 1) {
                    setState(() {
                      currentPage--;
                    });
                  }
                },
                onNextPage: () {
                  if (currentPage < totalPages) {
                    setState(() {
                      currentPage++;
                    });
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
