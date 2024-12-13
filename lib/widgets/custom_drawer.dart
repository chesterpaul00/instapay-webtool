import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  final String username;
  final VoidCallback onLogout;
  final List<DrawerMenuItem> menuItems;

  const CustomDrawer({
    super.key,
    required this.username,
    required this.onLogout,
    required this.menuItems, required Null Function() logoutCallback,
  });

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int? _selectedMenuIndex;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 315,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xff7b1113),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/fdsap-logo.png',
                      fit: BoxFit.cover,
                      width: 68,
                      height: 68,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Text(
                  "Hello, ${widget.username}!",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
          ),
          // Dynamically add menu items
          ...widget.menuItems.asMap().entries.map((entry) {
            int index = entry.key;
            DrawerMenuItem item = entry.value;

            return ListTile(
              leading: Icon(item.icon,
                  color: _selectedMenuIndex == index
                      ? Colors.red // Active color
                      : Colors.black), // Default color
              title: Text(
                item.title,
                style: TextStyle(
                  color: _selectedMenuIndex == index
                      ? Colors.red // Active color
                      : Colors.black, // Default color
                ),
              ),
              onTap: () {
                setState(() {
                  _selectedMenuIndex = index;
                });
                item.onTap();
              },
            );
          }),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: widget.onLogout,
          ),
        ],
      ),
    );
  }
}

// Define DrawerMenuItem for better structure
class DrawerMenuItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const DrawerMenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}
