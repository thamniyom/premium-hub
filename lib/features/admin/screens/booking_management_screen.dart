import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../bookings/models/booking.dart';

class BookingManagementScreen extends StatefulWidget {
  const BookingManagementScreen({super.key});

  @override
  State<BookingManagementScreen> createState() => _BookingManagementScreenState();
}

class _BookingManagementScreenState extends State<BookingManagementScreen>
    with SingleTickerProviderStateMixin {
  late List<Booking> _allBookings;
  late List<Booking> _filteredBookings;
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _allBookings = List.from(demoBookings);
    _filteredBookings = List.from(demoBookings);
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) return;
    _applyFilters(_searchController.text);
  }

  void _applyFilters(String query) {
    setState(() {
      _filteredBookings = _allBookings.where((booking) {
        final matchesQuery =
            booking.providerName.toLowerCase().contains(query.toLowerCase()) ||
                booking.serviceType.toLowerCase().contains(query.toLowerCase());

        bool matchesTab = true;
        if (_tabController.index == 1) {
          matchesTab = booking.status == BookingStatus.upcoming;
        } else if (_tabController.index == 2) {
          matchesTab = booking.status == BookingStatus.completed;
        } else if (_tabController.index == 3) {
          matchesTab = booking.status == BookingStatus.cancelled;
        }

        return matchesQuery && matchesTab;
      }).toList();
    });
  }

  void _updateBookingStatus(String id, BookingStatus newStatus) {
    setState(() {
      final index = _allBookings.indexWhere((b) => b.id == id);
      if (index != -1) {
        final b = _allBookings[index];
        _allBookings[index] = Booking(
          id: b.id,
          providerName: b.providerName,
          serviceType: b.serviceType,
          dateTime: b.dateTime,
          price: b.price,
          imageUrl: b.imageUrl,
          status: newStatus,
        );
        _applyFilters(_searchController.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Booking Management'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          labelColor: Colors.amber,
          unselectedLabelColor: Colors.white24,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: _GlassBox(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  onChanged: _applyFilters,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Search provider or service...',
                    hintStyle: TextStyle(color: Colors.white24),
                    icon: Icon(LucideIcons.search, color: Colors.amber, size: 20),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            // Booking List
            Expanded(
              child: _filteredBookings.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(LucideIcons.calendarX,
                              size: 48, color: Colors.white10),
                          const SizedBox(height: 16),
                          const Text(
                            'No bookings found',
                            style: TextStyle(color: Colors.white24),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: _filteredBookings.length,
                      itemBuilder: (context, index) {
                        final booking = _filteredBookings[index];
                        return _BookingItem(
                          booking: booking,
                          onStatusChanged: (status) =>
                              _updateBookingStatus(booking.id, status),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingItem extends StatelessWidget {
  final Booking booking;
  final Function(BookingStatus) onStatusChanged;

  const _BookingItem({
    required this.booking,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('MMM dd, yyyy').format(booking.dateTime);
    final timeStr = DateFormat('hh:mm a').format(booking.dateTime);

    Color statusColor;
    switch (booking.status) {
      case BookingStatus.upcoming:
        statusColor = Colors.orange;
        break;
      case BookingStatus.completed:
        statusColor = Colors.green;
        break;
      case BookingStatus.cancelled:
        statusColor = Colors.red;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: _GlassBox(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(booking.imageUrl),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.providerName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        booking.serviceType,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    booking.status.name.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.white10),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(LucideIcons.calendar,
                        size: 14, color: Colors.white38),
                    const SizedBox(width: 6),
                    Text(
                      '$dateStr • $timeStr',
                      style: const TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                  ],
                ),
                Text(
                  '\$${booking.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            if (booking.status == BookingStatus.upcoming) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _ActionBtn(
                      label: 'Complete',
                      icon: LucideIcons.check,
                      color: Colors.green,
                      onTap: () => onStatusChanged(BookingStatus.completed),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionBtn(
                      label: 'Cancel',
                      icon: LucideIcons.x,
                      color: Colors.red,
                      onTap: () => onStatusChanged(BookingStatus.cancelled),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassBox extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _GlassBox({
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
