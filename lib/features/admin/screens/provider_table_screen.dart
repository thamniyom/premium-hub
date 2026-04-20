import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../services/models/service_provider.dart';
import 'provider_edit_screen.dart';
import 'provider_add_screen.dart';
import '../../../core/services/log_service.dart';

class ProviderTableScreen extends StatefulWidget {
  const ProviderTableScreen({super.key});

  @override
  State<ProviderTableScreen> createState() => _ProviderTableScreenState();
}

class _ProviderTableScreenState extends State<ProviderTableScreen> {
  late List<ServiceProvider> _fullData;
  late List<ServiceProvider> _displayData;
  final TextEditingController _searchController = TextEditingController();
  bool _sortAscending = true;
  int _sortColumnIndex = 0;

  @override
  void initState() {
    super.initState();
    _fullData = List.from(demoProviders);
    _displayData = List.from(_fullData);
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
        final categoryMatch =
            p.category.toLowerCase().contains(query.toLowerCase());
        return nameMatch || categoryMatch;
      }).toList();
    });
  }

  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      if (columnIndex == 0) {
        _displayData.sort((a, b) => ascending
            ? a.name.compareTo(b.name)
            : b.name.compareTo(a.name));
      } else if (columnIndex == 2) {
        _displayData.sort((a, b) => ascending
            ? a.rating.compareTo(b.rating)
            : b.rating.compareTo(a.rating));
      } else if (columnIndex == 3) {
        _displayData.sort((a, b) => ascending
            ? a.pricePerHour.compareTo(b.pricePerHour)
            : b.pricePerHour.compareTo(a.pricePerHour));
      }
    });
  }

  Future<void> _editProvider(ServiceProvider provider) async {
    final updatedProvider = await Navigator.push<ServiceProvider>(
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
    final newProvider = await Navigator.push<ServiceProvider>(
      context,
      MaterialPageRoute(
        builder: (context) => const ProviderAddScreen(),
      ),
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

  Future<void> _deleteProvider(ServiceProvider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Entry', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to delete "${provider.name}"? This action cannot be undone.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('DELETE', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _fullData.removeWhere((p) => p.id == provider.id);
        _onSearchChanged(_searchController.text);
        LogService.info('Provider deleted from BackOffice: ${provider.id}');
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${provider.name} deleted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      const Icon(LucideIcons.search,
                          color: Colors.amber, size: 20),
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
                        icon: const Icon(LucideIcons.filter,
                            color: Colors.white54, size: 20),
                        onPressed: () {},
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
                          DataCell(Text(p.name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold))),
                          DataCell(Text(p.category)),
                          DataCell(Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 14),
                              const SizedBox(width: 4),
                              Text(p.rating.toString()),
                            ],
                          )),
                          DataCell(Text('\$${p.pricePerHour.toStringAsFixed(0)}')),
                          DataCell(Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: p.isOnline
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : Colors.white10,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              p.isOnline ? 'ONLINE' : 'OFFLINE',
                              style: TextStyle(
                                color: p.isOnline ? Colors.green : Colors.white24,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: const Icon(LucideIcons.pencil,
                                    size: 16, color: Colors.blueAccent),
                                onPressed: () => _editProvider(p),
                              ),
                              IconButton(
                                icon: const Icon(LucideIcons.trash2,
                                    size: 16, color: Colors.redAccent),
                                onPressed: () => _deleteProvider(p),
                              ),
                            ],
                          )),
                        ],
                      );
                    }).toList(),
                  ),
                ),
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
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: child,
    );
  }
}
