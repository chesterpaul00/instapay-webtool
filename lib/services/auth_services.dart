import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // A method to check authentication status and redirect accordingly
  static Future<void> checkAuthentication(BuildContext context, {required Function onAuthenticated}) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken'); // Use the correct key here

    if (accessToken == null) {
      // If there's no token, navigate to login page
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      // If the user is authenticated, execute the onAuthenticated callback
      onAuthenticated();
    }
  }

  // A method to fetch the logged-in username from SharedPreferences
  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? 'User';
  }
}
