import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:premium_hub/features/admin/models/combo_box.dart';
import '../../../core/services/log_service.dart';
import '../../services/models/lounge.dart';
import '../services/lounge_service.dart';
import 'lounge_edit_screen.dart';

class LoungeTableScreen extends StatefulWidget {
  const LoungeTableScreen({super.key});

  @override
  State<LoungeTableScreen> createState() => _LoungeTableScreenState();
}

class _LoungeTableScreenState extends State<LoungeTableScreen> {
  final LoungeService _service = LoungeService();
  List<Lounge> _fullData = [];
  List<Lounge> _displayData = [];
  final TextEditingController _searchController = TextEditingController();
  bool _sortAscending = true;
  int _sortColumnIndex = 0;
  bool _isLoading = true;

  int _currentPage = 1;
  int _pageSize = 10;
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
      final lounges = await _service.getLounges(
        page: _currentPage,
        pageSize: _pageSize,
      );
      setState(() {
        _fullData = lounges;
        _displayData = List.from(_fullData);
        _hasNextPage = lounges.length == _pageSize;
        _isLoading = false;
        _onSearchChanged(_searchController.text);
      });
    } catch (e) {
      LogService.error('Failed to load lounges for table: $e');
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load lounges: $e')));
      }
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _displayData = _fullData.where((lounge) {
        final nameMatch = lounge.name.toLowerCase().contains(
          query.toLowerCase(),
        );
        final catMatch = lounge.category.name.toLowerCase().contains(
          query.toLowerCase(),
        );
        return nameMatch || catMatch;
      }).toList();
      _onSort(_sortColumnIndex, _sortAscending, skipSetState: true);
    });
  }

  void _onSort(int columnIndex, bool ascending, {bool skipSetState = false}) {
    final sortLogic = () {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      if (columnIndex == 0) {
        // NAME
        _displayData.sort(
          (a, b) =>
              ascending ? a.name.compareTo(b.name) : b.name.compareTo(a.name),
        );
      } else if (columnIndex == 1) {
        // CATEGORY
        _displayData.sort(
          (a, b) => ascending
              ? a.category.name.compareTo(b.category.name)
              : b.category.name.compareTo(a.category.name),
        );
      } else if (columnIndex == 2) {
        // PRICE
        _displayData.sort(
          (a, b) => ascending
              ? a.pricePerHour.compareTo(b.pricePerHour)
              : b.pricePerHour.compareTo(a.pricePerHour),
        );
      } else if (columnIndex == 3) {
        // RATING
        _displayData.sort(
          (a, b) => ascending
              ? a.rating.compareTo(b.rating)
              : b.rating.compareTo(a.rating),
        );
      }
    };

    if (skipSetState) {
      sortLogic();
    } else {
      setState(sortLogic);
    }
  }

  Future<void> _editLounge(Lounge lounge) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoungeEditScreen(lounge: lounge)),
    );

    if (result == true || result is Lounge) {
      _loadData();
    }
  }

  Future<void> _addNewLounge() async {
    final newLounge = Lounge(
      name: '',
      category: const ComboBox(type: 'category', name: ''),
      imageUrl: '',
      rating: 0,
      reviewCount: 0,
      description: '',
      pricePerHour: 0,
    );
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoungeEditScreen(lounge: newLounge),
      ),
    );

    if (result == true || result is Lounge) {
      _loadData();
    }
  }

  Future<void> _deleteLounge(Lounge lounge) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Delete Lounge',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete "${lounge.name}"? This action cannot be undone.',
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

    if (confirmed == true && lounge.documentId != null) {
      try {
        await _service.deleteLounge(lounge.documentId!);
        _loadData();
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('${lounge.name} deleted')));
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
    LogService.screenLoad('LoungeTableScreen');
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Lounge Management List Table'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plusCircle, color: Colors.amber),
            tooltip: 'Add New Lounge',
            onPressed: _addNewLounge,
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
                                  hintText: 'Search lounge name or category...',
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
                              label: const Text('NAME'),
                              onSort: _onSort,
                            ),
                            DataColumn(
                              label: const Text('CATEGORY'),
                              onSort: _onSort,
                            ),
                            DataColumn(
                              label: const Text('PRICE (\$)'),
                              numeric: true,
                              onSort: _onSort,
                            ),
                            DataColumn(
                              label: const Text('RATING'),
                              numeric: true,
                              onSort: _onSort,
                            ),
                            const DataColumn(label: Text('STATUS')),
                            const DataColumn(label: Text('ACTIONS')),
                          ],
                          rows: _displayData.map((lounge) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    lounge.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataCell(Text(lounge.category.name)),
                                DataCell(
                                  Text(
                                    '\$${lounge.pricePerHour.toStringAsFixed(2)}',
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(lounge.rating.toString()),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: lounge.isOpen
                                          ? Colors.green.withValues(alpha: 0.1)
                                          : Colors.white10,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      lounge.isOpen ? 'OPEN' : 'CLOSED',
                                      style: TextStyle(
                                        color: lounge.isOpen
                                            ? Colors.green
                                            : Colors.white24,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          LucideIcons.pencil,
                                          size: 16,
                                          color: Colors.blueAccent,
                                        ),
                                        onPressed: () => _editLounge(lounge),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          LucideIcons.trash2,
                                          size: 16,
                                          color: Colors.redAccent,
                                        ),
                                        onPressed: () => _deleteLounge(lounge),
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
