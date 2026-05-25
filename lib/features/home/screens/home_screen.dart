import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:premium_hub/features/bookings/screens/booking_form_lounge_provider.dart';
import 'package:premium_hub/features/services/screens/lounge_detail_screen.dart';
import 'package:premium_hub/main.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/services/log_service.dart';
import '../../services/screens/provider_detail_screen.dart';
import '../../top_up/screens/top_up_screen.dart';
import '../../payments/screens/payment_history_screen.dart';
import '../../reviews/screens/review_history_screen.dart';
import '../../admin/screens/admin_dashboard_screen.dart';
import '../../admin/screens/back_office_screen.dart';
import '../../admin/services/lounge_service.dart';
import '../../admin/services/provider_service.dart';
import '../../services/models/lounge.dart';
import '../../services/models/provider.dart' as app_provider;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Lounge>> _loungesFuture;
  late Future<List<app_provider.Provider>> _providersFuture;

  @override
  void initState() {
    super.initState();
    LogService.screenOpened('HomeScreen');
    _loungesFuture = LoungeService().getLounges();
    _providersFuture = ProviderService().getProviders();
  }

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
                  Row(
                    children: [
                      const Icon(
                        Icons.workspace_premium,
                        size: 40,
                        color: Color(0xFFFFD700),
                      ),
                      Text(
                        'PREMIUMHUB\nSERVICE ON DEMAND',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      LogService.info('Profile image tapped from Home');
                      Provider.of<AppState>(
                        context,
                        listen: false,
                      ).setNavigationIndex(4);
                    },
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
                onTap: () {
                  LogService.info('Search bar tapped from Home');
                  Provider.of<AppState>(
                    context,
                    listen: false,
                  ).setNavigationIndex(1);
                },
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
            // Welcome Text
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Text(
                'SERVICE FINDER',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
            // Service Finder icon menu
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  _ServiceIcon(
                    icon: LucideIcons.calendarDays,
                    label: 'Booking',
                    onTap: () {
                      LogService.serviceIconTapped('Booking');
                      LogService.screenOpened(
                        'BookingFormLoungeProviderScreen',
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const BookingFormLoungeProviderScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 20),
                  _ServiceIcon(
                    icon: LucideIcons.creditCard,
                    label: 'Payment',
                    onTap: () {
                      LogService.serviceIconTapped('Payment');
                      LogService.screenOpened('PaymentHistoryScreen');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaymentHistoryScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 20),
                  _ServiceIcon(
                    icon: LucideIcons.star,
                    label: 'Reviews',
                    onTap: () {
                      LogService.serviceIconTapped('Reviews');
                      LogService.screenOpened('ReviewHistoryScreen');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReviewHistoryScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 20),
                  _ServiceIcon(
                    icon: LucideIcons.arrowUpCircle,
                    label: 'Top up',
                    onTap: () {
                      LogService.serviceIconTapped('Top up');
                      LogService.screenOpened('TopUpScreen');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TopUpScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 20),
                  _ServiceIcon(
                    icon: LucideIcons.userCog,
                    label: 'Admin',
                    onTap: () {
                      LogService.serviceIconTapped('Admin');
                      LogService.screenOpened('AdminDashboardScreen');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminDashboardScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 20),
                  _ServiceIcon(
                    icon: LucideIcons.shieldCheck,
                    label: 'BackOffice',
                    onTap: () {
                      LogService.serviceIconTapped('BackOffice');
                      LogService.screenOpened('BackOfficeScreen');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BackOfficeScreen(),
                        ),
                      );
                    },
                  ),
                ],
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
                      fontSize: 10,
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
              child: FutureBuilder<List<app_provider.Provider>>(
                future: _providersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.amber),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Failed to load providers',
                        style: TextStyle(color: Colors.white54),
                      ),
                    );
                  }
                  final providers = snapshot.data ?? [];
                  if (providers.isEmpty) {
                    return const Center(
                      child: Text(
                        'No providers available',
                        style: TextStyle(color: Colors.white54),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    scrollDirection: Axis.horizontal,
                    itemCount: providers.length,
                    itemBuilder: (context, index) {
                      final p = providers[index];
                      final imageUrl = p.imageUrl.isNotEmpty
                          ? p.imageUrl
                          : 'https://images.unsplash.com/photo-1560185127-6ed189bf02f4?q=80&w=2600&auto=format&fit=crop&sig=$index';
                      return GestureDetector(
                        onTap: () {
                          final serviceProvider = app_provider.Provider(
                            id: p.id,
                            documentId: p.documentId,
                            name: p.name,
                            category: p.category,
                            imageUrl: imageUrl,
                            rating: p.rating,
                            reviewCount: p.reviewCount,
                            description: p.description,
                            pricePerHour: p.pricePerHour,
                            isOnline: p.isOnline,
                          );
                          LogService.providerTapped(
                            serviceProvider.id,
                            serviceProvider.name,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProviderDetailScreen(
                                provider: serviceProvider,
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
                                p.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyLarge?.copyWith(fontSize: 10),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    p.rating.toStringAsFixed(1),
                                    style: const TextStyle(
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
                      fontSize: 10,
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
              child: FutureBuilder<List<Lounge>>(
                future: _loungesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.amber),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Failed to load lounges',
                        style: TextStyle(color: Colors.white54),
                      ),
                    );
                  }

                  final lounges = snapshot.data ?? [];
                  if (lounges.isEmpty) {
                    return const Center(
                      child: Text(
                        'No lounges available',
                        style: TextStyle(color: Colors.white54),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    scrollDirection: Axis.horizontal,
                    itemCount: lounges.length,
                    itemBuilder: (context, index) {
                      final l = lounges[index];
                      final imageUrl = l.imageUrl.isNotEmpty
                          ? l.imageUrl
                          : 'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?q=80&w=2600&auto=format&fit=crop&sig=${index + 10}';
                      return GestureDetector(
                        onTap: () {
                          final lounge = Lounge(
                            id: l.id,
                            documentId: l.documentId,
                            name: l.name,
                            category: l.category,
                            imageUrl: imageUrl,
                            rating: l.rating,
                            reviewCount: l.reviewCount,
                            description: l.description,
                            pricePerHour: l.pricePerHour,
                          );
                          LogService.loungeTapped(lounge.id, lounge.name);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  LoungeDetailScreen(lounge: lounge),
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
                                l.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyLarge?.copyWith(fontSize: 10),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    l.rating.toStringAsFixed(1),
                                    style: const TextStyle(
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
    LogService.screenLoad('HomeScreen');
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
