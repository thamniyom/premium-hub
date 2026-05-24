import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/services/log_service.dart';
import 'provider_table_screen.dart';
import 'user_management_table_screen.dart';
import 'transaction_registry_screen.dart';
import 'combo_box_table_screen.dart';
import 'lounge_table_screen.dart';

class BackOfficeScreen extends StatelessWidget {
  const BackOfficeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LogService.screenLoad('BackOfficeScreen');
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('BackOffice Portal'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Data Registries',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Manage core application data in tabular format.',
                style: TextStyle(color: Colors.white54),
              ),
              const SizedBox(height: 32),

              _BackOfficeLink(
                title: 'Provider Management Table',
                subtitle: 'Manage names, category and ratings',
                icon: LucideIcons.table,
                onTap: () {
                  LogService.screenOpened('ProviderTableScreen');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProviderTableScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              _BackOfficeLink(
                title: 'User Management Table',
                subtitle: 'Review customer and provider accounts',
                icon: LucideIcons.users,
                onTap: () {
                  LogService.screenOpened('UserManagementTableScreen');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserManagementTableScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              _BackOfficeLink(
                title: 'ComboBox Management Table',
                subtitle: 'Manage categories and configurations',
                icon: LucideIcons.list,
                onTap: () {
                  LogService.screenOpened('ComboBoxTableScreen');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ComboBoxTableScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              _BackOfficeLink(
                title: 'Lounge Management Table',
                subtitle: 'Manage premium lounge spaces',
                icon: LucideIcons.armchair,
                onTap: () {
                  LogService.screenOpened('LoungeTableScreen');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoungeTableScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              _BackOfficeLink(
                title: 'Transaction Registry',
                subtitle: 'Verify system-wide financial movements',
                icon: LucideIcons.fileSpreadsheet,
                onTap: () {
                  LogService.screenOpened('TransactionRegistryScreen');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TransactionRegistryScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 48),
              const Text(
                'System Status',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const _SystemHealthCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackOfficeLink extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _BackOfficeLink({
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
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.amber, size: 24),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white54, fontSize: 13),
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

class _SystemHealthCard extends StatelessWidget {
  const _SystemHealthCard();

  @override
  Widget build(BuildContext context) {
    return _GlassBox(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _HealthRow(
            label: 'Server API',
            status: 'Online',
            color: Colors.green,
          ),
          const Divider(color: Colors.white10, height: 24),
          _HealthRow(label: 'Database', status: 'Healthy', color: Colors.green),
          const Divider(color: Colors.white10, height: 24),
          _HealthRow(label: 'Storage', status: '92% Free', color: Colors.amber),
        ],
      ),
    );
  }
}

class _HealthRow extends StatelessWidget {
  final String label;
  final String status;
  final Color color;

  const _HealthRow({
    required this.label,
    required this.status,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              status,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GlassBox extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _GlassBox({required this.child, this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
