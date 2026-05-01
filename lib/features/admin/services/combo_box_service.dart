import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/combo_box.dart';

class ComboBoxService {
  static const String baseUrl = 'http://localhost:1337/api';

  Future<List<ComboBox>> getComboBoxes({int page = 1, int pageSize = 50}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/combo-boxes?sort=type%2Cname&pagination[page]=$page&pagination[pageSize]=$pageSize'),
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
    final response = await http.get(
      Uri.parse('$baseUrl/combo-boxes/$documentId'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return ComboBox.fromJson(data['data']);
    } else {
      throw Exception('Failed to load combo box');
    }
  }

  Future<ComboBox> createComboBox(ComboBox comboBox) async {
    final response = await http.post(
      Uri.parse('$baseUrl/combo-boxes'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
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
    final response = await http.put(
      Uri.parse('$baseUrl/combo-boxes/$documentId'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
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
    final response = await http.delete(
      Uri.parse('$baseUrl/combo-boxes/$documentId'),
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete combo box: ${response.body}');
    }
  }
}
