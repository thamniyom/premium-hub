import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/app_user.dart';
import '../../../core/services/log_service.dart';

class UserAddScreen extends StatefulWidget {
  const UserAddScreen({super.key});

  @override
  State<UserAddScreen> createState() => _UserAddScreenState();
}

class _UserAddScreenState extends State<UserAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _avatarUrlController = TextEditingController(
    text: 'https://randomuser.me/api/portraits/men/32.jpg',
  );

  UserRole _selectedRole = UserRole.customer;
  UserStatus _selectedStatus = UserStatus.active;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _avatarUrlController.dispose();
    super.dispose();
  }

  void _saveUser() {
    if (_formKey.currentState!.validate()) {
      final newUser = AppUser(
        id: 'u-${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        avatarUrl: _avatarUrlController.text.trim(),
        role: _selectedRole,
        status: _selectedStatus,
        joinedAt: DateTime.now(),
      );

      LogService.info('Creating new user: ${newUser.id}');
      Navigator.pop(context, newUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Add New User'),
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
                // ── Avatar Preview ─────────────────────────────────────────
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.amber.withValues(alpha: 0.3)),
                    ),
                    child: CircleAvatar(
                      radius: 48,
                      backgroundImage:
                          NetworkImage(_avatarUrlController.text),
                      backgroundColor: Colors.white10,
                      onBackgroundImageError: (_, __) {},
                      child: _avatarUrlController.text.isEmpty
                          ? const Icon(LucideIcons.user,
                              size: 48, color: Colors.amber)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // ── Full Name ──────────────────────────────────────────────
                _LabelText('Full Name'),
                _GlassInput(
                  controller: _nameController,
                  hint: 'e.g. Alice Morgan',
                  prefixIcon: LucideIcons.user,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Name is required' : null,
                ),
                const SizedBox(height: 20),

                // ── Email ──────────────────────────────────────────────────
                _LabelText('Email Address'),
                _GlassInput(
                  controller: _emailController,
                  hint: 'user@example.com',
                  prefixIcon: LucideIcons.mail,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email is required';
                    if (!v.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // ── Avatar URL ─────────────────────────────────────────────
                _LabelText('Avatar Image URL'),
                _GlassInput(
                  controller: _avatarUrlController,
                  hint: 'https://...',
                  prefixIcon: LucideIcons.image,
                  onChanged: (v) => setState(() {}),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Avatar URL is required' : null,
                ),
                const SizedBox(height: 20),

                // ── Role Selector ──────────────────────────────────────────
                _LabelText('Role'),
                _RoleSelector(
                  selected: _selectedRole,
                  onChanged: (r) => setState(() => _selectedRole = r),
                ),
                const SizedBox(height: 20),

                // ── Status Selector ────────────────────────────────────────
                _LabelText('Status'),
                _StatusSelector(
                  selected: _selectedStatus,
                  onChanged: (s) => setState(() => _selectedStatus = s),
                ),
                const SizedBox(height: 40),

                // ── Save Button ────────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _saveUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Create User',
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

// ── Role Selector ─────────────────────────────────────────────────────────────

class _RoleSelector extends StatelessWidget {
  final UserRole selected;
  final ValueChanged<UserRole> onChanged;

  const _RoleSelector({
    required this.selected,
    required this.onChanged,
  });

  Color _colorFor(UserRole r) {
    switch (r) {
      case UserRole.customer:
        return Colors.blueAccent;
      case UserRole.provider:
        return Colors.amber;
      case UserRole.admin:
        return Colors.purpleAccent;
    }
  }

  IconData _iconFor(UserRole r) {
    switch (r) {
      case UserRole.customer:
        return LucideIcons.user;
      case UserRole.provider:
        return LucideIcons.briefcase;
      case UserRole.admin:
        return LucideIcons.shieldCheck;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: UserRole.values.map((r) {
        final isSelected = r == selected;
        final color = _colorFor(r);
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => onChanged(r),
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
                child: Column(
                  children: [
                    Icon(_iconFor(r),
                        size: 18,
                        color: isSelected ? color : Colors.white38),
                    const SizedBox(height: 4),
                    Text(
                      r.name[0].toUpperCase() + r.name.substring(1),
                      style: TextStyle(
                        color: isSelected ? color : Colors.white38,
                        fontSize: 11,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Status Selector ───────────────────────────────────────────────────────────

class _StatusSelector extends StatelessWidget {
  final UserStatus selected;
  final ValueChanged<UserStatus> onChanged;

  const _StatusSelector({
    required this.selected,
    required this.onChanged,
  });

  Color _colorFor(UserStatus s) {
    switch (s) {
      case UserStatus.active:
        return Colors.green;
      case UserStatus.suspended:
        return Colors.red;
      case UserStatus.pending:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: UserStatus.values.map((s) {
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

// ── Shared Widgets ────────────────────────────────────────────────────────────

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
  final IconData? prefixIcon;
  final int maxLines;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  const _GlassInput({
    required this.controller,
    required this.hint,
    this.prefixIcon,
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
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: Colors.amber, size: 18)
              : null,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
