import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/services/log_service.dart';
import '../models/combo_box.dart';
import '../services/combo_box_service.dart';
import 'combo_box_edit_screen.dart';

class ComboBoxManagementScreen extends StatefulWidget {
  const ComboBoxManagementScreen({super.key});

  @override
  State<ComboBoxManagementScreen> createState() =>
      _ComboBoxManagementScreenState();
}

class _ComboBoxManagementScreenState extends State<ComboBoxManagementScreen> {
  final ComboBoxService _service = ComboBoxService();
  List<ComboBox> _comboBoxes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final boxes = await _service.getComboBoxes();
      setState(() {
        _comboBoxes = boxes;
        _isLoading = false;
      });
    } catch (e) {
      LogService.error('Failed to load combo boxes: $e');
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load combo boxes: $e')),
        );
      }
    }
  }

  Future<void> _deleteComboBox(ComboBox box) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Delete ComboBox',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete ${box.name}?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.amber)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true && box.documentId != null) {
      try {
        await _service.deleteComboBox(box.documentId!);
        _loadData();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to delete: $e')));
        }
      }
    }
  }

  Future<void> _openEditScreen([ComboBox? box]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComboBoxEditScreen(comboBox: box),
      ),
    );
    if (result == true) {
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    LogService.screenLoad('ComboBoxManagementScreen');
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('ComboBox Management'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
          onPressed: () {
            LogService.screenPopped('ComboBoxManagementScreen');
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            tooltip: 'Add New ComboBox',
            icon: const Icon(LucideIcons.plusCircle, color: Colors.amber),
            onPressed: () => _openEditScreen(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.amber),
              )
            : _comboBoxes.isEmpty
            ? const Center(
                child: Text(
                  'No combo boxes found',
                  style: TextStyle(color: Colors.white54),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                itemCount: _comboBoxes.length,
                itemBuilder: (context, index) {
                  final box = _comboBoxes[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _GlassBox(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  box.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Type: ${box.type}',
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 13,
                                  ),
                                ),
                                if (box.valueStr != null &&
                                    box.valueStr!.isNotEmpty)
                                  Text(
                                    'Value (Str): ${box.valueStr}',
                                    style: const TextStyle(
                                      color: Colors.white38,
                                      fontSize: 12,
                                    ),
                                  ),
                                if (box.valueInt != null)
                                  Text(
                                    'Value (Int): ${box.valueInt}',
                                    style: const TextStyle(
                                      color: Colors.white38,
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              LucideIcons.pencil,
                              color: Colors.amber,
                              size: 20,
                            ),
                            onPressed: () => _openEditScreen(box),
                            tooltip: 'Edit Details',
                          ),
                          IconButton(
                            icon: const Icon(
                              LucideIcons.trash2,
                              color: Colors.redAccent,
                              size: 20,
                            ),
                            onPressed: () => _deleteComboBox(box),
                          ),
                        ],
                      ),
                    ),
                  );
                },
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
      padding: const EdgeInsets.all(16),
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
