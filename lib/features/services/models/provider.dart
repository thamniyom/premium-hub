import 'package:premium_hub/features/admin/models/combo_box.dart';

class Provider {
  final String id;
  final String? documentId;
  final String name;
  final ComboBox category;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String description;
  final double pricePerHour;
  final bool isOnline;

  const Provider({
    required this.id,
    this.documentId,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.pricePerHour,
    this.isOnline = false,
  });

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      id: json['id']?.toString() ?? '',
      documentId: json['documentId'] as String?,
      name: json['name'] as String? ?? '',
      category: json['category'] is Map<String, dynamic>
          ? ComboBox.fromJson(json['category'] as Map<String, dynamic>)
          : const ComboBox(type: 'provider_category', name: 'Unknown'),
      imageUrl: json['imageUrl'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      description: json['description'] as String? ?? '',
      pricePerHour: (json['pricePerHour'] as num?)?.toDouble() ?? 0.0,
      isOnline: json['isOnline'] as bool? ?? false,
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
      'isOnline': isOnline,
    };
  }
}

// Demo data
final List<Provider> demoProviders = [
  const Provider(
    id: '1',
    name: 'Sarah Johnson',
    category: ComboBox(type: 'provider_category', name: 'Booking'),
    imageUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
    rating: 4.9,
    reviewCount: 124,
    description:
        'Expert massage therapist with 10 years of experience in luxury spas. Specializes in aromatherapy and deep tissue massage.',
    pricePerHour: 85.0,
    isOnline: true,
  ),
  const Provider(
    id: '2',
    name: 'Michael Chen',
    category: ComboBox(type: 'provider_category', name: 'Booking'),
    imageUrl: 'https://randomuser.me/api/portraits/men/20.jpg',
    rating: 4.8,
    reviewCount: 89,
    description:
        'Professional private chef offering bespoke dining experiences. Mediterranean and Asian fusion specialist.',
    pricePerHour: 120.0,
    isOnline: true,
  ),
  const Provider(
    id: '3',
    name: 'Elena Rodriguez',
    category: ComboBox(type: 'provider_category', name: 'Booking'),
    imageUrl: 'https://randomuser.me/api/portraits/women/65.jpg',
    rating: 4.7,
    reviewCount: 56,
    description:
        'Luxury concierge and personal shopper. Helping you find the best boutiques and events in the city.',
    pricePerHour: 65.0,
    isOnline: false,
  ),
  const Provider(
    id: '4',
    name: 'David Wilson',
    category: ComboBox(type: 'provider_category', name: 'Payment'),
    imageUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
    rating: 4.9,
    reviewCount: 210,
    description:
        'Financial advisor for premium investments and wealth management.',
    pricePerHour: 150.0,
    isOnline: true,
  ),
];
