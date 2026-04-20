enum BookingStatus { upcoming, completed, cancelled }

class Booking {
  final String id;
  final String providerName;
  final String serviceType;
  final DateTime dateTime;
  final double price;
  final String imageUrl;
  final BookingStatus status;

  const Booking({
    required this.id,
    required this.providerName,
    required this.serviceType,
    required this.dateTime,
    required this.price,
    required this.imageUrl,
    required this.status,
  });
}

// Demo data
final List<Booking> demoBookings = [
  Booking(
    id: '1',
    providerName: 'Sarah Johnson',
    serviceType: 'Aromatherapy Massage',
    dateTime: DateTime.now().add(const Duration(days: 2, hours: 3)),
    price: 85.0,
    imageUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
    status: BookingStatus.upcoming,
  ),
  Booking(
    id: '2',
    providerName: 'Michael Chen',
    serviceType: 'Private Chef Dining',
    dateTime: DateTime.now().subtract(const Duration(days: 5)),
    price: 120.0,
    imageUrl: 'https://randomuser.me/api/portraits/men/20.jpg',
    status: BookingStatus.completed,
  ),
  Booking(
    id: '3',
    providerName: 'Elena Rodriguez',
    serviceType: 'Personal Shopping',
    dateTime: DateTime.now().subtract(const Duration(days: 10)),
    price: 65.0,
    imageUrl: 'https://randomuser.me/api/portraits/women/65.jpg',
    status: BookingStatus.cancelled,
  ),
];
