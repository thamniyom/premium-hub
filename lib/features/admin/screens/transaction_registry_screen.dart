import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:premium_hub/core/services/log_service.dart';
import '../models/app_transaction.dart';

class TransactionRegistryScreen extends StatefulWidget {
  const TransactionRegistryScreen({super.key});

  @override
  State<TransactionRegistryScreen> createState() =>
      _TransactionRegistryScreenState();
}

class _TransactionRegistryScreenState extends State<TransactionRegistryScreen> {
  late List<AppTransaction> _fullData;
  late List<AppTransaction> _displayData;
  final TextEditingController _searchController = TextEditingController();
  bool _sortAscending = false; // newest first by default
  int _sortColumnIndex = 5;

  TransactionType? _typeFilter;
  TransactionStatus? _statusFilter;

  @override
  void initState() {
    super.initState();
    _fullData = List.from(demoTransactions);
    // Default sort: newest first
    _fullData.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _displayData = List.from(_fullData);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _displayData = _fullData.where((t) {
        final matchesQuery =
            t.id.toLowerCase().contains(query) ||
            t.userName.toLowerCase().contains(query) ||
            t.description.toLowerCase().contains(query);
        final matchesType = _typeFilter == null || t.type == _typeFilter;
        final matchesStatus =
            _statusFilter == null || t.status == _statusFilter;
        return matchesQuery && matchesType && matchesStatus;
      }).toList();
    });
  }

  void _onSearchChanged(String _) => _applyFilters();

  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      switch (columnIndex) {
        case 0:
          _displayData.sort(
            (a, b) => ascending ? a.id.compareTo(b.id) : b.id.compareTo(a.id),
          );
          break;
        case 1:
          _displayData.sort(
            (a, b) => ascending
                ? a.userName.compareTo(b.userName)
                : b.userName.compareTo(a.userName),
          );
          break;
        case 3:
          _displayData.sort(
            (a, b) => ascending
                ? a.amount.compareTo(b.amount)
                : b.amount.compareTo(a.amount),
          );
          break;
        case 5:
          _displayData.sort(
            (a, b) => ascending
                ? a.createdAt.compareTo(b.createdAt)
                : b.createdAt.compareTo(a.createdAt),
          );
          break;
      }
    });
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Type filter
                  const Text(
                    'Type',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [null, ...TransactionType.values].map((t) {
                      final label = t == null
                          ? 'All'
                          : t.name[0].toUpperCase() + t.name.substring(1);
                      final isSelected = _typeFilter == t;
                      return ChoiceChip(
                        label: Text(label),
                        selected: isSelected,
                        onSelected: (_) {
                          setSheetState(() => _typeFilter = t);
                          setState(() => _typeFilter = t);
                          _applyFilters();
                        },
                        selectedColor: Colors.amber.withValues(alpha: 0.2),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.amber : Colors.white54,
                          fontSize: 12,
                        ),
                        backgroundColor: Colors.white10,
                        side: BorderSide(
                          color: isSelected
                              ? Colors.amber.withValues(alpha: 0.5)
                              : Colors.white10,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Status filter
                  const Text(
                    'Status',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [null, ...TransactionStatus.values].map((s) {
                      final label = s == null
                          ? 'All'
                          : s.name[0].toUpperCase() + s.name.substring(1);
                      final isSelected = _statusFilter == s;
                      return ChoiceChip(
                        label: Text(label),
                        selected: isSelected,
                        onSelected: (_) {
                          setSheetState(() => _statusFilter = s);
                          setState(() => _statusFilter = s);
                          _applyFilters();
                        },
                        selectedColor: Colors.amber.withValues(alpha: 0.2),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.amber : Colors.white54,
                          fontSize: 12,
                        ),
                        backgroundColor: Colors.white10,
                        side: BorderSide(
                          color: isSelected
                              ? Colors.amber.withValues(alpha: 0.5)
                              : Colors.white10,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Clear all
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        setSheetState(() {
                          _typeFilter = null;
                          _statusFilter = null;
                        });
                        setState(() {
                          _typeFilter = null;
                          _statusFilter = null;
                        });
                        _applyFilters();
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Clear All Filters',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ── Colour helpers ───────────────────────────────────────────────────────

  Color _typeColor(TransactionType t) {
    switch (t) {
      case TransactionType.booking:
        return Colors.blueAccent;
      case TransactionType.refund:
        return Colors.orange;
      case TransactionType.topUp:
        return Colors.green;
      case TransactionType.withdrawal:
        return Colors.purpleAccent;
      case TransactionType.fee:
        return Colors.white54;
    }
  }

  IconData _typeIcon(TransactionType t) {
    switch (t) {
      case TransactionType.booking:
        return LucideIcons.calendarCheck;
      case TransactionType.refund:
        return LucideIcons.undo2;
      case TransactionType.topUp:
        return LucideIcons.arrowDownCircle;
      case TransactionType.withdrawal:
        return LucideIcons.arrowUpCircle;
      case TransactionType.fee:
        return LucideIcons.percent;
    }
  }

  Color _statusColor(TransactionStatus s) {
    switch (s) {
      case TransactionStatus.completed:
        return Colors.green;
      case TransactionStatus.pending:
        return Colors.orange;
      case TransactionStatus.failed:
        return Colors.red;
      case TransactionStatus.refunded:
        return Colors.blueAccent;
    }
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // ── Totals ────────────────────────────────────────────────────────────────

  double get _totalRevenue => _displayData
      .where(
        (t) =>
            t.status == TransactionStatus.completed &&
            (t.type == TransactionType.booking ||
                t.type == TransactionType.topUp ||
                t.type == TransactionType.fee),
      )
      .fold(0, (sum, t) => sum + t.amount);

  double get _totalRefunds => _displayData
      .where((t) => t.type == TransactionType.refund)
      .fold(0, (sum, t) => sum + t.amount);

  @override
  Widget build(BuildContext context) {
    LogService.screenLoad('TransactionRegistryScreen');
    final dateFormat = DateFormat('MMM dd, HH:mm');
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );
    final hasFilters = _typeFilter != null || _statusFilter != null;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Transaction Registry'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                tooltip: 'Filter',
                icon: const Icon(LucideIcons.filter, color: Colors.white70),
                onPressed: _showFilterSheet,
              ),
              if (hasFilters)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Summary Chips ────────────────────────────────────────────
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _SummaryChip(
                      label: 'Transactions',
                      value: _displayData.length.toString(),
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 10),
                    _SummaryChip(
                      label: 'Revenue',
                      value: currencyFormat.format(_totalRevenue),
                      color: Colors.green,
                    ),
                    const SizedBox(width: 10),
                    _SummaryChip(
                      label: 'Refunds',
                      value: currencyFormat.format(_totalRefunds),
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 10),
                    _SummaryChip(
                      label: 'Failed',
                      value: _displayData
                          .where((t) => t.status == TransactionStatus.failed)
                          .length
                          .toString(),
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Search ───────────────────────────────────────────────────
              _GlassBox(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
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
                            hintText: 'Search ID, user or description...',
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

              // ── Table ────────────────────────────────────────────────────
              _displayData.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 48),
                        child: Column(
                          children: [
                            Icon(
                              LucideIcons.fileX,
                              size: 48,
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No transactions found',
                              style: TextStyle(color: Colors.white24),
                            ),
                          ],
                        ),
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
                            fontSize: 12,
                          ),
                          dataTextStyle: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                          dividerThickness: 0.3,
                          columns: [
                            DataColumn(
                              label: const Text('TXN ID'),
                              onSort: _onSort,
                            ),
                            DataColumn(
                              label: const Text('USER'),
                              onSort: _onSort,
                            ),
                            const DataColumn(label: Text('DESCRIPTION')),
                            DataColumn(
                              label: const Text('AMOUNT'),
                              numeric: true,
                              onSort: _onSort,
                            ),
                            const DataColumn(label: Text('TYPE')),
                            const DataColumn(label: Text('STATUS')),
                            DataColumn(
                              label: const Text('DATE'),
                              onSort: _onSort,
                            ),
                          ],
                          rows: _displayData.map((txn) {
                            final typeColor = _typeColor(txn.type);
                            final isCredit =
                                txn.type == TransactionType.topUp ||
                                txn.type == TransactionType.booking;
                            return DataRow(
                              cells: [
                                // ID
                                DataCell(
                                  Text(
                                    txn.id,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ),
                                // User
                                DataCell(
                                  Text(
                                    txn.userName,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                // Description
                                DataCell(
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      txn.description,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                                // Amount
                                DataCell(
                                  Text(
                                    '${isCredit ? '+' : '-'}${currencyFormat.format(txn.amount)}',
                                    style: TextStyle(
                                      color: isCredit
                                          ? Colors.green
                                          : Colors.redAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                // Type
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _typeIcon(txn.type),
                                        size: 13,
                                        color: typeColor,
                                      ),
                                      const SizedBox(width: 6),
                                      _badge(txn.type.name, typeColor),
                                    ],
                                  ),
                                ),
                                // Status
                                DataCell(
                                  _badge(
                                    txn.status.name,
                                    _statusColor(txn.status),
                                  ),
                                ),
                                // Date
                                DataCell(
                                  Text(
                                    dateFormat.format(txn.createdAt),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
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

// ── Widgets ──────────────────────────────────────────────────────────────────

class _SummaryChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            label,
            style: TextStyle(color: color.withValues(alpha: 0.6), fontSize: 11),
          ),
        ],
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
