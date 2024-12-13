import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:instapay_webtool_provider_test/models/transaction_model_prod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ips_model.dart';
import '../models/transaction_model.dart';

class ApiService {
  static const String baseUrl = "https://dev-api-janus.fortress-asya.com:18005/api/auth/signin";

  // Login service
  static Future<http.Response?> login(String username, String password) async {
    final url = Uri.parse(baseUrl);

    // Updated headers including the new ones
    final headers = {
      'Content-Type': 'application/json',
      'deviceId': 'ABC12345671', // Replace with actual deviceId
      'deviceModel': 'POSTMAN', // Replace with actual device model
      'fcmToken': 'fcmToken123', // Replace with actual FCM token
      'osVersion': '1', // Replace with actual OS version
      'appVersion': '1.0.1', // Replace with actual app version
    };

    // Request body (username and password)
    final body = jsonEncode({
      'username': username,
      'password': password,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        String token = jsonDecode(response.body)['accessToken'];

        // Check for successful login response (based on the API's expected response)
        // Save username and access token to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);
        await prefs.setString('accessToken', jsonResponse['accessToken']);

        return response;
            }
    } catch (e) {
      print("Error during login: $e");
    }

    return null; // Login failed
  }

  // Fetch transactions data
  static Future<List<instapayModel>> fetchInstapay({
    required String startDate,
    required String endDate,
  }) async {
    try {
      final Map<String, String> body = {
        if (startDate.isNotEmpty) 'startDate': startDate,
        if (endDate.isNotEmpty) 'endDate': endDate,
      };

      final response = await http.post(
        Uri.parse(
            'https://cmrbuatconnectivity02.fortress-asya.com/api/v1/ips/fdsap/joining_cttransact_into_reasoncode'),
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isEmpty) {
          print('No transactions found for the given date range.');
          return [];
        }
        return data.map((json) => instapayModel.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        final errorResponse = json.decode(response.body);
        print("Error: ${errorResponse['error']}");
        return []; // No transactions found
      } else {
        print("Unexpected response: ${response.statusCode}");
        throw Exception('Failed to fetch transactions. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching transactions: $e');
      rethrow; // Re-throw the exception to be handled by the caller
    }
  }

  //prod
  static Future<List<instapayModelProd>> fetchInstapayProd({
    required String startDate,
    required String endDate,
  }) async {
    try {
      final Map<String, String> body = {
        if (startDate.isNotEmpty) 'startDate': startDate,
        if (endDate.isNotEmpty) 'endDate': endDate,
      };

      final response = await http.post(
        Uri.parse(
            'https://dev-api-janus.fortress-asya.com:18016/JoiningCTTransactIntoReasonCodeProd'),
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isEmpty) {
          print('No transactions found for the given date range.');
          return [];
        }
        return data.map((json) => instapayModelProd.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        final errorResponse = json.decode(response.body);
        print("Error: ${errorResponse['error']}");
        return []; // No transactions found
      } else {
        print("Unexpected response: ${response.statusCode}");
        throw Exception('Failed to fetch transactions. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching transactions: $e');
      rethrow; // Re-throw the exception to be handled by the caller
    }
  }


  // Register service
  static Future<void> register(BuildContext context, String username,
      String password, String selectedRole) async {
    final url = Uri.parse('$baseUrl/register');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'username': username,
      'password': password,
      'role': selectedRole,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['retCode'] == '201') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonResponse['message'])),
          );
          Navigator.pop(context); // Navigate back to login screen
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                Text(jsonResponse['message'] ?? "Registration failed")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration failed. Please try again.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  // Get users service
  static Future<List<dynamic>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found. Please login again.');
    }

    final url = Uri.parse('$baseUrl/users');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['data'] is List) {
          return List.from(jsonResponse['data']);
        } else {
          throw Exception('Users data is not in the expected list format');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }


  //IPS services

  static Future<List<IpsParticipant>> fetchIPSParticipants() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://cmrbuatconnectivity02.fortress-asya.com/api/v1/ips/fdsap/IpsParticipants'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print("===============================");
        print("SUCESS FETCHING IPS PARTICIPANTS");
        print("===============================");
        List<dynamic> data = json.decode(response.body);
        List<IpsParticipant> participants =
        data.map((e) => IpsParticipant.fromJson(e)).toList();
        return participants;
      } else {
        print(
            "Error fetching participants: Status code ${response.statusCode}");
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching participants: $e");
      throw Exception('Failed to load data: $e');
    }
  }
}
