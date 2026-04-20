import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:premium_hub/features/services/models/service_provider.dart';
import 'package:premium_hub/features/services/screens/service_detail_screen.dart';

class BookingFeaturedProviderScreen extends StatelessWidget {
  const BookingFeaturedProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Featured Providers'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemCount: 10,
        itemBuilder: (context, index) {
          final imageUrl =
              'https://images.unsplash.com/photo-1560185127-6ed189bf02f4?q=80&w=2600&auto=format&fit=crop&sig=$index';

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServiceDetailScreen(
                    provider: ServiceProvider(
                      id: 'featured-$index',
                      name: 'Provider ${index + 1}',
                      category: 'Featured Service',
                      imageUrl: imageUrl,
                      rating: 4.8 + (index * 0.01),
                      reviewCount: 100 + index * 5,
                      description:
                          'Top-rated featured provider offering excellent premium services.',
                      pricePerHour: 100.0 + (index * 10),
                      isOnline: index % 3 == 0,
                    ),
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
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
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.white12,
                          child: const Icon(LucideIcons.user, color: Colors.white54),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Provider ${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Featured Service',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '${(4.8 + (index * 0.01)).toStringAsFixed(1)} (${100 + index * 5} reviews)',
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(LucideIcons.chevronRight, color: Colors.white54),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
