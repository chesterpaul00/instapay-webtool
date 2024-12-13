import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_services.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

  // Function to handle login
  Future<void> _handleLogin(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      // Show loading indicator with custom color
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff7b1113)),  // Custom color
            ),
          );
        },
      );

      try {
        final response = await ApiService.login(
          usernameController.text,
          passwordController.text,
        );
        print("API Response: ${response?.body}"); // Log the response body

        // Close the loading indicator
        Navigator.of(context).pop();

        if (response != null && response.statusCode == 200) {
          print("Login successful!");
          String token = jsonDecode(response.body)['accessToken'];
          String username = jsonDecode(response.body)['username'];

          // Save credentials to SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("accessToken", token); // Use the correct key
          await prefs.setString("username", username);
          print("Access Token saved: ${prefs.getString('accessToken')}");

          // Navigate to dashboard
          Navigator.of(context).pushReplacementNamed('/dashboard');
        } else {
          print("Login failed!");
          _showErrorDialog(
              context, 'Invalid username or password. Please try again.');
        }
      } catch (e) {
        // Close the loading indicator in case of an error
        Navigator.of(context).pop();
        print("Error during login: $e");
        // Show error dialog
        _showErrorDialog(context,
            'An error occurred while logging in. Please try again later.');
      }
    }
  }


  // Function to show error dialog
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Failed', style: TextStyle(color: Color(0xff7b1113))),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the error dialog
              },
              child: Text('OK', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient Color (Left side)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.9), // Start color (slightly opaque white)
                    Colors.white10.withOpacity(0.7), // End color (slightly less opaque white)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          // Background Image (Right side)
          Positioned(
            right: -5,
            top: 0,
            bottom: -10,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: SvgPicture.asset(
                'assets/login.svg', // Your SVG image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Centered Content (Logo, Form, Button)
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  // Logo with some shadow for emphasis
                  Image.asset(
                    'assets/fdsap-logo.png',
                    height: 200,
                    width: 200,
                  ),
                  SizedBox(height: 40),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: usernameController,
                          hintText: 'Username',
                          prefixIcon: Icons.person_add_alt_1,
                          prefixIconColor: Colors.black,
                          width: MediaQuery.of(context).size.width * 0.2,
                          fillColor: Colors.white.withOpacity(0.8),
                        ),
                        SizedBox(height: 16),
                        CustomTextField(
                          controller: passwordController,
                          hintText: 'Password',
                          obscureText: true,
                          prefixIcon: Icons.lock,
                          prefixIconColor: Colors.black,
                          width: MediaQuery.of(context).size.width * 0.2,
                          fillColor: Colors.white.withOpacity(0.8),
                        ),
                        SizedBox(height: 24),
                        CustomButton(
                          text: 'Login',
                          onPressed: () {
                            _handleLogin(context);
                          },
                          width: MediaQuery.of(context).size.width * 0.1,
                          color: Color(0xff7b1113),  // Use black with opacity to pass as a Color
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
