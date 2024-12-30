import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/models/medicine.dart';

const secureStorage = FlutterSecureStorage();
const String baseUrl = 'http://169.254.144.135:8000';

class MedicineService {
  Future<Medicine> fetchMedicineById(int id) async {
    final url = Uri.parse('$baseUrl/medicine/$id');
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
        final data = json.decode(response.body)['data'];
        return Medicine.fromJson(data);
      } else {
        final error = json.decode(response.body);
        throw Exception('Failed to fetch medicine: ${error['message'] ?? 'Server error'}');
      }
    } catch (e) {
      throw Exception('Failed to fetch medicine: $e');
    }
  }
  Future<void> addMedicine(Medicine medicine) async {
    final url = Uri.parse('$baseUrl/medicine');
    final accessToken = await secureStorage.read(key: 'access_token');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(medicine.toJson()),
      );

      if (response.statusCode != 201) {
        final error = json.decode(response.body);
        throw Exception('Failed to add medicine: ${error['message'] ?? 'Server error'}');
      }
    } catch (e) {
      throw Exception('Failed to add medicine: $e');
    }
  }

  Future<List<Medicine>> fetchMedicines() async {
    final url = Uri.parse('$baseUrl/medicine');
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
            .map((json) => Medicine.fromJson(json))
            .toList();
      } else {
        final error = json.decode(response.body);
        throw Exception('Failed to fetch medicines: ${error['message'] ?? 'Server error'}');
      }
    } catch (e) {
      throw Exception('Failed to fetch medicines: $e');
    }
  }

  Future<void> updateMedicine(int id, Medicine medicine) async {
    final url = Uri.parse('$baseUrl/medicine/$id');
    final accessToken = await secureStorage.read(key: 'access_token');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(medicine.toJson()),
      );

      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception('Failed to update medicine: ${error['message'] ?? 'Server error'}');
      }
    } catch (e) {
      throw Exception('Failed to update medicine: $e');
    }
  }

   

  Future<void> deleteMedicine(int id) async {
    final url = Uri.parse('$baseUrl/medicine/$id');
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
        throw Exception('Failed to delete medicine: ${error['message'] ?? 'Server error'}');
      }
    } catch (e) {
      throw Exception('Failed to delete medicine: $e');
    }
  }
}