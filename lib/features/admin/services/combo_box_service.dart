import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:premium_hub/core/services/log_service.dart';
import 'package:premium_hub/features/admin/models/combo_box.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComboBoxService {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://timely-virtue-25369000ea.strapiapp.com/api',
  );
  static const String baseUrlPrd = 'http://localhost:1337/api';
  static const String baseUrlDev = 'http://localhost:1337/api';
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final jwt = prefs.getString('jwt');
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (jwt != null) {
      headers['Authorization'] = 'Bearer $jwt';
    }
    return headers;
  }

  Future<List<ComboBox>> getComboBoxes({
    int page = 1,
    int pageSize = 50,
  }) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse(
        '$baseUrl/combo-boxes?sort=type%2Cname&pagination[page]=$page&pagination[pageSize]=$pageSize',
      ),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> items = data['data'];
      return items.map((json) => ComboBox.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load combo boxes');
    }
  }

  Future<ComboBox> getComboBox(String documentId) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/combo-boxes/$documentId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return ComboBox.fromJson(data['data']);
    } else {
      throw Exception('Failed to load combo box');
    }
  }

  Future<ComboBox> createComboBox(ComboBox comboBox) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/combo-boxes'),
      headers: headers,
      body: json.encode({'data': comboBox.toJson()}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data = json.decode(response.body);
      return ComboBox.fromJson(data['data']);
    } else {
      throw Exception('Failed to create combo box: ${response.body}');
    }
  }

  Future<ComboBox> updateComboBox(String documentId, ComboBox comboBox) async {
    final headers = await _getHeaders();
    LogService.info(
      'updateComboBox documentId: $documentId, ${comboBox.toJson()}',
    );
    final response = await http.put(
      Uri.parse('$baseUrl/combo-boxes/$documentId'),
      headers: headers,
      body: json.encode({'data': comboBox.toJson()}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return ComboBox.fromJson(data['data']);
    } else {
      throw Exception('Failed to update combo box: ${response.body}');
    }
  }

  Future<void> deleteComboBox(String documentId) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/combo-boxes/$documentId'),
      headers: headers,
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete combo box: ${response.body}');
    }
  }

  Future<List<ComboBox>> getLoungeCategories() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/combo-box/get-combo-by-type/category'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> items = data['data'];
      return items.map((json) => ComboBox.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load combo boxes category');
    }
  }

  Future<List<ComboBox>> getLoungeAmenity() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/combo-box/get-combo-by-type/amenity'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> items = data['data'];
      return items.map((json) => ComboBox.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load combo boxes amenity');
    }
  }

  Future<List<ComboBox>> getProviderCategories() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/combo-box/get-combo-by-type/provider-category'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> items = data['data'];
      return items.map((json) => ComboBox.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load provider categories combo boxes');
    }
  }

  Future<List<ComboBox>> getRoleService() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/combo-box/get-combo-by-type/roleservice'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> items = data['data'];
      return items.map((json) => ComboBox.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load provider categories combo boxes');
    }
  }
}
