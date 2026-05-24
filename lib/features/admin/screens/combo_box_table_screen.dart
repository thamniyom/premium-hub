import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/services/log_service.dart';
import '../models/combo_box.dart';
import '../services/combo_box_service.dart';
import 'combo_box_edit_screen.dart';

class ComboBoxTableScreen extends StatefulWidget {
  const ComboBoxTableScreen({super.key});

  @override
  State<ComboBoxTableScreen> createState() => _ComboBoxTableScreenState();
}

class _ComboBoxTableScreenState extends State<ComboBoxTableScreen> {
  final ComboBoxService _service = ComboBoxService();
  List<ComboBox> _fullData = [];
  List<ComboBox> _displayData = [];
  final TextEditingController _searchController = TextEditingController();
  bool _sortAscending = true;
  int _sortColumnIndex = 0;
  bool _isLoading = true;
  int _currentPage = 1;
  int _pageSize = 5;
  bool _hasNextPage = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final boxes = await _service.getComboBoxes(
        page: _currentPage,
        pageSize: _pageSize,
      );
      setState(() {
        _fullData = boxes;
        _displayData = List.from(_fullData);
        _hasNextPage = boxes.length == _pageSize;
        _isLoading = false;
        _onSearchChanged(_searchController.text);
      });
    } catch (e) {
      LogService.error('Failed to load combo boxes for table: $e');
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

  void _onSearchChanged(String query) {
    setState(() {
      _displayData = _fullData.where((box) {
        final nameMatch = box.name.toLowerCase().contains(query.toLowerCase());
        final typeMatch = box.type.toLowerCase().contains(query.toLowerCase());
        return nameMatch || typeMatch;
      }).toList();
      _onSort(_sortColumnIndex, _sortAscending, skipSetState: true);
    });
  }

  void _onSort(int columnIndex, bool ascending, {bool skipSetState = false}) {
    final sortLogic = () {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      if (columnIndex == 0) {
        // TYPE
        _displayData.sort(
          (a, b) =>
              ascending ? a.type.compareTo(b.type) : b.type.compareTo(a.type),
        );
      } else if (columnIndex == 1) {
        // NAME
        _displayData.sort(
          (a, b) =>
              ascending ? a.name.compareTo(b.name) : b.name.compareTo(a.name),
        );
      } else if (columnIndex == 2) {
        // VALUE (STR)
        _displayData.sort(
          (a, b) => ascending
              ? (a.valueStr ?? '').compareTo(b.valueStr ?? '')
              : (b.valueStr ?? '').compareTo(a.valueStr ?? ''),
        );
      } else if (columnIndex == 3) {
        // VALUE (INT)
        _displayData.sort(
          (a, b) => ascending
              ? (a.valueInt ?? -1).compareTo(b.valueInt ?? -1)
              : (b.valueInt ?? -1).compareTo(a.valueInt ?? -1),
        );
      }
    };

    if (skipSetState) {
      sortLogic();
    } else {
      setState(sortLogic);
    }
  }

  Future<void> _editComboBox(ComboBox box) async {
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

  Future<void> _addNewComboBox() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ComboBoxEditScreen()),
    );

    if (result == true) {
      _loadData();
    }
  }

  Future<void> _deleteComboBox(ComboBox box) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Delete ComboBox',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete "${box.name}"? This action cannot be undone.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'CANCEL',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'DELETE',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && box.documentId != null) {
      try {
        await _service.deleteComboBox(box.documentId!);
        _loadData();
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('${box.name} deleted')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to delete: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    LogService.screenLoad('ComboBoxTableScreen');
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('ComboBox Management List Table'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plusCircle, color: Colors.amber),
            tooltip: 'Add New ComboBox',
            onPressed: _addNewComboBox,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.amber),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _GlassBox(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Icon(
                              LucideIcons.search,
                              color: Colors.amber,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                onChanged: _onSearchChanged,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: 'Search type or name...',
                                  hintStyle: TextStyle(color: Colors.white24),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: _GlassBox(
                        child: DataTable(
                          sortAscending: _sortAscending,
                          sortColumnIndex: _sortColumnIndex,
                          headingTextStyle: const TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                          ),
                          dataTextStyle: const TextStyle(color: Colors.white70),
                          columns: [
                            DataColumn(
                              label: const Text('TYPE'),
                              onSort: _onSort,
                            ),
                            DataColumn(
                              label: const Text('NAME'),
                              onSort: _onSort,
                            ),
                            DataColumn(
                              label: const Text('VALUE (STR)'),
                              onSort: _onSort,
                            ),
                            DataColumn(
                              label: const Text('VALUE (INT)'),
                              numeric: true,
                              onSort: _onSort,
                            ),
                            const DataColumn(label: Text('ACTIONS')),
                          ],
                          rows: _displayData.map((box) {
                            return DataRow(
                              cells: [
                                DataCell(Text(box.type)),
                                DataCell(
                                  Text(
                                    box.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataCell(Text(box.valueStr ?? '-')),
                                DataCell(Text(box.valueInt?.toString() ?? '-')),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          LucideIcons.pencil,
                                          size: 16,
                                          color: Colors.blueAccent,
                                        ),
                                        onPressed: () => _editComboBox(box),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          LucideIcons.trash2,
                                          size: 16,
                                          color: Colors.redAccent,
                                        ),
                                        onPressed: () => _deleteComboBox(box),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _currentPage > 1
                              ? () {
                                  setState(() {
                                    _currentPage--;
                                  });
                                  _loadData();
                                }
                              : null,
                          icon: const Icon(LucideIcons.chevronLeft, size: 16),
                          label: const Text('Previous'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber.withValues(
                              alpha: 0.1,
                            ),
                            foregroundColor: Colors.amber,
                            disabledForegroundColor: Colors.white24,
                            disabledBackgroundColor: Colors.white10,
                          ),
                        ),
                        Text(
                          'Page $_currentPage',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _hasNextPage
                              ? () {
                                  setState(() {
                                    _currentPage++;
                                  });
                                  _loadData();
                                }
                              : null,
                          icon: const Icon(LucideIcons.chevronRight, size: 16),
                          label: const Text('Next'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber.withValues(
                              alpha: 0.1,
                            ),
                            foregroundColor: Colors.amber,
                            disabledForegroundColor: Colors.white24,
                            disabledBackgroundColor: Colors.white10,
                          ),
                        ),
                      ],
                    ),
                  ],
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
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: child,
    );
  }
}
