import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const secureStorage = FlutterSecureStorage();

const String baseUrl = 'http://169.254.144.135:8000'; // ganti ip dengan ip host laptop punya temen temen

Future<void> login(String email, String password) async {
  final url = Uri.parse('$baseUrl/login');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final accessToken = data['token']['access_token'];

      await secureStorage.write(key: 'access_token', value: accessToken);
      print('Access token successfully stored!');
    } else {
      final error = json.decode(response.body);
      throw Exception('Login failed: ${error['message'] ?? 'Server error'}');
    }
  } catch (e) {
    throw Exception('Login failed: $e');
  }
}

Future<void> register(String name, String email, String password, String confirmPassword) async {
  final url = Uri.parse('$baseUrl/register');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': confirmPassword,
      }),
    );

    if (response.statusCode == 201) {
      print('Registration successful!');
    } else {
      final error = json.decode(response.body);
      throw Exception('Registration failed: ${error['message'] ?? 'Server error'}');
    }
  } catch (e) {
    throw Exception('Registration failed: $e');
  }
}

Future<Map<String, dynamic>> fetchProtectedData() async {
  final url = Uri.parse('$baseUrl/me');
  final accessToken = await secureStorage.read(key: 'access_token');

  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body) as Map<String, dynamic>;
      return decodedData; 
    } else if (response.statusCode == 401) {
      throw Exception('Invalid or expired access token. Please log in again.');
    } else {
      final error = json.decode(response.body);
      throw Exception('Error: ${error['message'] ?? 'Server error'}');
    }
  } catch (e) {
    throw Exception('An error occurred: $e');
  }
}

Future<void> logout() async {
  await secureStorage.delete(key: 'access_token');
  print('Access token successfully deleted.');
}