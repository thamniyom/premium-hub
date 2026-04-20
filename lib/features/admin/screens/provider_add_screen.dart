import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/services/log_service.dart';
import '../../services/models/service_provider.dart';

class ProviderAddScreen extends StatefulWidget {
  const ProviderAddScreen({super.key});

  @override
  State<ProviderAddScreen> createState() => _ProviderAddScreenState();
}

class _ProviderAddScreenState extends State<ProviderAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController(
      text: 'https://images.unsplash.com/photo-1599566150163-29194dcaad36?q=80&w=2574&auto=format&fit=crop');
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveProvider() {
    if (_formKey.currentState!.validate()) {
      final newProvider = ServiceProvider(
        id: 'p-${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text,
        category: _categoryController.text,
        imageUrl: _imageUrlController.text,
        rating: 5.0, // Default for new
        reviewCount: 0,
        description: _descriptionController.text,
        pricePerHour: double.parse(_priceController.text),
        isOnline: false,
      );

      LogService.info('Creating new provider: ${newProvider.id}');
      Navigator.pop(context, newProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Add New Provider'),
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
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(_imageUrlController.text),
                      onBackgroundImageError: (_, __) =>
                          const Icon(Icons.person, size: 50, color: Colors.amber),
                    ),
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
                  hint: 'e.g. VIP Lounge, Massage, etc.',
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
                  hint: 'Describe the services provided...',
                  maxLines: 4,
                  validator: (v) => v!.isEmpty ? 'Description is required' : null,
                ),
                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _saveProvider,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Create Provider',
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
