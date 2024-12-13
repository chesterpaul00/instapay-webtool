import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final double height;
  final List<Widget>? actions; // Optional actions for the AppBar
  final Widget? leading; // Optional leading widget (e.g., menu button)
  final bool showGradient; // Toggle gradient background

  const CustomAppBar({
    super.key,
    required this.title,
    this.height = 68.0,
    this.actions,
    this.leading,
    this.showGradient = true, required username,
  });

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _isSwitchOn = false; // Default state is off (false)

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: widget.height,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Fixed logo
          Image.asset(
            'assets/instapay1.png',
            height: 80,
            fit: BoxFit.contain,
          ),
        ],
      ),
      centerTitle: true,
      backgroundColor: widget.showGradient ? Colors.transparent : Colors.white,
      flexibleSpace: widget.showGradient
          ? Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 194, 188, 188), // Dirty white color
              Color.fromARGB(255, 255, 240, 240), // Slightly darker shade
            ],
          ),
        ),
      )
          : null,
      actions: [
        if (widget.actions != null) ...widget.actions!,
        // Row containing the switch and dynamic text
        SizedBox(
          width: 100,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _isSwitchOn ? 'PROD' : 'UAT',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Switch(
                value: _isSwitchOn,
                onChanged: (bool value) {
                  setState(() {
                    _isSwitchOn = value;
                  });
                },
                activeColor: Colors.blue,
              ),
            ],
          ),
        ),
      ],
      leading: widget.leading,
    );
  }
}