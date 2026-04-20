import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/services/log_service.dart';
import '../../services/models/service_provider.dart';
import 'provider_edit_screen.dart';
import 'provider_service_history_screen.dart';

class ProviderManagementScreen extends StatefulWidget {
  const ProviderManagementScreen({super.key});

  @override
  State<ProviderManagementScreen> createState() =>
      _ProviderManagementScreenState();
}

class _ProviderManagementScreenState extends State<ProviderManagementScreen> {
  late List<ServiceProvider> _allProviders;
  late List<ServiceProvider> _filteredProviders;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _allProviders = List.from(demoProviders);
    _filteredProviders = List.from(demoProviders);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProviders(String query) {
    setState(() {
      _filteredProviders = _allProviders
          .where((p) =>
              p.name.toLowerCase().contains(query.toLowerCase()) ||
              p.category.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _toggleStatus(int index) {
    setState(() {
      final p = _filteredProviders[index];
      final updatedProvider = ServiceProvider(
        id: p.id,
        name: p.name,
        category: p.category,
        imageUrl: p.imageUrl,
        rating: p.rating,
        reviewCount: p.reviewCount,
        description: p.description,
        pricePerHour: p.pricePerHour,
        isOnline: !p.isOnline,
      );

      // Update filtered list
      _filteredProviders[index] = updatedProvider;
      
      // Update master list
      final masterIndex = _allProviders.indexWhere((item) => item.id == p.id);
      if (masterIndex != -1) {
        _allProviders[masterIndex] = updatedProvider;
      }
    });

    LogService.providerTapped(
      _filteredProviders[index].id,
      'Status changed: ${_filteredProviders[index].isOnline ? 'Online' : 'Offline'}',
    );
  }

  void _updateProvider(ServiceProvider updatedProvider) {
    setState(() {
      // Update master list
      final masterIndex =
          _allProviders.indexWhere((p) => p.id == updatedProvider.id);
      if (masterIndex != -1) {
        _allProviders[masterIndex] = updatedProvider;
      }

      // Update filtered list (if it's currently showing)
      final filteredIndex =
          _filteredProviders.indexWhere((p) => p.id == updatedProvider.id);
      if (filteredIndex != -1) {
        _filteredProviders[filteredIndex] = updatedProvider;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Provider Management'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
          onPressed: () {
            LogService.screenPopped('ProviderManagementScreen');
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: _GlassBox(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterProviders,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Search provider name or category...',
                    hintStyle: TextStyle(color: Colors.white24),
                    icon: Icon(LucideIcons.search, color: Colors.amber, size: 20),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            // Provider List
            Expanded(
              child: _filteredProviders.isEmpty
                  ? const Center(
                      child: Text(
                        'No providers found',
                        style: TextStyle(color: Colors.white54),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: _filteredProviders.length,
                      itemBuilder: (context, index) {
                        final provider = _filteredProviders[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: _GlassBox(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 28,
                                      backgroundImage:
                                          NetworkImage(provider.imageUrl),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            provider.name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            provider.category,
                                            style: const TextStyle(
                                              color: Colors.white54,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Switch(
                                      value: provider.isOnline,
                                      onChanged: (_) => _toggleStatus(index),
                                      activeColor: Colors.green,
                                      activeTrackColor:
                                          Colors.green.withValues(alpha: 0.2),
                                      inactiveThumbColor: Colors.white24,
                                      inactiveTrackColor: Colors.white10,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _SmallInfoItem(
                                      label: 'Rating',
                                      value: provider.rating.toString(),
                                      icon: Icons.star,
                                      iconColor: Colors.amber,
                                    ),
                                    _SmallInfoItem(
                                      label: 'Services',
                                      value: provider.reviewCount.toString(),
                                      icon: Icons.history,
                                      iconColor: Colors.blueAccent,
                                    ),
                                    _SmallInfoItem(
                                      label: 'Rate',
                                      value:
                                          '\$${provider.pricePerHour.toStringAsFixed(0)}/h',
                                      icon: Icons.payments,
                                      iconColor: Colors.green,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _ActionBtn(
                                        label: 'Edit Profile',
                                        icon: LucideIcons.pencil,
                                        onTap: () async {
                                          LogService.info(
                                              'Opening edit screen for ${provider.name}');
                                          final updated = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProviderEditScreen(
                                                      provider: provider),
                                            ),
                                          );

                                          if (updated != null &&
                                              updated is ServiceProvider) {
                                            _updateProvider(updated);
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      '${updated.name} updated successfully'),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _ActionBtn(
                                        label: 'History',
                                        icon: LucideIcons.lineChart,
                                        onTap: () {
                                          LogService.info(
                                              'Opening history screen for ${provider.name}');
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProviderServiceHistoryScreen(
                                                      provider: provider),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallInfoItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _SmallInfoItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 14),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white38, fontSize: 11),
        ),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          debugPrint('Provider Action tapped: $label');
          onTap();
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
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
