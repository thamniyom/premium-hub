import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:premium_hub/main.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/glass_card.dart';
import '../../services/models/service_provider.dart';
import '../../services/screens/service_detail_screen.dart';
import '../../services/screens/service_list_screen.dart';

class HomeScreen03 extends StatelessWidget {
  const HomeScreen03({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 100), // Space for bottom nav
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.workspace_premium,
                    size: 40,
                    color: Color(0xFFFFD700),
                  ),
                  Text(
                    'PREMIUMHUB \n SERVICE ON DEMAND',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Provider.of<AppState>(
                      context,
                      listen: false,
                    ).setNavigationIndex(4),
                    child: const CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(
                        'https://randomuser.me/api/portraits/women/44.jpg',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Welcome Text
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Text(
                'Welcome to Premium Hub',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),

            // Search Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: GestureDetector(
                onTap: () => Provider.of<AppState>(
                  context,
                  listen: false,
                ).setNavigationIndex(1),
                child: GlassCard(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: const [
                      Icon(LucideIcons.search, color: Colors.amber),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Search for services...',
                          style: TextStyle(color: Colors.white54),
                        ),
                      ),
                      Icon(LucideIcons.sliders, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Service Finder icon menu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _ServiceIcon(
                    icon: LucideIcons.calendarDays,
                    label: 'Booking',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const ServiceListScreen(category: 'Booking'),
                      ),
                    ),
                  ),
                  _ServiceIcon(
                    icon: LucideIcons.creditCard,
                    label: 'Payment',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const ServiceListScreen(category: 'Payment'),
                      ),
                    ),
                  ),
                  _ServiceIcon(icon: LucideIcons.star, label: 'Reviews'),
                  _ServiceIcon(
                    icon: LucideIcons.arrowUpCircle,
                    label: 'Top up',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Online Now
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Online Now',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(
                    LucideIcons.chevronRight,
                    color: Colors.white54,
                    size: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 90,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                scrollDirection: Axis.horizontal,
                itemCount: 8,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServiceDetailScreen(
                              provider: ServiceProvider(
                                id: 'online-$index',
                                name: 'User ${index + 1}',
                                category: 'Provider',
                                imageUrl:
                                    'https://randomuser.me/api/portraits/men/${index + 20}.jpg',
                                rating: 4.8,
                                reviewCount: 42,
                                description:
                                    'Experienced professional provider ready to help you.',
                                pricePerHour: 50.0,
                                isOnline: true,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                  'https://randomuser.me/api/portraits/men/${index + 20}.jpg',
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'User ${index + 1}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // Featured Providers
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Featured Providers',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(
                    LucideIcons.chevronRight,
                    color: Colors.white54,
                    size: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 160,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                scrollDirection: Axis.horizontal,
                itemCount: 5,
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
                              category: 'Expert',
                              imageUrl: imageUrl,
                              rating: 4.9,
                              reviewCount: 156,
                              description:
                                  'Top-rated featured provider with excellent service history.',
                              pricePerHour: 95.0,
                              isOnline: true,
                            ),
                          ),
                        ),
                      );
                    },
                    child: GlassCard(
                      width: 100,
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(imageUrl),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Provider ${index + 1}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: const [
                              Icon(Icons.star, color: Colors.amber, size: 14),
                              SizedBox(width: 4),
                              Text(
                                '4.9',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // Popular Lounges
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular Lounges',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(
                    LucideIcons.chevronRight,
                    color: Colors.white54,
                    size: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 160,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return GlassCard(
                    width: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    padding: const EdgeInsets.all(1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?q=80&w=2600&auto=format&fit=crop&sig=${index + 10}',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Lounge ${index + 1}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: const [
                            Icon(Icons.star, color: Colors.amber, size: 14),
                            SizedBox(width: 4),
                            Text(
                              '4.8',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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

class _ServiceIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ServiceIcon({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          GlassCard(
            width: 56,
            height: 56,
            padding: const EdgeInsets.all(16),
            borderRadius: 16,
            child: Icon(icon, color: const Color(0xFFFFD700)),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
