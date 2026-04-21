enum UserRole { customer, provider, admin }

enum UserStatus { active, suspended, pending }

class AppUser {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final UserRole role;
  final UserStatus status;
  final DateTime joinedAt;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.role,
    required this.status,
    required this.joinedAt,
  });

  AppUser copyWith({
    String? name,
    String? email,
    String? avatarUrl,
    UserRole? role,
    UserStatus? status,
  }) {
    return AppUser(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      status: status ?? this.status,
      joinedAt: joinedAt,
    );
  }
}

// ── Demo Data ────────────────────────────────────────────────────────────────

final List<AppUser> demoUsers = [
  AppUser(
    id: 'u1',
    name: 'Alice Morgan',
    email: 'alice.morgan@email.com',
    avatarUrl: 'https://randomuser.me/api/portraits/women/12.jpg',
    role: UserRole.customer,
    status: UserStatus.active,
    joinedAt: DateTime(2024, 1, 15),
  ),
  AppUser(
    id: 'u2',
    name: 'James Park',
    email: 'james.park@email.com',
    avatarUrl: 'https://randomuser.me/api/portraits/men/25.jpg',
    role: UserRole.customer,
    status: UserStatus.active,
    joinedAt: DateTime(2024, 2, 3),
  ),
  AppUser(
    id: 'u3',
    name: 'Sarah Johnson',
    email: 'sarah.j@provider.com',
    avatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
    role: UserRole.provider,
    status: UserStatus.active,
    joinedAt: DateTime(2023, 11, 20),
  ),
  AppUser(
    id: 'u4',
    name: 'Michael Chen',
    email: 'michael.chen@provider.com',
    avatarUrl: 'https://randomuser.me/api/portraits/men/20.jpg',
    role: UserRole.provider,
    status: UserStatus.active,
    joinedAt: DateTime(2023, 9, 10),
  ),
  AppUser(
    id: 'u5',
    name: 'Elena Rodriguez',
    email: 'elena.r@email.com',
    avatarUrl: 'https://randomuser.me/api/portraits/women/65.jpg',
    role: UserRole.customer,
    status: UserStatus.suspended,
    joinedAt: DateTime(2024, 3, 8),
  ),
  AppUser(
    id: 'u6',
    name: 'David Kim',
    email: 'david.kim@email.com',
    avatarUrl: 'https://randomuser.me/api/portraits/men/47.jpg',
    role: UserRole.customer,
    status: UserStatus.pending,
    joinedAt: DateTime(2024, 4, 1),
  ),
  AppUser(
    id: 'u7',
    name: 'Priya Patel',
    email: 'priya.p@provider.com',
    avatarUrl: 'https://randomuser.me/api/portraits/women/33.jpg',
    role: UserRole.provider,
    status: UserStatus.pending,
    joinedAt: DateTime(2024, 4, 10),
  ),
  AppUser(
    id: 'u8',
    name: 'Admin User',
    email: 'admin@premiumhub.com',
    avatarUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
    role: UserRole.admin,
    status: UserStatus.active,
    joinedAt: DateTime(2023, 1, 1),
  ),
];
