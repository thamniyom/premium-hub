import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:premium_hub/core/services/log_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/booking.dart';

class BookingService {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://timely-virtue-25369000ea.strapiapp.com/api',
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

  Future<List<Booking>> getBookings() async {
    LogService.info('Fetching bookings from API');
    final headers = await _getHeaders();
    // populate providers and category to display details
    // Uri.parse('$baseUrl/bookings?populate[providers][populate]=category'),
    final response = await http.get(
      Uri.parse(
        '$baseUrl/bookings?populate[0]=lounge&populate[1]=providers&populate[2]=users',
      ),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> bookingsJson = data['data'];
      return bookingsJson.map((json) => Booking.fromJson(json)).toList();
    } else {
      LogService.error('Failed to load bookings: ${response.body}');
      throw Exception('${json.decode(response.body)['error']['message']}');
    }
  }

  Future<Booking> createBooking({
    required List<String?> providerDocumentIds,
    required String loungeDocumentId,
    required DateTime startTime,
    required DateTime endTime,
    required int durationHours,
    required double totalAmount,
  }) async {
    LogService.info(
      'Creating booking for providers: ${providerDocumentIds.join(", ")}',
    );
    LogService.info('Creating booking for lounge: $loungeDocumentId');
    final headers = await _getHeaders();
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');
    String? userDocId;
    if (userString != null) {
      try {
        final userData = json.decode(userString);
        userDocId = userData['documentId'];
      } catch (_) {}
    }
    final data = {
      'data': {
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'durationHours': durationHours,
        'totalAmount': totalAmount,
        'statusBooking': 'pending',
      },
    };
    if (providerDocumentIds.isNotEmpty) {
      (data['data'] as Map<String, dynamic>)['providers'] = providerDocumentIds;
    }
    if (loungeDocumentId.isNotEmpty) {
      (data['data'] as Map<String, dynamic>)['lounge'] = loungeDocumentId;
    }
    if (userDocId != null) {
      (data['data'] as Map<String, dynamic>)['users'] = [userDocId];
    }
    final response = await http.post(
      Uri.parse('$baseUrl/bookings'),
      headers: headers,
      body: json.encode(data),
    );
    LogService.info('userString: $userString');
    LogService.info('data: ${json.encode(data)}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = json.decode(response.body);
      LogService.info('responseData: $responseData');
      return Booking.fromJson(responseData['data']);
    } else {
      LogService.error('Failed to create booking: ${response.body}');
      throw Exception('${json.decode(response.body)['error']['message']}');
    }
  }

  Future<Booking> createBookingV2({
    required String providerDocumentId,
    required String loungeDocumentId,
    required DateTime startTime,
    required DateTime endTime,
    required int durationHours,
    required double totalAmount,
  }) async {
    LogService.info('Creating booking for provider: $providerDocumentId');
    LogService.info('Creating booking for lounge: $loungeDocumentId');
    final headers = await _getHeaders();
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');
    // Attempt to extract user documentId if it was saved
    String? userDocId;
    if (userString != null) {
      try {
        final userData = json.decode(userString);
        userDocId = userData['documentId'];
      } catch (_) {}
    }
    final data = {
      'data': {
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'durationHours': durationHours,
        'totalAmount': totalAmount,
        'statusBooking': 'pending',
        //'providers': [providerDocumentId],
      },
    };
    if (providerDocumentId != '') {
      (data['data'] as Map<String, dynamic>)['providers'] = [
        providerDocumentId,
      ];
    }
    if (loungeDocumentId != '') {
      (data['data'] as Map<String, dynamic>)['lounge'] = loungeDocumentId;
    }
    if (userDocId != null) {
      (data['data'] as Map<String, dynamic>)['users'] = [userDocId];
    }
    final response = await http.post(
      Uri.parse('$baseUrl/bookings'),
      headers: headers,
      body: json.encode(data),
    );
    LogService.info('userString: $userString');
    LogService.info('data: ${json.encode(data)}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = json.decode(response.body);
      LogService.info('responseData: $responseData');
      return Booking.fromJson(responseData['data']);
    } else {
      LogService.error('Failed to create booking: ${response.body}');
      throw Exception('${json.decode(response.body)['error']['message']}');
    }
  }

  Future<Booking> updateBookingStatus(String documentId, String status) async {
    LogService.info('Updating booking $documentId to $status');
    final headers = await _getHeaders();
    final data = {
      'data': {'statusBooking': status},
    };
    final response = await http.put(
      Uri.parse('$baseUrl/bookings/$documentId'),
      headers: headers,
      body: json.encode(data),
    );
    LogService.info('data: $data');
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return Booking.fromJson(responseData['data']);
    } else {
      LogService.error('Failed to update booking: ${response.body}');
      throw Exception('${json.decode(response.body)['error']['message']}');
    }
  }
}
