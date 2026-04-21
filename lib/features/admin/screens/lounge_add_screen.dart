import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/services/log_service.dart';
import '../../services/models/lounge.dart';

class LoungeAddScreen extends StatefulWidget {
  const LoungeAddScreen({super.key});

  @override
  State<LoungeAddScreen> createState() => _LoungeAddScreenState();
}

class _LoungeAddScreenState extends State<LoungeAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController(
      text:
          'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?q=80&w=2600&auto=format&fit=crop');
  final _descriptionController = TextEditingController();

  bool _isOpen = false;

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveLounge() {
    if (_formKey.currentState!.validate()) {
      final newLounge = Lounge(
        id: 'l-${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        category: _categoryController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
        rating: 5.0,
        reviewCount: 0,
        description: _descriptionController.text.trim(),
        pricePerEntry: double.parse(_priceController.text.trim()),
        isOpen: _isOpen,
        amenities: const [],
      );

      LogService.info('Creating new lounge: ${newLounge.id}');
      Navigator.pop(context, newLounge);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Add New Lounge'),
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
                // Image Preview
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: Colors.amber.withValues(alpha: 0.3)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        _imageUrlController.text,
                        width: 120,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 120,
                          height: 80,
                          color: Colors.white10,
                          child: const Icon(LucideIcons.image,
                              size: 40, color: Colors.amber),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                _LabelText('Lounge Name'),
                _GlassInput(
                  controller: _nameController,
                  hint: 'Enter lounge name',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Name is required' : null,
                ),
                const SizedBox(height: 20),

                _LabelText('Category'),
                _GlassInput(
                  controller: _categoryController,
                  hint: 'e.g. VIP Lounge, Rooftop Lounge...',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Category is required' : null,
                ),
                const SizedBox(height: 20),

                _LabelText('Entry Fee (\$)'),
                _GlassInput(
                  controller: _priceController,
                  hint: '0.00',
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      double.tryParse(v ?? '') == null ? 'Invalid price' : null,
                ),
                const SizedBox(height: 20),

                _LabelText('Image URL'),
                _GlassInput(
                  controller: _imageUrlController,
                  hint: 'https://...',
                  onChanged: (v) => setState(() {}),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Image URL is required' : null,
                ),
                const SizedBox(height: 20),

                _LabelText('Description'),
                _GlassInput(
                  controller: _descriptionController,
                  hint: 'Describe the lounge experience...',
                  maxLines: 4,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Description is required' : null,
                ),
                const SizedBox(height: 20),

                // Open Status Toggle
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Open on Launch',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Switch(
                        value: _isOpen,
                        onChanged: (v) => setState(() => _isOpen = v),
                        activeThumbColor: Colors.amber,
                        activeTrackColor:
                            Colors.amber.withValues(alpha: 0.3),
                        inactiveThumbColor: Colors.white24,
                        inactiveTrackColor: Colors.white10,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _saveLounge,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Create Lounge',
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
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
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
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
