import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/services/log_service.dart';
import '../../services/models/service_provider.dart';

class ProviderEditScreen extends StatefulWidget {
  final ServiceProvider provider;

  const ProviderEditScreen({super.key, required this.provider});

  @override
  State<ProviderEditScreen> createState() => _ProviderEditScreenState();
}

class _ProviderEditScreenState extends State<ProviderEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _priceController;
  late TextEditingController _imageUrlController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.provider.name);
    _categoryController = TextEditingController(text: widget.provider.category);
    _priceController =
        TextEditingController(text: widget.provider.pricePerHour.toString());
    _imageUrlController = TextEditingController(text: widget.provider.imageUrl);
    _descriptionController =
        TextEditingController(text: widget.provider.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final updatedProvider = ServiceProvider(
        id: widget.provider.id,
        name: _nameController.text,
        category: _categoryController.text,
        imageUrl: _imageUrlController.text,
        rating: widget.provider.rating,
        reviewCount: widget.provider.reviewCount,
        description: _descriptionController.text,
        pricePerHour: double.parse(_priceController.text),
        isOnline: widget.provider.isOnline,
      );

      LogService.info('Saving changes for provider: ${updatedProvider.id}');
      Navigator.pop(context, updatedProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Edit Provider Profile'),
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
                // Profile Image Preview
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(_imageUrlController.text),
                        onBackgroundImageError: (error, stackTrace) =>
                            const Icon(Icons.person, size: 50),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(LucideIcons.camera,
                              size: 16, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                _LabelText('Full Name'),
                _GlassInput(
                  controller: _nameController,
                  hint: 'Enter full name',
                  validator: (v) => v!.isEmpty ? 'Name is required' : null,
                ),
                const SizedBox(height: 20),

                _LabelText('Category'),
                _GlassInput(
                  controller: _categoryController,
                  hint: 'e.g. Booking, Payment, Salon',
                  validator: (v) => v!.isEmpty ? 'Category is required' : null,
                ),
                const SizedBox(height: 20),

                _LabelText('Price Per Hour (\$)'),
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
                  hint: 'Tell us about the provider...',
                  maxLines: 4,
                  validator: (v) => v!.isEmpty ? 'Description is required' : null,
                ),
                const SizedBox(height: 40),

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
