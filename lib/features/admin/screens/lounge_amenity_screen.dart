import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/services/log_service.dart';
import '../../admin/models/combo_box.dart';
import '../../services/models/lounge.dart';
import '../services/combo_box_service.dart';

class LoungeAmenityScreen extends StatefulWidget {
  final Lounge lounge;

  const LoungeAmenityScreen({super.key, required this.lounge});

  @override
  State<LoungeAmenityScreen> createState() => _LoungeAmenityScreenState();
}

class _LoungeAmenityScreenState extends State<LoungeAmenityScreen> {
  late List<ComboBox> _selectedAmenities;
  final TextEditingController _customController = TextEditingController();
  final ComboBoxService _comboBoxService = ComboBoxService();
  List<ComboBox> _commonAmenities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedAmenities = List.from(widget.lounge.amenities);
    _loadAmenities();
  }

  Future<void> _loadAmenities() async {
    try {
      final amenities = await _comboBoxService.getLoungeAmenity();
      setState(() {
        _commonAmenities = amenities;
        _isLoading = false;
      });
    } catch (e) {
      LogService.error('Failed to load amenities: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  void _toggleAmenity(ComboBox amenity) {
    setState(() {
      final existingIndex = _selectedAmenities.indexWhere(
        (a) => a.name == amenity.name,
      );
      if (existingIndex != -1) {
        _selectedAmenities.removeAt(existingIndex);
      } else {
        _selectedAmenities.add(amenity);
      }
    });
  }

  void _addCustomAmenity() {
    final text = _customController.text.trim();
    if (text.isNotEmpty && !_selectedAmenities.any((a) => a.name == text)) {
      setState(() {
        _selectedAmenities.add(ComboBox(type: 'amenity', name: text));
        _customController.clear();
      });
    }
  }

  void _saveChanges() {
    final updatedLounge = Lounge(
      id: widget.lounge.id,
      name: widget.lounge.name,
      category: widget.lounge.category,
      imageUrl: widget.lounge.imageUrl,
      rating: widget.lounge.rating,
      reviewCount: widget.lounge.reviewCount,
      description: widget.lounge.description,
      pricePerHour: widget.lounge.pricePerHour,
      isOpen: widget.lounge.isOpen,
      amenities: _selectedAmenities,
    );

    LogService.info('Saving amenities for lounge: ${updatedLounge.id}');
    Navigator.pop(context, updatedLounge);
  }

  @override
  Widget build(BuildContext context) {
    LogService.screenLoad('LoungeAmenityScreen');
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Manage Amenities'),
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
              Text(
                widget.lounge.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select the amenities available in this lounge.',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
              ),
              const SizedBox(height: 32),

              // Common Amenities
              const Text(
                'Common Amenities',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              if (_isLoading)
                const CircularProgressIndicator(color: Colors.amber)
              else
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _commonAmenities.map((amenity) {
                    final isSelected = _selectedAmenities.any(
                      (a) => a.name == amenity.name,
                    );
                    return FilterChip(
                      label: Text(amenity.name),
                      selected: isSelected,
                      onSelected: (_) => _toggleAmenity(amenity),
                      backgroundColor: Colors.white.withValues(alpha: 0.05),
                      selectedColor: Colors.amber.withValues(alpha: 0.2),
                      checkmarkColor: Colors.amber,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.amber : Colors.white70,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected
                              ? Colors.amber.withValues(alpha: 0.5)
                              : Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 32),

              // Custom Amenities
              const Text(
                'Custom Amenities',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              if (_selectedAmenities.any(
                (a) => !_commonAmenities.any((c) => c.name == a.name),
              ))
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _selectedAmenities
                      .where(
                        (a) => !_commonAmenities.any((c) => c.name == a.name),
                      )
                      .map((amenity) {
                        return Chip(
                          label: Text(amenity.name),
                          backgroundColor: Colors.blueAccent.withValues(
                            alpha: 0.1,
                          ),
                          labelStyle: const TextStyle(color: Colors.blueAccent),
                          deleteIcon: const Icon(
                            LucideIcons.x,
                            size: 14,
                            color: Colors.blueAccent,
                          ),
                          onDeleted: () => _toggleAmenity(amenity),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Colors.blueAccent.withValues(alpha: 0.3),
                            ),
                          ),
                        );
                      })
                      .toList(),
                ),
              const SizedBox(height: 16),
              _GlassInput(
                controller: _customController,
                hint: 'Add custom amenity...',
                suffixIcon: IconButton(
                  icon: const Icon(LucideIcons.plus, color: Colors.amber),
                  onPressed: _addCustomAmenity,
                ),
                onSubmitted: (_) => _addCustomAmenity(),
              ),
              const SizedBox(height: 48),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Widget? suffixIcon;
  final Function(String)? onSubmitted;

  const _GlassInput({
    required this.controller,
    required this.hint,
    this.suffixIcon,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          border: InputBorder.none,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
