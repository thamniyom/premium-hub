import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../services/models/service_provider.dart';
import '../../bookings/models/booking.dart';

class ProviderServiceHistoryScreen extends StatelessWidget {
  final ServiceProvider provider;

  const ProviderServiceHistoryScreen({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    // Filter bookings for this specific provider
    final history = demoBookings
        .where((b) => b.providerName == provider.name)
        .toList();

    // Sort by date (descending)
    history.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    final totalEarnings = history
        .where((b) => b.status == BookingStatus.completed)
        .fold(0.0, (sum, b) => sum + b.price);

    final completedCount =
        history.where((b) => b.status == BookingStatus.completed).length;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('${provider.name}\'s History'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Summary Info Row
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    child: _InfoCard(
                      label: 'Total Earnings',
                      value: '\$${totalEarnings.toStringAsFixed(0)}',
                      icon: LucideIcons.wallet,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _InfoCard(
                      label: 'Completed',
                      value: '$completedCount',
                      icon: LucideIcons.checkCircle,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Service Logs',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // History List
            Expanded(
              child: history.isEmpty
                  ? const Center(
                      child: Text(
                        'No service history found',
                        style: TextStyle(color: Colors.white54),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        final booking = history[index];
                        return _HistoryItem(booking: booking);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _InfoCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final Booking booking;

  const _HistoryItem({required this.booking});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('MMM dd, yyyy').format(booking.dateTime);
    final timeStr = DateFormat('hh:mm a').format(booking.dateTime);

    Color statusColor;
    String statusText;

    switch (booking.status) {
      case BookingStatus.upcoming:
        statusColor = Colors.orange;
        statusText = 'UPCOMING';
        break;
      case BookingStatus.completed:
        statusColor = Colors.green;
        statusText = 'COMPLETED';
        break;
      case BookingStatus.cancelled:
        statusColor = Colors.red;
        statusText = 'CANCELLED';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              booking.status == BookingStatus.completed
                  ? LucideIcons.check
                  : (booking.status == BookingStatus.cancelled
                      ? LucideIcons.x
                      : LucideIcons.clock),
              color: statusColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.serviceType,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  '$dateStr • $timeStr',
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '+\$${booking.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                statusText,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
