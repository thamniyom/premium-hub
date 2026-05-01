import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/services/log_service.dart';
import '../models/combo_box.dart';
import '../services/combo_box_service.dart';

class ComboBoxEditScreen extends StatefulWidget {
  final ComboBox? comboBox;

  const ComboBoxEditScreen({super.key, this.comboBox});

  @override
  State<ComboBoxEditScreen> createState() => _ComboBoxEditScreenState();
}

class _ComboBoxEditScreenState extends State<ComboBoxEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final ComboBoxService _service = ComboBoxService();

  late TextEditingController _typeController;
  late TextEditingController _nameController;
  late TextEditingController _valueStrController;
  late TextEditingController _valueIntController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _typeController = TextEditingController(text: widget.comboBox?.type ?? '');
    _nameController = TextEditingController(text: widget.comboBox?.name ?? '');
    _valueStrController = TextEditingController(text: widget.comboBox?.valueStr ?? '');
    _valueIntController = TextEditingController(text: widget.comboBox?.valueInt?.toString() ?? '');
  }

  @override
  void dispose() {
    _typeController.dispose();
    _nameController.dispose();
    _valueStrController.dispose();
    _valueIntController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final box = ComboBox(
      type: _typeController.text,
      name: _nameController.text,
      valueStr: _valueStrController.text.isEmpty ? null : _valueStrController.text,
      valueInt: _valueIntController.text.isEmpty ? null : int.tryParse(_valueIntController.text),
    );

    try {
      if (widget.comboBox?.documentId != null) {
        // Update
        await _service.updateComboBox(widget.comboBox!.documentId!, box);
      } else {
        // Create
        await _service.createComboBox(box);
      }
      
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      LogService.error('Failed to save combo box: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.comboBox != null;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit ComboBox' : 'Add ComboBox'),
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _GlassBox(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _typeController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Type',
                          labelStyle: TextStyle(color: Colors.white54),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                        ),
                        validator: (value) => value == null || value.isEmpty ? 'Type is required' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(color: Colors.white54),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                        ),
                        validator: (value) => value == null || value.isEmpty ? 'Name is required' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _valueStrController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Value (String)',
                          labelStyle: TextStyle(color: Colors.white54),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _valueIntController,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Value (Int)',
                          labelStyle: TextStyle(color: Colors.white54),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                        ),
                        validator: (value) {
                          if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                            return 'Must be a valid integer';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                      : Text(
                          isEditing ? 'Save Changes' : 'Create ComboBox',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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

class _GlassBox extends StatelessWidget {
  final Widget child;

  const _GlassBox({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: child,
    );
  }
}
