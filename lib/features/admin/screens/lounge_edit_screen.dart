import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:premium_hub/features/admin/models/combo_box.dart';
import '../../../core/services/log_service.dart';
import '../../services/models/lounge.dart';
import '../services/lounge_service.dart';
import '../services/combo_box_service.dart';

class LoungeEditScreen extends StatefulWidget {
  final Lounge lounge;

  const LoungeEditScreen({super.key, required this.lounge});

  @override
  State<LoungeEditScreen> createState() => _LoungeEditScreenState();
}

class _LoungeEditScreenState extends State<LoungeEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final LoungeService _service = LoungeService();
  final ComboBoxService _comboBoxService = ComboBoxService();
  List<ComboBox> _categories = [];
  ComboBox? _selectedCategory;
  bool _isLoadingCategories = true;

  List<ComboBox> _selectedAmenities = [];
  List<ComboBox> _availableAmenities = [];
  bool _isLoadingAmenities = true;

  bool _isSaving = false;
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _imageUrlController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _selectedAmenities = List.from(widget.lounge.amenities);
    _loadAmenities();
    _nameController = TextEditingController(text: widget.lounge.name);
    _priceController = TextEditingController(
      text: widget.lounge.pricePerHour.toString(),
    );
    _imageUrlController = TextEditingController(text: widget.lounge.imageUrl);
    _descriptionController = TextEditingController(
      text: widget.lounge.description,
    );
  }

  Future<void> _loadCategories() async {
    try {
      final cats = await _comboBoxService.getLoungeCategories();
      setState(() {
        _categories = cats;
        _isLoadingCategories = false;

        try {
          if (widget.lounge.category.documentId != null) {
            _selectedCategory = _categories.firstWhere(
              (c) => c.documentId == widget.lounge.category.documentId,
            );
          } else {
            _selectedCategory = _categories.firstWhere(
              (c) => c.name == widget.lounge.category.name,
            );
          }
        } catch (_) {
          if (widget.lounge.category.name.isNotEmpty) {
            _categories.insert(0, widget.lounge.category);
            _selectedCategory = widget.lounge.category;
          } else if (_categories.isNotEmpty) {
            _selectedCategory = _categories.first;
          }
        }
      });
    } catch (e) {
      LogService.error('Failed to load categories: $e');
      setState(() {
        _isLoadingCategories = false;
      });
    }
  }

  Future<void> _loadAmenities() async {
    try {
      final amenities = await _comboBoxService.getLoungeAmenity();
      setState(() {
        _availableAmenities = amenities;
        _isLoadingAmenities = false;
      });
    } catch (e) {
      LogService.error('Failed to load amenities: $e');
      setState(() {
        _isLoadingAmenities = false;
      });
    }
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

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a category')));
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      final updatedLounge = Lounge(
        id: widget.lounge.id,
        documentId: widget.lounge.documentId,
        name: _nameController.text,
        category: _selectedCategory!,
        imageUrl: _imageUrlController.text,
        rating: widget.lounge.rating,
        reviewCount: widget.lounge.reviewCount,
        description: _descriptionController.text,
        pricePerHour: double.parse(_priceController.text),
        isOpen: widget.lounge.isOpen,
        amenities: _selectedAmenities,
      );

      try {
        LogService.info('Saving changes for lounge: ${updatedLounge.id}');
        if (updatedLounge.documentId != null) {
          await _service.updateLounge(updatedLounge.documentId!, updatedLounge);
        } else {
          await _service.createLounge(updatedLounge);
        }
        if (mounted) {
          Navigator.pop(context, updatedLounge);
        }
      } catch (e) {
        LogService.error('Failed to save lounge: $e');
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to save: $e')));
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSaving = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    LogService.screenLoad('LoungeEditScreen');
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Edit Lounge Details'),
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Lounge Image Preview
                Center(
                  child: Container(
                    width: 200,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: NetworkImage(_imageUrlController.text),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(color: Colors.white24),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                _LabelText('Lounge Name'),
                _GlassInput(
                  controller: _nameController,
                  hint: 'Enter lounge name',
                  validator: (v) => v!.isEmpty ? 'Name is required' : null,
                ),
                const SizedBox(height: 20),

                _LabelText('Category'),
                if (_isLoadingCategories)
                  const Center(
                    child: CircularProgressIndicator(color: Colors.amber),
                  )
                else
                  _GlassDropdown(
                    value: _selectedCategory,
                    items: _categories,
                    hint: 'Select Category',
                    onChanged: (ComboBox? value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                const SizedBox(height: 20),

                _LabelText('Price Per Entry (\$)'),
                _GlassInput(
                  controller: _priceController,
                  hint: '0.00',
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      double.tryParse(v!) == null ? 'Invalid price' : null,
                ),
                const SizedBox(height: 20),

                _LabelText('Image URL'),
                _GlassInput(
                  controller: _imageUrlController,
                  hint: 'https://...',
                  onChanged: (v) => setState(() {}),
                  validator: (v) => v!.isEmpty ? 'Image URL is required' : null,
                ),
                const SizedBox(height: 20),

                _LabelText('Description'),
                _GlassInput(
                  controller: _descriptionController,
                  hint: 'Tell us about the lounge...',
                  maxLines: 4,
                  validator: (v) =>
                      v!.isEmpty ? 'Description is required' : null,
                ),
                const SizedBox(height: 20),

                _LabelText('Amenities'),
                if (_isLoadingAmenities)
                  const Center(
                    child: CircularProgressIndicator(color: Colors.amber),
                  )
                else
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _availableAmenities.map((amenity) {
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
                  ),
                const SizedBox(height: 40),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Save Changes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassDropdown extends StatelessWidget {
  final ComboBox? value;
  final List<ComboBox> items;
  final String hint;
  final void Function(ComboBox?) onChanged;

  const _GlassDropdown({
    required this.value,
    required this.items,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ComboBox>(
          value: value,
          isExpanded: true,
          dropdownColor: const Color(0xFF2A2A2A),
          hint: Text(
            hint,
            style: const TextStyle(color: Colors.white24, fontSize: 14),
          ),
          icon: const Icon(LucideIcons.chevronDown, color: Colors.white54),
          style: const TextStyle(color: Colors.white),
          items: items.map((ComboBox item) {
            return DropdownMenuItem<ComboBox>(
              value: item,
              child: Text(item.name),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _LabelText extends StatelessWidget {
  final String text;
  const _LabelText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _GlassInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  const _GlassInput({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
