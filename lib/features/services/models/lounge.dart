import 'package:premium_hub/features/admin/models/combo_box.dart';

class Lounge {
  final String id;
  final String? documentId;
  final String name;
  final ComboBox category;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String description;
  final double pricePerHour;
  final bool isOpen;
  final List<ComboBox> amenities;

  const Lounge({
    this.id = '',
    this.documentId,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.pricePerHour,
    this.isOpen = false,
    this.amenities = const [],
  });

  factory Lounge.fromJson(Map<String, dynamic> json) {
    return Lounge(
      id: json['id']?.toString() ?? '',
      documentId: json['documentId'] as String?,
      name: json['name'] as String? ?? '',
      category: json['category'] is Map<String, dynamic>
          ? ComboBox.fromJson(json['category'] as Map<String, dynamic>)
          : const ComboBox(type: 'unknown', name: 'Unknown'),
      imageUrl: json['imageUrl'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      description: json['description'] as String? ?? '',
      pricePerHour: (json['pricePerHour'] as num?)?.toDouble() ?? 0.0,
      isOpen: json['isOpen'] as bool? ?? false,
      amenities:
          (json['amenities'] as List<dynamic>?)
              ?.map(
                (e) => e is Map<String, dynamic>
                    ? ComboBox.fromJson(e)
                    : ComboBox(type: 'amenity', name: e.toString()),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category.documentId ?? '',
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'description': description,
      'pricePerHour': pricePerHour,
      'isOpen': isOpen,
      'amenities': amenities
          .map((e) => e.documentId ?? '')
          .where((id) => id.isNotEmpty)
          .toList(),
    };
  }

  Map<String, dynamic> toJsonId() {
    return {
      'documentId': documentId,
      'name': name,
      'category': category.documentId ?? '',
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'description': description,
      'pricePerHour': pricePerHour,
      'isOpen': isOpen,
      'amenities': amenities
          .map((e) => e.documentId ?? '')
          .where((id) => id.isNotEmpty)
          .toList(),
    };
  }
}

// Demo data for Lounge management
final List<Lounge> demoLounges = [
  const Lounge(
    id: 'l1',
    name: 'The Gold Suite',
    category: const ComboBox(type: 'category', name: 'VIP Lounge'),
    imageUrl:
        'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?q=80&w=2600&auto=format&fit=crop',
    rating: 4.9,
    reviewCount: 156,
    description:
        'Exclusive gold-themed lounge with premium bar and private suites.',
    pricePerHour: 150.0,
    isOpen: true,
    amenities: [
      const ComboBox(type: 'amenity', name: 'Premium Bar'),
      const ComboBox(type: 'amenity', name: 'Private Suites'),
      const ComboBox(type: 'amenity', name: 'Concierge'),
    ],
  ),
  const Lounge(
    id: 'l2',
    name: 'Skyline Terrace',
    category: const ComboBox(type: 'category', name: 'Rooftop Lounge'),
    imageUrl:
        'https://images.unsplash.com/photo-1560624052-449f5ddf0c31?q=80&w=2600&auto=format&fit=crop',
    rating: 4.8,
    reviewCount: 92,
    description:
        'Breathtaking city views with high-end cocktails and live jazz.',
    pricePerHour: 85.0,
    isOpen: true,
    amenities: [
      const ComboBox(type: 'amenity', name: 'Rooftop View'),
      const ComboBox(type: 'amenity', name: 'Cocktails'),
      const ComboBox(type: 'amenity', name: 'Live Jazz'),
    ],
  ),
  const Lounge(
    id: 'l3',
    name: 'Zenith Garden',
    category: const ComboBox(type: 'category', name: 'Nature Lounge'),
    imageUrl:
        'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?q=80&w=2600&auto=format&fit=crop',
    rating: 4.7,
    reviewCount: 64,
    description:
        'A peaceful oasis in the heart of the city with botanical cocktails.',
    pricePerHour: 65.0,
    isOpen: false,
    amenities: [
      const ComboBox(type: 'amenity', name: 'Garden Setting'),
      const ComboBox(type: 'amenity', name: 'Organic Drinks'),
      const ComboBox(type: 'amenity', name: 'Relaxation Area'),
    ],
  ),
  const Lounge(
    id: 'l4',
    name: 'Onyx Club',
    category: const ComboBox(type: 'category', name: 'Underground Lounge'),
    imageUrl:
        'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?q=80&w=2600&auto=format&fit=crop',
    rating: 4.6,
    reviewCount: 210,
    description: 'Moody, sophisticated atmosphere with world-class DJs.',
    pricePerHour: 120.0,
    isOpen: true,
    amenities: [
      const ComboBox(type: 'amenity', name: 'World-class DJs'),
      const ComboBox(type: 'amenity', name: 'Dance Floor'),
      const ComboBox(type: 'amenity', name: 'Champagne Bar'),
    ],
  ),
];
