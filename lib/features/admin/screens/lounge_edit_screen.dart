import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/services/log_service.dart';
import '../../services/models/lounge.dart';

class LoungeEditScreen extends StatefulWidget {
  final Lounge lounge;

  const LoungeEditScreen({super.key, required this.lounge});

  @override
  State<LoungeEditScreen> createState() => _LoungeEditScreenState();
}

class _LoungeEditScreenState extends State<LoungeEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _priceController;
  late TextEditingController _imageUrlController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.lounge.name);
    _categoryController = TextEditingController(text: widget.lounge.category);
    _priceController =
        TextEditingController(text: widget.lounge.pricePerEntry.toString());
    _imageUrlController = TextEditingController(text: widget.lounge.imageUrl);
    _descriptionController =
        TextEditingController(text: widget.lounge.description);
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
      final updatedLounge = Lounge(
        id: widget.lounge.id,
        name: _nameController.text,
        category: _categoryController.text,
        imageUrl: _imageUrlController.text,
        rating: widget.lounge.rating,
        reviewCount: widget.lounge.reviewCount,
        description: _descriptionController.text,
        pricePerEntry: double.parse(_priceController.text),
        isOpen: widget.lounge.isOpen,
      );

      LogService.info('Saving changes for lounge: ${updatedLounge.id}');
      Navigator.pop(context, updatedLounge);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                _GlassInput(
                  controller: _categoryController,
                  hint: 'e.g. VIP Lounge, Rooftop',
                  validator: (v) => v!.isEmpty ? 'Category is required' : null,
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
