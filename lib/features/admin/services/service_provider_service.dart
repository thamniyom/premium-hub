import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:premium_hub/core/services/log_service.dart';
import 'package:premium_hub/features/services/models/service_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceProviderService {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://timely-virtue-25369000ea.strapiapp.com/api',
  );

  Future<List<ServiceProvider>> getProviders({
    int page = 1,
    int pageSize = 50,
  }) async {
    LogService.info('ProviderService.getProviders Start');
    final prefs = await SharedPreferences.getInstance();
    final jwt = prefs.getString('jwt');
    LogService.info('jwt : $jwt');
    final response = await http.get(
      Uri.parse(
        '$baseUrl/service-providers?sort=name&pagination[page]=$page&pagination[pageSize]=$pageSize&populate=%2A',
      ),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $jwt'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> items = data['data'];
      return items.map((json) => ServiceProvider.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load providers');
    }
  }

  Future<ServiceProvider> getProvider(String documentId) async {
    LogService.info('ProviderService.getProvider Start');
    final prefs = await SharedPreferences.getInstance();
    final jwt = prefs.getString('jwt');
    LogService.info('jwt : $jwt');
    final response = await http.get(
      Uri.parse('$baseUrl/service-providers/$documentId'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $jwt'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return ServiceProvider.fromJson(data['data']);
    } else {
      throw Exception('Failed to load provider');
    }
  }

  Future<ServiceProvider> createProvider(ServiceProvider provider) async {
    LogService.info('ProviderService.createProvider Start');
    final prefs = await SharedPreferences.getInstance();
    final jwt = prefs.getString('jwt');
    LogService.info('jwt : $jwt');
    final response = await http.post(
      Uri.parse('$baseUrl/service-providers'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $jwt',
      },
      body: json.encode({'data': provider.toJson()}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      LogService.info('body : ${json.encode({'data': provider.toJson()})}');
      final Map<String, dynamic> data = json.decode(response.body);
      return ServiceProvider.fromJson(data['data']);
    } else {
      LogService.error('body : ${json.encode({'data': provider.toJson()})}');
      throw Exception('Failed to create provider: ${response.body}');
    }
  }

  Future<ServiceProvider> updateProvider(
    String documentId,
    ServiceProvider provider,
  ) async {
    LogService.info('ProviderService.updateProvider Start');
    final prefs = await SharedPreferences.getInstance();
    final jwt = prefs.getString('jwt');
    LogService.info('jwt : $jwt');
    final response = await http.put(
      Uri.parse('$baseUrl/service-providers/$documentId'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $jwt',
      },
      body: json.encode({'data': provider.toJson()}),
    );

    if (response.statusCode == 200) {
      LogService.info('body : ${json.encode({'data': provider.toJson()})}');
      final Map<String, dynamic> data = json.decode(response.body);
      return ServiceProvider.fromJson(data['data']);
    } else {
      LogService.error('body : ${json.encode({'data': provider.toJson()})}');
      throw Exception('Failed to update provider: ${response.body}');
    }
  }

  Future<void> deleteProvider(String documentId) async {
    LogService.info('ProviderService.deleteProvider Start');
    final prefs = await SharedPreferences.getInstance();
    final jwt = prefs.getString('jwt');
    LogService.info('jwt : $jwt');
    final response = await http.delete(
      Uri.parse('$baseUrl/service-providers/$documentId'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $jwt'},
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete provider: ${response.body}');
    }
  }
}
