import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:premium_hub/core/services/log_service.dart';
import 'package:premium_hub/features/services/models/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderService {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:1337/api',
  );
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

  Future<List<Provider>> getProviders({int page = 1, int pageSize = 50}) async {
    LogService.info('ProviderService.getProviders Start');
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse(
        '$baseUrl/providers?sort=name&pagination[page]=$page&pagination[pageSize]=$pageSize&populate=%2A',
      ),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> items = data['data'];
      return items.map((json) => Provider.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load providers');
    }
  }

  Future<Provider> getProvider(String documentId) async {
    LogService.info('ProviderService.getProvider Start');
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/providers/$documentId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Provider.fromJson(data['data']);
    } else {
      throw Exception('Failed to load provider');
    }
  }

  Future<Provider> createProvider(Provider provider) async {
    LogService.info('ProviderService.createProvider Start');
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/providers'),
      headers: headers,
      body: json.encode({'data': provider.toJson()}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      LogService.info('body : ${json.encode({'data': provider.toJson()})}');
      final Map<String, dynamic> data = json.decode(response.body);
      return Provider.fromJson(data['data']);
    } else {
      LogService.error('body : ${json.encode({'data': provider.toJson()})}');
      throw Exception('Failed to create provider: ${response.body}');
    }
  }

  Future<Provider> updateProvider(String documentId, Provider provider) async {
    LogService.info('ProviderService.updateProvider Start');
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/providers/$documentId'),
      headers: headers,
      body: json.encode({'data': provider.toJson()}),
    );

    if (response.statusCode == 200) {
      LogService.info('body : ${json.encode({'data': provider.toJson()})}');
      final Map<String, dynamic> data = json.decode(response.body);
      return Provider.fromJson(data['data']);
    } else {
      LogService.error('body : ${json.encode({'data': provider.toJson()})}');
      throw Exception('Failed to update provider: ${response.body}');
    }
  }

  Future<void> deleteProvider(String documentId) async {
    LogService.info('ProviderService.deleteProvider Start');
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/providers/$documentId'),
      headers: headers,
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete provider: ${response.body}');
    }
  }
}
