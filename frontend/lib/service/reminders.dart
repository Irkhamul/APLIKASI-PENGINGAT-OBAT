import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/models/reminder.dart';

const secureStorage = FlutterSecureStorage();
const String baseUrl = 'http://169.254.144.135:8000';

class ReminderService {
  Future<void> addReminder(Reminder reminder) async {
    final url = Uri.parse('$baseUrl/reminders');
    final accessToken = await secureStorage.read(key: 'access_token');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(reminder.toJson()),
      );

      if (response.statusCode != 201) {
        final error = json.decode(response.body);
        throw Exception('Failed to add reminder: ${error['message'] ?? 'Server error'}');
      }
    } catch (e) {
      throw Exception('Failed to add reminder: $e');
    }
  }

  Future<List<Reminder>> fetchReminders() async {
    final url = Uri.parse('$baseUrl/reminders');
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
        final Map<String, dynamic> decodedData = json.decode(response.body);
        return (decodedData['data'] as List<dynamic>)
            .map((json) => Reminder.fromJson(json))
            .toList();
      } else {
        final error = json.decode(response.body);
        throw Exception('Failed to fetch reminders: ${error['message'] ?? 'Server error'}');
      }
    } catch (e) {
      throw Exception('Failed to fetch reminders: $e');
    }
  }

  Future<void> updateReminder(int id, Reminder reminder) async {
    final url = Uri.parse('$baseUrl/reminders/$id');
    final accessToken = await secureStorage.read(key: 'access_token');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(reminder.toJson()),
      );

      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception('Failed to update reminder: ${error['message'] ?? 'Server error'}');
      }
    } catch (e) {
      throw Exception('Failed to update reminder: $e');
    }
  }

  Future<void> deleteReminder(int id) async {
    final url = Uri.parse('$baseUrl/reminders/$id');
    final accessToken = await secureStorage.read(key: 'access_token');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception('Failed to delete reminder: ${error['message'] ?? 'Server error'}');
      }
    } catch (e) {
      throw Exception('Failed to delete reminder: $e');
    }
  }
}