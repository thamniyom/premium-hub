import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/services/log_service.dart';
import '../../services/models/lounge.dart';
import 'lounge_edit_screen.dart';
import 'lounge_amenities_screen.dart';

class LoungeManagementScreen extends StatefulWidget {
  const LoungeManagementScreen({super.key});

  @override
  State<LoungeManagementScreen> createState() =>
      _LoungeManagementScreenState();
}

class _LoungeManagementScreenState extends State<LoungeManagementScreen> {
  late List<Lounge> _allLounges;
  late List<Lounge> _filteredLounges;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _allLounges = List.from(demoLounges);
    _filteredLounges = List.from(demoLounges);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterLounges(String query) {
    setState(() {
      _filteredLounges = _allLounges
          .where((l) =>
              l.name.toLowerCase().contains(query.toLowerCase()) ||
              l.category.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _toggleStatus(int index) {
    setState(() {
      final l = _filteredLounges[index];
      final updatedLounge = Lounge(
        id: l.id,
        name: l.name,
        category: l.category,
        imageUrl: l.imageUrl,
        rating: l.rating,
        reviewCount: l.reviewCount,
        description: l.description,
        pricePerEntry: l.pricePerEntry,
        isOpen: !l.isOpen,
      );

      // Update filtered list
      _filteredLounges[index] = updatedLounge;
      
      // Update master list
      final masterIndex = _allLounges.indexWhere((item) => item.id == l.id);
      if (masterIndex != -1) {
        _allLounges[masterIndex] = updatedLounge;
      }
    });

    LogService.providerTapped(
      _filteredLounges[index].id,
      'Lounge Status changed: ${_filteredLounges[index].isOpen ? 'Open' : 'Closed'}',
    );
  }

  void _updateLounge(Lounge updatedLounge) {
    setState(() {
      // Update master list
      final masterIndex =
          _allLounges.indexWhere((l) => l.id == updatedLounge.id);
      if (masterIndex != -1) {
        _allLounges[masterIndex] = updatedLounge;
      }

      // Update filtered list (if it's currently showing)
      final filteredIndex =
          _filteredLounges.indexWhere((l) => l.id == updatedLounge.id);
      if (filteredIndex != -1) {
        _filteredLounges[filteredIndex] = updatedLounge;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Lounge Management'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
          onPressed: () {
            LogService.screenPopped('LoungeManagementScreen');
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
                  onChanged: _filterLounges,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Search lounge name or category...',
                    hintStyle: TextStyle(color: Colors.white24),
                    icon: Icon(LucideIcons.search, color: Colors.amber, size: 20),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            // Lounge List
            Expanded(
              child: _filteredLounges.isEmpty
                  ? const Center(
                      child: Text(
                        'No lounges found',
                        style: TextStyle(color: Colors.white54),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: _filteredLounges.length,
                      itemBuilder: (context, index) {
                        final lounge = _filteredLounges[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: _GlassBox(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        lounge.imageUrl,
                                        width: 56,
                                        height: 56,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            lounge.name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            lounge.category,
                                            style: const TextStyle(
                                              color: Colors.white54,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Switch(
                                      value: lounge.isOpen,
                                      onChanged: (_) => _toggleStatus(index),
                                      activeThumbColor: Colors.amber,
                                      activeTrackColor: Colors.amber.withValues(alpha: 0.3),
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
                                      value: lounge.rating.toString(),
                                      icon: Icons.star,
                                      iconColor: Colors.amber,
                                    ),
                                    _SmallInfoItem(
                                      label: 'Reviews',
                                      value: lounge.reviewCount.toString(),
                                      icon: LucideIcons.messageSquare,
                                      iconColor: Colors.blueAccent,
                                    ),
                                    _SmallInfoItem(
                                      label: 'Entry Fee',
                                      value:
                                          '\$${lounge.pricePerEntry.toStringAsFixed(0)}',
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
                                        label: 'Edit Details',
                                        icon: LucideIcons.pencil,
                                        onTap: () async {
                                          LogService.info(
                                              'Opening edit screen for lounge: ${lounge.name}');
                                          final updated = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  LoungeEditScreen(
                                                      lounge: lounge),
                                            ),
                                          );

                                          if (updated != null &&
                                              updated is Lounge) {
                                            _updateLounge(updated);
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
                                        label: 'Amenities',
                                        icon: LucideIcons.layoutGrid,
                                        onTap: () async {
                                          LogService.info(
                                              'Opening amenities screen for lounge: ${lounge.name}');
                                          final updated = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  LoungeAmenitiesScreen(
                                                      lounge: lounge),
                                            ),
                                          );

                                          if (updated != null &&
                                              updated is Lounge) {
                                            _updateLounge(updated);
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Amenities for ${updated.name} updated'),
                                                  backgroundColor: Colors.amber,
                                                ),
                                              );
                                            }
                                          }
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
          debugPrint('Lounge Action tapped: $label');
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
