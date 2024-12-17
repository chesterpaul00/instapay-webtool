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
      final response = await http.post(url, headers: headers, body: body).timeout(Duration(seconds: 30));  // Increased timeout

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

      final response = await http.post(
        Uri.parse(instapayUrl),
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));  // Increased timeout

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.isNotEmpty ? data.map((json) => instapayModel.fromJson(json)).toList() : [];
      } else {
        return [];
      }
    } catch (e) {
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

      final response = await http.post(
        Uri.parse(instapayProdUrl),
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));  // Increased timeout

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.isNotEmpty ? data.map((json) => instapayModelProd.fromJson(json)).toList() : [];
      } else {
        return [];
      }
    } catch (e) {
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

  static Future<List<KPlusModel>> fetchKplus({required String startDate, required String endDate}) async {
    final url = '$kPlusUrl?start_date=$startDate&end_date=$endDate';

    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 30));  // Increased timeout

      if (response.statusCode == 200) {
        // Print the raw response body for debugging
        print('Raw response: ${response.body}');

        final dynamic rawData = json.decode(response.body);

        // Check if the response is a Map
        if (rawData is Map) {
          // Print to see if we have a 'data' field or other fields
          print('Response is a Map, rawData: $rawData');

          // Check if the Map contains a key for the transaction list (e.g., 'data', 'results')
          if (rawData.containsKey('data')) {
            final List<dynamic> data = rawData['data'];
            return data.map((json) => KPlusModel.fromJson(json)).toList();
          } else if (rawData.containsKey('results')) {
            final List<dynamic> data = rawData['results'];
            return data.map((json) => KPlusModel.fromJson(json)).toList();
          } else {
            throw Exception('Expected "data" or "results" field in the response.');
          }
        } else if (rawData is List) {
          // If the response is directly a List
          return rawData.map((json) => KPlusModel.fromJson(json)).toList();
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load KPlus data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load KPlus data: $e');
    }
  }
}
