import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:premium_hub/features/admin/models/combo_box.dart';
import 'package:premium_hub/features/services/models/provider.dart';
import 'package:premium_hub/features/services/models/lounge.dart';
import 'package:premium_hub/features/bookings/screens/booking_form_screen.dart';
import '../../../core/widgets/glass_card.dart';

class BookingFormLoungeProviderScreen extends StatefulWidget {
  const BookingFormLoungeProviderScreen({super.key});

  @override
  State<BookingFormLoungeProviderScreen> createState() =>
      _BookingFormLoungeProviderScreenState();
}

class _BookingFormLoungeProviderScreenState
    extends State<BookingFormLoungeProviderScreen> {
  // In a real app these would be fetched from a service.
  final List<Lounge> _lounges = [
    Lounge(
      documentId: '1',
      name: 'Premium Lounge',
      imageUrl: '',
      category: ComboBox(type: "type", name: "name"),
      pricePerHour: 500,
      rating: 0,
      reviewCount: 0,
      description: '',
    ),
    Lounge(
      documentId: '2',
      name: 'Executive Lounge',
      imageUrl: '',
      category: ComboBox(type: "type", name: "name"),
      pricePerHour: 800,
      rating: 0,
      reviewCount: 0,
      description: '',
    ),
    Lounge(
      documentId: '3',
      name: 'Private Lounge',
      imageUrl: '',
      category: ComboBox(type: "type", name: "name"),
      pricePerHour: 1000,
      rating: 0,
      reviewCount: 0,
      description: '',
    ),
  ];

  final List<Provider> _providers = [
    Provider(
      documentId: 'p1',
      name: 'John Doe',
      imageUrl: '',
      category: ComboBox(type: "type", name: "name"),
      pricePerHour: 220,
      rating: 0,
      reviewCount: 0,
      description: '',
      id: '',
    ),
    Provider(
      documentId: 'p2',
      name: 'Jane Smith',
      imageUrl: '',
      category: ComboBox(type: "type", name: "name"),
      pricePerHour: 330,
      rating: 0,
      reviewCount: 0,
      description: '',
      id: '',
    ),
    Provider(
      documentId: 'p3',
      name: 'Jane Smith',
      imageUrl: '',
      category: ComboBox(type: "type", name: "name"),
      pricePerHour: 440,
      rating: 0,
      reviewCount: 0,
      description: '',
      id: '',
    ),
  ];

  Lounge? _selectedLounge;
  final List<Provider> _selectedProviders = [];

  void _showProviderMultiSelect() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[950],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select Providers',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.x, color: Colors.white70),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _providers.length,
                      itemBuilder: (context, index) {
                        final provider = _providers[index];
                        final isSelected = _selectedProviders.contains(
                          provider,
                        );
                        return InkWell(
                          onTap: () {
                            setSheetState(() {
                              if (isSelected) {
                                _selectedProviders.remove(provider);
                              } else {
                                _selectedProviders.add(provider);
                              }
                            });
                            setState(() {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Colors.white24,
                                  child: provider.imageUrl.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                          child: Image.network(
                                            provider.imageUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const Icon(
                                                      LucideIcons.user,
                                                      color: Colors.amber,
                                                    ),
                                          ),
                                        )
                                      : const Icon(
                                          LucideIcons.user,
                                          color: Colors.amber,
                                        ),
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
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        provider.category.name,
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.amber
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.amber
                                          : Colors.grey[600]!,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: isSelected
                                      ? const Icon(
                                          LucideIcons.check,
                                          color: Colors.black,
                                          size: 16,
                                        )
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Select Lounge & Provider'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose a Lounge',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            GlassCard(
              padding: const EdgeInsets.all(12),
              child: DropdownButtonFormField<Lounge>(
                value: _selectedLounge,
                items: _lounges
                    .map((l) => DropdownMenuItem(value: l, child: Text(l.name)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedLounge = v),
                decoration: const InputDecoration(border: InputBorder.none),
                dropdownColor: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Choose a Provider',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _showProviderMultiSelect,
              child: GlassCard(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: _selectedProviders.isEmpty
                          ? const Text(
                              'Select Providers',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 16,
                              ),
                            )
                          : Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _selectedProviders.map((provider) {
                                return Chip(
                                  label: Text(
                                    provider.name,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  backgroundColor: Colors.amber,
                                  deleteIconColor: Colors.black87,
                                  onDeleted: () {
                                    setState(() {
                                      _selectedProviders.remove(provider);
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: EdgeInsets.zero,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                );
                              }).toList(),
                            ),
                    ),
                    const Icon(LucideIcons.chevronDown, color: Colors.amber),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed:
                    (_selectedLounge != null && _selectedProviders.isNotEmpty)
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookingFormScreen(
                              lounge: _selectedLounge,
                              providers: _selectedProviders,
                            ),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
