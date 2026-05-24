enum BookingStatus { pending, confirmed, completed, cancelled, upcoming }

class Booking {
  final String id;
  final String documentId;
  final String providerName;
  final String serviceType;
  final DateTime dateTime; // maps to startTime
  final DateTime? endTime;
  final double price; // maps to totalAmount
  final String imageUrl;
  final BookingStatus statusBooking;

  const Booking({
    required this.id,
    this.documentId = '',
    required this.providerName,
    required this.serviceType,
    required this.dateTime,
    this.endTime,
    required this.price,
    required this.imageUrl,
    required this.statusBooking,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    String pName = 'Unknown Provider';
    String sType = 'General Service';
    String img = 'https://randomuser.me/api/portraits/lego/1.jpg';

    // Parse providers list if available
    if (json['providers'] != null &&
        json['providers'] is List &&
        (json['providers'] as List).isNotEmpty) {
      final provider = (json['providers'] as List).first;
      pName = provider['name'] ?? pName;
      img = provider['imageUrl'] ?? img;
      if (provider['category'] != null &&
          provider['category']['name'] != null) {
        sType = provider['category']['name'];
      }
    }
    // Parse lounge list if available
    if (json['lounge'] != null) {
      final lounge = json['lounge'];
      pName = lounge['name'] ?? pName;
      img = lounge['imageUrl'] ?? img;
    }
    return Booking(
      id: json['id']?.toString() ?? '',
      documentId: json['documentId'] ?? '',
      providerName: pName,
      serviceType: sType,
      dateTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'])
          : DateTime.now(),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      price: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      imageUrl: img,
      statusBooking: _parseStatus(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'documentId': documentId,
      'startTime': dateTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'totalAmount': price,
      'statusBooking': statusBooking.name,
    };
  }

  static BookingStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
        return BookingStatus.cancelled;
      case 'pending':
      default:
        return BookingStatus.pending;
    }
  }

  Booking copyWith({
    String? id,
    String? documentId,
    String? providerName,
    String? serviceType,
    DateTime? dateTime,
    DateTime? endTime,
    double? price,
    String? imageUrl,
    BookingStatus? statusBooking,
  }) {
    return Booking(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      providerName: providerName ?? this.providerName,
      serviceType: serviceType ?? this.serviceType,
      dateTime: dateTime ?? this.dateTime,
      endTime: endTime ?? this.endTime,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      statusBooking: statusBooking ?? this.statusBooking,
    );
  }
}

// Keep demo data temporarily so that other screens that haven't been updated don't break instantly,
// but we will transition away from this.
final List<Booking> demoBookings = [
  Booking(
    id: '1',
    providerName: 'Sarah Johnson',
    serviceType: 'Aromatherapy Massage',
    dateTime: DateTime.now().add(const Duration(days: 2, hours: 3)),
    price: 85.0,
    imageUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
    statusBooking: BookingStatus.confirmed,
  ),
  Booking(
    id: '2',
    providerName: 'Michael Chen',
    serviceType: 'Private Chef Dining',
    dateTime: DateTime.now().subtract(const Duration(days: 5)),
    price: 120.0,
    imageUrl: 'https://randomuser.me/api/portraits/men/20.jpg',
    statusBooking: BookingStatus.completed,
  ),
  Booking(
    id: '3',
    providerName: 'Elena Rodriguez',
    serviceType: 'Personal Shopping',
    dateTime: DateTime.now().subtract(const Duration(days: 10)),
    price: 65.0,
    imageUrl: 'https://randomuser.me/api/portraits/women/65.jpg',
    statusBooking: BookingStatus.cancelled,
  ),
];
