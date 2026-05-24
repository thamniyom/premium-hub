import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:premium_hub/features/admin/services/provider_service.dart';
import 'package:premium_hub/features/services/models/provider.dart';
import 'provider_edit_screen.dart';
import 'provider_add_screen.dart';
import '../../../core/services/log_service.dart';

class ProviderTableScreen extends StatefulWidget {
  const ProviderTableScreen({super.key});

  @override
  State<ProviderTableScreen> createState() => _ProviderTableScreenState();
}

class _ProviderTableScreenState extends State<ProviderTableScreen> {
  late List<Provider> _fullData;
  late List<Provider> _displayData;
  final TextEditingController _searchController = TextEditingController();
  bool _sortAscending = true;
  int _sortColumnIndex = 0;

  final ProviderService _service = ProviderService();
  bool _isLoading = true;

  int _currentPage = 1;
  final int _pageSize = 4;
  bool _hasNextPage = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final providers = await _service.getProviders(
        page: _currentPage,
        pageSize: _pageSize,
      );
      setState(() {
        _fullData = providers;
        _displayData = providers;
        _hasNextPage = providers.length == _pageSize;
        _isLoading = false;
        _onSearchChanged(_searchController.text);
      });
    } catch (e) {
      LogService.error('Failed to load providers: $e');
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load providers: $e')));
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _displayData = _fullData.where((p) {
        final nameMatch = p.name.toLowerCase().contains(query.toLowerCase());
        final categoryMatch = p.category.name.toLowerCase().contains(
          query.toLowerCase(),
        );
        return nameMatch || categoryMatch;
      }).toList();
    });
  }

  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      if (columnIndex == 0) {
        _displayData.sort(
          (a, b) =>
              ascending ? a.name.compareTo(b.name) : b.name.compareTo(a.name),
        );
      } else if (columnIndex == 2) {
        _displayData.sort(
          (a, b) => ascending
              ? a.rating.compareTo(b.rating)
              : b.rating.compareTo(a.rating),
        );
      } else if (columnIndex == 3) {
        _displayData.sort(
          (a, b) => ascending
              ? a.pricePerHour.compareTo(b.pricePerHour)
              : b.pricePerHour.compareTo(a.pricePerHour),
        );
      }
    });
  }

  Future<void> _editProvider(Provider provider) async {
    final updatedProvider = await Navigator.push<Provider>(
      context,
      MaterialPageRoute(
        builder: (context) => ProviderEditScreen(provider: provider),
      ),
    );

    if (updatedProvider != null) {
      if (!mounted) return;
      setState(() {
        // Update full data
        final index = _fullData.indexWhere((p) => p.id == updatedProvider.id);
        if (index != -1) {
          _fullData[index] = updatedProvider;
        }
        // Refresh display data
        _onSearchChanged(_searchController.text);
      });
    }
  }

  Future<void> _addNewProvider() async {
    final newProvider = await Navigator.push<Provider>(
      context,
      MaterialPageRoute(builder: (context) => const ProviderAddScreen()),
    );

    if (newProvider != null) {
      if (!mounted) return;
      setState(() {
        _fullData.add(newProvider);
        _onSearchChanged(_searchController.text);
        LogService.info('New provider added via Table: ${newProvider.id}');
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${newProvider.name} added successfully')),
      );
    }
  }

  Future<void> _deleteProvider(Provider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Delete Entry',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete "${provider.name}"? This action cannot be undone.',
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

    if (confirmed == true) {
      try {
        if (provider.documentId != null) {
          await _service.deleteProvider(provider.documentId!);
        }
        setState(() {
          _fullData.removeWhere((p) => p.id == provider.id);
          _onSearchChanged(_searchController.text);
          LogService.info('Provider deleted from BackOffice: ${provider.id}');
        });
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('${provider.name} deleted')));
        }
      } catch (e) {
        LogService.error('Failed to delete provider: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete provider: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    LogService.screenLoad('ProviderTableScreen');
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Provider Registry Table'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plusCircle, color: Colors.amber),
            tooltip: 'Add New Provider',
            onPressed: _addNewProvider,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                            hintText: 'Search menu entries...',
                            hintStyle: TextStyle(color: Colors.white24),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          LucideIcons.filter,
                          color: Colors.white54,
                          size: 20,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.amber),
                      ),
                    )
                  : SingleChildScrollView(
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
                            const DataColumn(label: Text('CATEGORY')),
                            DataColumn(
                              label: const Text('RATING'),
                              numeric: true,
                              onSort: _onSort,
                            ),
                            DataColumn(
                              label: const Text('PRICE/HR'),
                              numeric: true,
                              onSort: _onSort,
                            ),
                            const DataColumn(label: Text('STATUS')),
                            const DataColumn(label: Text('ACTIONS')),
                          ],
                          rows: _displayData.map((p) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    p.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataCell(Text(p.category.name)),
                                DataCell(
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(p.rating.toString()),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '\$${p.pricePerHour.toStringAsFixed(0)}',
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: p.isOnline
                                          ? Colors.green.withValues(alpha: 0.1)
                                          : Colors.white10,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      p.isOnline ? 'ONLINE' : 'OFFLINE',
                                      style: TextStyle(
                                        color: p.isOnline
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
                                        onPressed: () => _editProvider(p),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          LucideIcons.trash2,
                                          size: 16,
                                          color: Colors.redAccent,
                                        ),
                                        onPressed: () => _deleteProvider(p),
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
              if (!_isLoading)
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
                        backgroundColor: Colors.amber.withValues(alpha: 0.1),
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
                        backgroundColor: Colors.amber.withValues(alpha: 0.1),
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
