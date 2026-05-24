import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/services/log_service.dart';
import '../models/service_member.dart';

class MemberService {
  final String baseUrl = const String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://timely-virtue-25369000ea.strapiapp.com/api',
  );
  //https://timely-virtue-25369000ea.strapiapp.com.xxx/api
  static String? jwt;
  static ServiceMember? currentUser;

  Map<String, String> get _headers {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (jwt != null) {
      headers['Authorization'] = 'Bearer $jwt';
    }
    return headers;
  }

  Future<Map<String, dynamic>> authMember(
    String identifier,
    String password,
  ) async {
    LogService.info('Authenticating member: $identifier');
    final response = await http.post(
      Uri.parse('$baseUrl/auth/local'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({'identifier': identifier, 'password': password}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      jwt = data['jwt'];
      currentUser = ServiceMember.fromJson(data['user']);
      LogService.info(
        'Authentication successful for: ${currentUser?.username}',
      );
      return data;
    } else {
      throw Exception('Failed to authenticate: ${response.body}');
    }
  }

  Future<List<ServiceMember>> getMembers() async {
    LogService.info('Fetching all members from API');
    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ServiceMember.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load members');
    }
  }

  Future<ServiceMember> getMember(String documentId) async {
    LogService.info('MemberService.getMember Start');
    final response = await http.get(
      Uri.parse('$baseUrl/users/$documentId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return ServiceMember.fromJson(data);
    } else {
      throw Exception('Failed to load member');
    }
  }

  Future<ServiceMember> createMember(
    ServiceMember member,
    String password,
  ) async {
    // Note: To create users natively in Strapi, it is often via POST /api/users
    // or POST /api/auth/local/register. Assuming POST /api/users here based on typical CRUD.
    LogService.info('Creating member: ${member.username}');
    final data = member.toJson();
    data['password'] =
        password; // Password is required for Strapi user creation

    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: _headers,
      body: json.encode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      LogService.info('data: ${json.encode(data)}');
      final Map<String, dynamic> respData = json.decode(response.body);
      return ServiceMember.fromJson(respData);
    } else {
      LogService.error('data: ${json.encode(data)}');
      throw Exception('Failed to create member: ${response.body}');
    }
  }

  Future<ServiceMember> updateMember(
    String documentId,
    ServiceMember member,
  ) async {
    LogService.info('Updating member: $documentId');
    final response = await http.put(
      Uri.parse('$baseUrl/users/$documentId'),
      headers: _headers,
      body: json.encode(member.toJson()),
    );

    if (response.statusCode == 200) {
      LogService.info('data: $member.toJson()}');
      final Map<String, dynamic> data = json.decode(response.body);
      return ServiceMember.fromJson(data);
    } else {
      LogService.error('data: $member.toJson()}');
      throw Exception('Failed to update member: ${response.body}');
    }
  }

  Future<void> deleteMember(String documentId) async {
    LogService.info('Deleting member: $documentId');
    final response = await http.delete(
      Uri.parse('$baseUrl/users/$documentId'),
      headers: _headers,
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete member: ${response.body}');
    }
  }
}
