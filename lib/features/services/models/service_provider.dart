class ServiceProvider {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String description;
  final double pricePerHour;
  final bool isOnline;

  const ServiceProvider({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.pricePerHour,
    this.isOnline = false,
  });
}

// Demo data
final List<ServiceProvider> demoProviders = [
  ServiceProvider(
    id: '1',
    name: 'Sarah Johnson',
    category: 'Booking',
    imageUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
    rating: 4.9,
    reviewCount: 124,
    description: 'Expert massage therapist with 10 years of experience in luxury spas. Specializes in aromatherapy and deep tissue massage.',
    pricePerHour: 85.0,
    isOnline: true,
  ),
  ServiceProvider(
    id: '2',
    name: 'Michael Chen',
    category: 'Booking',
    imageUrl: 'https://randomuser.me/api/portraits/men/20.jpg',
    rating: 4.8,
    reviewCount: 89,
    description: 'Professional private chef offering bespoke dining experiences. Mediterranean and Asian fusion specialist.',
    pricePerHour: 120.0,
    isOnline: true,
  ),
  ServiceProvider(
    id: '3',
    name: 'Elena Rodriguez',
    category: 'Booking',
    imageUrl: 'https://randomuser.me/api/portraits/women/65.jpg',
    rating: 4.7,
    reviewCount: 56,
    description: 'Luxury concierge and personal shopper. Helping you find the best boutiques and events in the city.',
    pricePerHour: 65.0,
    isOnline: false,
  ),
  ServiceProvider(
    id: '4',
    name: 'David Wilson',
    category: 'Payment',
    imageUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
    rating: 4.9,
    reviewCount: 210,
    description: 'Financial advisor for premium investments and wealth management.',
    pricePerHour: 150.0,
    isOnline: true,
  ),
];
