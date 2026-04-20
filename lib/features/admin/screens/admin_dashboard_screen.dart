import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/services/log_service.dart';
import 'provider_management_screen.dart';
import 'lounge_management_screen.dart';
import 'booking_management_screen.dart';
import 'revenue_analytics_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulated Management Data
    const double totalRevenue = 1240.0;
    const int totalBookings = 42;
    const int onlineProviders = 12;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
          onPressed: () {
            LogService.screenPopped('AdminDashboardScreen');
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overview Stats Row
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Revenue',
                      value: '\$${totalRevenue.toStringAsFixed(0)}',
                      icon: LucideIcons.banknote,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _StatCard(
                      label: 'Bookings',
                      value: '$totalBookings',
                      icon: LucideIcons.calendarCheck,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _StatCard(
                label: 'Online Providers',
                value: '$onlineProviders',
                icon: LucideIcons.users,
                color: Colors.orange,
              ),
              const SizedBox(height: 32),

              Text(
                'Data Management',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              // Provider Management
              _ManagementItem(
                title: 'Service Provider Management',
                subtitle: 'Manage all professional profiles',
                icon: LucideIcons.userPlus,
                onTap: () {
                  LogService.screenOpened('ProviderManagementScreen');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProviderManagementScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // Lounge Management
              _ManagementItem(
                title: 'Lounge Management',
                subtitle: 'Manage premium lounge spaces',
                icon: LucideIcons.armchair,
                onTap: () {
                  LogService.screenOpened('LoungeManagementScreen');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoungeManagementScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              // Booking Management
              _ManagementItem(
                title: 'Booking Management',
                subtitle: 'Track active and past services',
                icon: LucideIcons.history,
                onTap: () {
                  LogService.screenOpened('BookingManagementScreen');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BookingManagementScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              // Revenue Tracking
              _ManagementItem(
                title: 'Revenue Analytics',
                subtitle: 'Analyze earnings and growth',
                icon: LucideIcons.lineChart,
                onTap: () {
                  LogService.screenOpened('RevenueAnalyticsScreen');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RevenueAnalyticsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassBox(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _ManagementItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _ManagementItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: _GlassBox(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.amber, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(LucideIcons.chevronRight, color: Colors.white24),
          ],
        ),
      ),
    );
  }
}

class _GlassBox extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _GlassBox({
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.1),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
