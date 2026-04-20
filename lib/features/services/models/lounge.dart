class Lounge {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String description;
  final double pricePerEntry;
  final bool isOpen;
  final List<String> amenities;

  const Lounge({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.pricePerEntry,
    this.isOpen = false,
    this.amenities = const [],
  });
}

// Demo data for Lounge management
final List<Lounge> demoLounges = [
  const Lounge(
    id: 'l1',
    name: 'The Gold Suite',
    category: 'VIP Lounge',
    imageUrl:
        'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?q=80&w=2600&auto=format&fit=crop',
    rating: 4.9,
    reviewCount: 156,
    description:
        'Exclusive gold-themed lounge with premium bar and private suites.',
    pricePerEntry: 150.0,
    isOpen: true,
    amenities: ['Premium Bar', 'Private Suites', 'Concierge'],
  ),
  const Lounge(
    id: 'l2',
    name: 'Skyline Terrace',
    category: 'Rooftop Lounge',
    imageUrl:
        'https://images.unsplash.com/photo-1560624052-449f5ddf0c31?q=80&w=2600&auto=format&fit=crop',
    rating: 4.8,
    reviewCount: 92,
    description: 'Breathtaking city views with high-end cocktails and live jazz.',
    pricePerEntry: 85.0,
    isOpen: true,
    amenities: ['Rooftop View', 'Cocktails', 'Live Jazz'],
  ),
  const Lounge(
    id: 'l3',
    name: 'Zenith Garden',
    category: 'Nature Lounge',
    imageUrl:
        'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?q=80&w=2600&auto=format&fit=crop',
    rating: 4.7,
    reviewCount: 64,
    description:
        'A peaceful oasis in the heart of the city with botanical cocktails.',
    pricePerEntry: 65.0,
    isOpen: false,
    amenities: ['Garden Setting', 'Organic Drinks', 'Relaxation Area'],
  ),
  const Lounge(
    id: 'l4',
    name: 'Onyx Club',
    category: 'Underground Lounge',
    imageUrl:
        'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?q=80&w=2600&auto=format&fit=crop',
    rating: 4.6,
    reviewCount: 210,
    description: 'Moody, sophisticated atmosphere with world-class DJs.',
    pricePerEntry: 120.0,
    isOpen: true,
    amenities: ['World-class DJs', 'Dance Floor', 'Champagne Bar'],
  ),
];
