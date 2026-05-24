import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:premium_hub/core/services/log_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/models/lounge.dart';

class LoungeService {
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

  Future<List<Lounge>> getLounges({int page = 1, int pageSize = 50}) async {
    LogService.info('LoungeService.getLounges Start');
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse(
        '$baseUrl/lounges?sort=name&pagination[page]=$page&pagination[pageSize]=$pageSize&populate=%2A',
      ),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> items = data['data'];
      return items.map((json) => Lounge.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load lounges');
    }
  }

  Future<Lounge> getLounge(String documentId) async {
    LogService.info('LoungeService.getLounge Start');
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/lounges/$documentId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Lounge.fromJson(data['data']);
    } else {
      throw Exception('Failed to load lounge');
    }
  }

  Future<Lounge> createLounge(Lounge lounge) async {
    LogService.info('LoungeService.createLounge Start');
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/lounges'),
      headers: headers,
      body: json.encode({'data': lounge.toJson()}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      LogService.info('body : ${json.encode({'data': lounge.toJson()})}');
      final Map<String, dynamic> data = json.decode(response.body);
      return Lounge.fromJson(data['data']);
    } else {
      LogService.error('body : ${json.encode({'data': lounge.toJson()})}');
      throw Exception('Failed to create lounge: ${response.body}');
    }
  }

  Future<Lounge> updateLounge(String documentId, Lounge lounge) async {
    LogService.info('LoungeService.updateLounge Start');
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/lounges/$documentId'),
      headers: headers,
      body: json.encode({'data': lounge.toJson()}),
    );

    if (response.statusCode == 200) {
      LogService.info('body : ${json.encode({'data': lounge.toJson()})}');
      final Map<String, dynamic> data = json.decode(response.body);
      return Lounge.fromJson(data['data']);
    } else {
      LogService.error('body : ${json.encode({'data': lounge.toJson()})}');
      throw Exception('Failed to update lounge: ${response.body}');
    }
  }

  Future<void> deleteLounge(String documentId) async {
    LogService.info('LoungeService.deleteLounge Start');
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/lounges/$documentId'),
      headers: headers,
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete lounge: ${response.body}');
    }
  }
}
