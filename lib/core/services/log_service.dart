import 'package:flutter/foundation.dart';

/// Central logging service for all app events.
/// Logs are printed to the debug console with a [LOG] prefix and timestamp.
class LogService {
  LogService._(); // private constructor — not instantiable

  static void _log(
    String category,
    String message, [
    Map<String, dynamic>? data,
  ]) {
    final time = DateTime.now().toIso8601String().substring(
      11,
      23,
    ); // HH:mm:ss.mmm
    final dataStr = data != null ? ' | data: $data' : '';
    debugPrint('[LOG][$time][$category] $message$dataStr');
  }

  // ── General ───────────────────────────────────────────────────
  static void info(String message, [Map<String, dynamic>? data]) =>
      _log('INFO', message, data);

  // ── App lifecycle ──────────────────────────────────────────────
  static void appStart() => _log('APP', 'App started');

  // ── Auth ───────────────────────────────────────────────────────
  static void loginPressed({String? email}) =>
      _log('AUTH', 'Sign-in button pressed', {'email': email ?? 'n/a'});

  static void loginSuccess({String? email}) => _log(
    'AUTH',
    'Login successful – navigating to Home',
    {'email': email ?? 'n/a'},
  );

  // ── Navigation ─────────────────────────────────────────────────
  static void tabChanged(int index) {
    const names = ['Home', 'Search', 'Booking', 'Messages', 'Profile'];
    _log('NAV', 'Tab changed → ${names[index]}', {'index': index});
  }

  static void screenOpened(String screenName, [Map<String, dynamic>? params]) =>
      _log('NAV', 'Opened screen: $screenName', params);
  static void screenLoad(String screenName, [Map<String, dynamic>? params]) =>
      _log('NAV', 'Load screen: $screenName', params);

  static void screenPopped(String screenName) =>
      _log('NAV', 'Popped screen: $screenName');

  // ── Home service icons ─────────────────────────────────────────
  static void serviceIconTapped(String label) =>
      _log('HOME', 'Service icon tapped: $label');

  // ── Providers ──────────────────────────────────────────────────
  static void providerTapped(String providerId, String providerName) => _log(
    'PROVIDER',
    'Provider tapped',
    {'id': providerId, 'name': providerName},
  );
  static void loungeTapped(String providerId, String providerName) =>
      _log('LOUNGE', 'Lounge tapped', {'id': providerId, 'name': providerName});

  // ── Booking ────────────────────────────────────────────────────
  static void bookingDateSelected(DateTime date) => _log(
    'BOOKING',
    'Date selected',
    {'date': date.toIso8601String().substring(0, 10)},
  );

  static void bookingTimeSelected(String time) =>
      _log('BOOKING', 'Time selected', {'time': time});

  static void bookingDurationChanged(int hours) =>
      _log('BOOKING', 'Duration changed', {'hours': hours});

  static void bookingConfirmed({
    required String providerId,
    required String providerName,
    required String date,
    required String time,
    required int hours,
    required double total,
  }) => _log('BOOKING', 'Booking confirmed', {
    'provider_id': providerId,
    'provider_name': providerName,
    'date': date,
    'time': time,
    'hours': hours,
    'total': total,
  });

  // ── Top-up ─────────────────────────────────────────────────────
  static void topUpQuickAmountSelected(int amount) =>
      _log('TOPUP', 'Quick amount selected', {'amount': amount});

  static void topUpConfirmed(double amount) =>
      _log('TOPUP', 'Top-up confirmed', {'amount': amount});

  // ── Search ─────────────────────────────────────────────────────
  static void searchQueried(String query) =>
      _log('SEARCH', 'Search query submitted', {'query': query});

  // ── Messages ───────────────────────────────────────────────────
  static void conversationOpened(String conversationId, String name) =>
      _log('MSG', 'Conversation opened', {'id': conversationId, 'name': name});

  static void messageSent(String conversationId) =>
      _log('MSG', 'Message sent', {'conversation_id': conversationId});

  static void error(String message) {
    _log('ERROR', message);
  }

  static void bookingDurationSelected(int d) {}
}
