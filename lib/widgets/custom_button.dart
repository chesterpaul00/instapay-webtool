import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final Color color; // Change from MaterialColor to Color
  final Color textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.width,
    required this.color, // Now accepts Color
    required this.textColor, // Text color as a Color
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, // Set the width of the button
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color, // Use the color parameter for background
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          textStyle: const TextStyle(fontSize: 16),
          foregroundColor: textColor, // Use textColor parameter for text
        ),
        child: Text(text),
      ),
    );
  }
}
