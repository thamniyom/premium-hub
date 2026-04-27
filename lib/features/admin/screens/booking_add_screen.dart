import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../bookings/models/booking.dart';

class BookingAddScreen extends StatefulWidget {
  const BookingAddScreen({super.key});

  @override
  State<BookingAddScreen> createState() => _BookingAddScreenState();
}

class _BookingAddScreenState extends State<BookingAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _providerNameController = TextEditingController();
  final _serviceTypeController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController(
    text: 'https://randomuser.me/api/portraits/men/32.jpg',
  );

  DateTime _selectedDateTime = DateTime.now().add(const Duration(days: 1));
  BookingStatus _selectedStatus = BookingStatus.upcoming;

  @override
  void dispose() {
    _providerNameController.dispose();
    _serviceTypeController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Colors.amber,
            onPrimary: Colors.black,
            surface: Color(0xFF1E1E1E),
            onSurface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (date != null) {
      setState(() {
        _selectedDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          _selectedDateTime.hour,
          _selectedDateTime.minute,
        );
      });
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Colors.amber,
            onPrimary: Colors.black,
            surface: Color(0xFF1E1E1E),
            onSurface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (time != null) {
      setState(() {
        _selectedDateTime = DateTime(
          _selectedDateTime.year,
          _selectedDateTime.month,
          _selectedDateTime.day,
          time.hour,
          time.minute,
        );
      });
    }
  }

  void _saveBooking() {
    if (_formKey.currentState!.validate()) {
      final newBooking = Booking(
        id: 'b-${DateTime.now().millisecondsSinceEpoch}',
        providerName: _providerNameController.text.trim(),
        serviceType: _serviceTypeController.text.trim(),
        dateTime: _selectedDateTime,
        price: double.parse(_priceController.text.trim()),
        imageUrl: _imageUrlController.text.trim(),
        status: _selectedStatus,
      );

      Navigator.pop(context, newBooking);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('EEE, MMM dd, yyyy').format(_selectedDateTime);
    final timeStr = DateFormat('hh:mm a').format(_selectedDateTime);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Add New Booking'),
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
                // Avatar preview
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.amber.withValues(alpha: 0.3),
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 44,
                      backgroundImage: NetworkImage(_imageUrlController.text),
                      onBackgroundImageError: (_, __) {},
                      backgroundColor: Colors.white10,
                      child: _imageUrlController.text.isEmpty
                          ? const Icon(
                              LucideIcons.user,
                              size: 44,
                              color: Colors.amber,
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                _LabelText('Provider Name'),
                _GlassInput(
                  controller: _providerNameController,
                  hint: 'e.g. Sarah Johnson',
                  validator: (v) => v == null || v.isEmpty
                      ? 'Provider name is required'
                      : null,
                  maxLines: 5,
                ),
                const SizedBox(height: 20),

                _LabelText('Service Type'),
                _GlassInput(
                  controller: _serviceTypeController,
                  hint: 'e.g. Aromatherapy Massage',
                  validator: (v) => v == null || v.isEmpty
                      ? 'Service type is required'
                      : null,
                  maxLines: 5,
                ),
                const SizedBox(height: 20),

                _LabelText('Price (\$)'),
                _GlassInput(
                  controller: _priceController,
                  hint: '0.00',
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      double.tryParse(v ?? '') == null ? 'Invalid price' : null,
                  maxLines: 5,
                ),
                const SizedBox(height: 20),

                _LabelText('Avatar Image URL'),
                _GlassInput(
                  controller: _imageUrlController,
                  hint: 'https://...',
                  onChanged: (v) => setState(() {}),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Image URL is required' : null,
                  maxLines: 5,
                ),
                const SizedBox(height: 20),

                // Date & Time Pickers
                _LabelText('Date & Time'),
                Row(
                  children: [
                    Expanded(
                      child: _PickerTile(
                        icon: LucideIcons.calendar,
                        label: dateStr,
                        onTap: _pickDate,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _PickerTile(
                        icon: LucideIcons.clock,
                        label: timeStr,
                        onTap: _pickTime,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Status Selector
                _LabelText('Status'),
                _GlassStatusSelector(
                  selected: _selectedStatus,
                  onChanged: (s) => setState(() => _selectedStatus = s),
                ),
                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _saveBooking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Create Booking',
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

// ── Picker Tile ──────────────────────────────────────────────────────────────

class _PickerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PickerTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.amber),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Status Selector ──────────────────────────────────────────────────────────

class _GlassStatusSelector extends StatelessWidget {
  final BookingStatus selected;
  final ValueChanged<BookingStatus> onChanged;

  const _GlassStatusSelector({required this.selected, required this.onChanged});

  Color _colorFor(BookingStatus s) {
    switch (s) {
      case BookingStatus.upcoming:
        return Colors.orange;
      case BookingStatus.completed:
        return Colors.green;
      case BookingStatus.cancelled:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: BookingStatus.values.map((s) {
        final isSelected = s == selected;
        final color = _colorFor(s);
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => onChanged(s),
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? color.withValues(alpha: 0.15)
                      : Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? color.withValues(alpha: 0.5)
                        : Colors.white.withValues(alpha: 0.08),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Text(
                  s.name[0].toUpperCase() + s.name.substring(1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? color : Colors.white38,
                    fontSize: 12,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Shared Widgets ───────────────────────────────────────────────────────────

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
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    required this.maxLines,
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
