import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ips_model.dart';
import '../models/kPlus_model.dart';
import '../models/transaction_model.dart';
import '../models/transaction_model_prod.dart';

class ApiService {
  static const String baseUrl = "https://dev-api-janus.fortress-asya.com:18005/api/auth/signin";
  static const String instapayUrl = 'https://cmrbuatconnectivity02.fortress-asya.com/api/v1/ips/fdsap/joining_cttransact_into_reasoncode';
  static const String instapayProdUrl = 'https://dev-api-janus.fortress-asya.com:18016/JoiningCTTransactIntoReasonCodeProd';
  static const String ipsParticipantsUrl = 'https://cmrbuatconnectivity02.fortress-asya.com/api/v1/ips/fdsap/IpsParticipants';
  static const String kPlusUrl = 'https://dev-api-janus.fortress-asya.com:8114/getFailedTransaction';

  // Helper method to handle retries
  static Future<http.Response> _fetchWithRetry(Uri url, {int retries = 3, Duration delay = const Duration(seconds: 2)}) async {
    int attempt = 0;
    while (attempt < retries) {
      try {
        return await http.get(url).timeout(Duration(seconds: 30));  // Increased timeout
      } catch (e) {
        if (attempt == retries - 1) rethrow;  // If max retries are reached, throw exception
        attempt++;
        await Future.delayed(delay);  // Wait before retrying
      }
    }
    throw Exception('Failed to fetch after $retries attempts');
  }

  // Login service
  static Future<http.Response?> login(String username, String password) async {
    final url = Uri.parse(baseUrl);

    final headers = {
      'Content-Type': 'application/json',
      'deviceId': 'ABC12345671',
      'deviceModel': 'POSTMAN',
      'fcmToken': 'fcmToken123',
      'osVersion': '1',
      'appVersion': '1.0.1',
    };

    final body = jsonEncode({
      'username': username,
      'password': password,
    });

    try {
      print("Login Request URL: $url");
      print("Request Body: $body");

      final response = await http.post(url, headers: headers, body: body).timeout(Duration(seconds: 30));  // Increased timeout

      print("Login Response Status: ${response.statusCode}");
      print("Login Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        String token = jsonResponse['accessToken'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);
        await prefs.setString('accessToken', token);

        return response;
      } else {
        throw Exception('Login failed: ${response.statusCode}');
      }
    } catch (e) {
      print("Error during login: $e");
      rethrow;
    }
  }

  // Fetch transactions (Instapay)
  static Future<List<instapayModel>> fetchInstapay({required String startDate, required String endDate}) async {
    try {
      final Map<String, String> body = {
        'startDate': startDate,
        'endDate': endDate,
      };

      print("Instapay Request Body: $body");

      final response = await http.post(
        Uri.parse(instapayUrl),
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));  // Increased timeout

      print("Instapay Response Status: ${response.statusCode}");
      print("Instapay Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.isNotEmpty ? data.map((json) => instapayModel.fromJson(json)).toList() : [];
      } else {
        print("Error fetching transactions: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching transactions: $e");
      rethrow;
    }
  }

  // Fetch transactions (Instapay Prod)
  static Future<List<instapayModelProd>> fetchInstapayProd({required String startDate, required String endDate}) async {
    try {
      final Map<String, String> body = {
        'startDate': startDate,
        'endDate': endDate,
      };

      print("Instapay Prod Request Body: $body");

      final response = await http.post(
        Uri.parse(instapayProdUrl),
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));  // Increased timeout

      print("Instapay Prod Response Status: ${response.statusCode}");
      print("Instapay Prod Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.isNotEmpty ? data.map((json) => instapayModelProd.fromJson(json)).toList() : [];
      } else {
        print("Error fetching transactions: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching transactions: $e");
      rethrow;
    }
  }

  // Register service
  static Future<void> register(BuildContext context, String username, String password, String selectedRole) async {
    final url = Uri.parse('$baseUrl/register');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'username': username,
      'password': password,
      'role': selectedRole,
    });

    try {
      final response = await http.post(url, headers: headers, body: body).timeout(Duration(seconds: 30));  // Increased timeout

      print("Register Response Status: ${response.statusCode}");
      print("Register Response Body: ${response.body}");

      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['retCode'] == '201') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonResponse['message'])),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonResponse['message'] ?? "Registration failed")),
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
    final String? token = prefs.getString('accessToken');

    if (token == null) {
      throw Exception('No token found. Please login again.');
    }

    final url = Uri.parse('$baseUrl/users');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(url, headers: headers).timeout(Duration(seconds: 30));  // Increased timeout

      print("Get Users Response Status: ${response.statusCode}");
      print("Get Users Response Body: ${response.body}");

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
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Fetch IPS participants
  static Future<List<IpsParticipant>> fetchIPSParticipants() async {
    try {
      final response = await http.get(
        Uri.parse(ipsParticipantsUrl),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      ).timeout(Duration(seconds: 30));  // Increased timeout

      print("IPS Participants Response Status: ${response.statusCode}");
      print("IPS Participants Response Body: ${response.body}");

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((e) => IpsParticipant.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load IPS participants: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching IPS participants: $e');
    }
  }

  static Future<List<KPlusModel>> fetchKplus({String date = '', String rangeDate = ''}) async {
    final String finalDate = date.isEmpty ? '2024-12-16' : date;
    final String finalRangeDate = rangeDate.isEmpty ? '2024-12-16' : rangeDate;

    final url = '$kPlusUrl?date=$finalDate&range_date=$finalRangeDate';

    try {
      print('API Request URL: $url'); // Log the full API URL being requested

      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 30));  // Increased timeout

      print('Response Status Code: ${response.statusCode}'); // Log the status code
      print('Response Body: ${response.body}'); // Log the full response body

      if (response.statusCode == 200) {
        final List<dynamic> rawData = json.decode(response.body);

        print('Parsed Data from Response: $rawData'); // Log the parsed raw JSON data

        // Ensure mapping to KPlusModel and log any mapping issues
        final List<KPlusModel> transactions = rawData
            .map((json) {
          try {
            return KPlusModel.fromJson(json);
          } catch (e) {
            print('Error parsing JSON: $json | Error: $e'); // Log problematic JSON
            return null;
          }
        })
            .whereType<KPlusModel>() // Ensure only valid models are included
            .toList();

        print('Final Parsed Transactions: $transactions'); // Log the successfully parsed models

        return transactions;
      } else {
        print('API Error: ${response.statusCode} | Body: ${response.body}'); // Log non-200 responses
        throw Exception('Failed to load KPlus data: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during API call: $e'); // Log any exceptions thrown during the API call
      throw Exception('Failed to load KPlus data: $e');
    }
  }
}
