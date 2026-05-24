import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../models/app_user.dart';
import '../models/service_member.dart';
import '../services/member_service.dart';
import '../../../core/services/log_service.dart';
import 'user_add_screen.dart';

class UserManagementTableScreen extends StatefulWidget {
  const UserManagementTableScreen({super.key});

  @override
  State<UserManagementTableScreen> createState() =>
      _UserManagementTableScreenState();
}

class _UserManagementTableScreenState extends State<UserManagementTableScreen> {
  late List<AppUser> _fullData = [];
  late List<AppUser> _displayData = [];
  final TextEditingController _searchController = TextEditingController();
  final MemberService _memberService = MemberService();
  bool _isLoading = true;
  bool _sortAscending = true;
  int _sortColumnIndex = 0;

  // Filter state
  UserRole? _roleFilter;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    LogService.info('_loadData is start');
    setState(() {
      _isLoading = true;
    });
    try {
      final members = await _memberService.getMembers();
      LogService.info('members: $members.length}');
      final users = members.map(_mapMemberToUser).toList();
      setState(() {
        LogService.info('users: $users');
        _fullData = users;
        _displayData = List.from(_fullData);
        _isLoading = false;
        _applyFilters();
      });
    } catch (e) {
      LogService.error('Failed to load users: $e');
      setState(() {
        _isLoading = false;
        _fullData = [];
        _displayData = [];
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load users: $e')));
      }
    }
  }

  AppUser _mapMemberToUser(ServiceMember member) {
    UserStatus status;
    if (member.blocked) {
      status = UserStatus.suspended;
    } else if (!member.confirmed) {
      status = UserStatus.pending;
    } else {
      status = UserStatus.active;
    }

    return AppUser(
      id: member.documentId ?? member.id?.toString() ?? '',
      name: member.username,
      email: member.email,
      avatarUrl:
          'https://ui-avatars.com/api/?name=${Uri.encodeComponent(member.username)}&background=random',
      role: UserRole.customer,
      status: status,
      joinedAt:
          DateTime.now(), // Strapi API might not return createdAt in standard payload
    );
  }

  ServiceMember _mapUserToMember(AppUser user) {
    return ServiceMember(
      documentId: user.id,
      username: user.name,
      email: user.email,
      blocked: user.status == UserStatus.suspended,
      confirmed: user.status != UserStatus.pending,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _displayData = _fullData.where((u) {
        final matchesQuery =
            u.name.toLowerCase().contains(query) ||
            u.email.toLowerCase().contains(query);
        final matchesRole = _roleFilter == null || u.role == _roleFilter;
        return matchesQuery && matchesRole;
      }).toList();
    });
  }

  void _onSearchChanged(String _) => _applyFilters();

  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      if (columnIndex == 0) {
        _displayData.sort(
          (a, b) =>
              ascending ? a.name.compareTo(b.name) : b.name.compareTo(a.name),
        );
      } else if (columnIndex == 1) {
        _displayData.sort(
          (a, b) => ascending
              ? a.email.compareTo(b.email)
              : b.email.compareTo(a.email),
        );
      } else if (columnIndex == 4) {
        _displayData.sort(
          (a, b) => ascending
              ? a.joinedAt.compareTo(b.joinedAt)
              : b.joinedAt.compareTo(a.joinedAt),
        );
      }
    });
  }

  Future<void> _toggleStatus(AppUser user) async {
    final newStatus = user.status == UserStatus.active
        ? UserStatus.suspended
        : UserStatus.active;
    final updatedUser = user.copyWith(status: newStatus);

    // Optimistic UI update
    setState(() {
      final i = _fullData.indexWhere((u) => u.id == user.id);
      if (i != -1) _fullData[i] = updatedUser;
      _applyFilters();
    });

    try {
      final member = _mapUserToMember(updatedUser);
      await _memberService.updateMember(member.documentId!, member);
      LogService.info('User ${user.name} status changed to ${newStatus.name}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${user.name} is now ${newStatus.name}'),
            backgroundColor: newStatus == UserStatus.active
                ? Colors.green
                : Colors.red,
          ),
        );
      }
    } catch (e) {
      LogService.error('Failed to update status: $e');
      // Revert optimistic update
      setState(() {
        final i = _fullData.indexWhere((u) => u.id == user.id);
        if (i != -1) _fullData[i] = user;
        _applyFilters();
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to update: $e')));
      }
    }
  }

  Future<void> _deleteUser(AppUser user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete User', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to delete "${user.name}"? This cannot be undone.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'CANCEL',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'DELETE',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _memberService.deleteMember(user.id);
        setState(() {
          _fullData.removeWhere((u) => u.id == user.id);
          _applyFilters();
          LogService.info('User deleted: ${user.id}');
        });
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('${user.name} deleted')));
        }
      } catch (e) {
        LogService.error('Failed to delete user: $e');
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to delete user: $e')));
        }
      }
    }
  }

  Future<void> _openAddUser() async {
    LogService.info('Opening Add User screen');
    final newUser = await Navigator.push<AppUser>(
      context,
      MaterialPageRoute(builder: (context) => const UserAddScreen()),
    );

    if (newUser != null) {
      setState(() {
        _fullData.insert(0, newUser);
        _applyFilters();
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${newUser.name} added successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _showRoleFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter by Role',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...[
                null,
                UserRole.customer,
                UserRole.provider,
                UserRole.admin,
              ].map((role) {
                final label = role == null
                    ? 'All Roles'
                    : role.name[0].toUpperCase() + role.name.substring(1);
                return ListTile(
                  title: Text(
                    label,
                    style: TextStyle(
                      color: _roleFilter == role
                          ? Colors.amber
                          : Colors.white70,
                    ),
                  ),
                  trailing: _roleFilter == role
                      ? const Icon(
                          LucideIcons.check,
                          color: Colors.amber,
                          size: 18,
                        )
                      : null,
                  onTap: () {
                    setState(() => _roleFilter = role);
                    _applyFilters();
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  // ── Role & Status badge helpers ──────────────────────────────────────────

  Color _roleColor(UserRole r) {
    switch (r) {
      case UserRole.customer:
        return Colors.blueAccent;
      case UserRole.provider:
        return Colors.amber;
      case UserRole.admin:
        return Colors.purpleAccent;
    }
  }

  Color _statusColor(UserStatus s) {
    switch (s) {
      case UserStatus.active:
        return Colors.green;
      case UserStatus.suspended:
        return Colors.red;
      case UserStatus.pending:
        return Colors.orange;
    }
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    LogService.screenLoad('UserManagementTableScreen');
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('User Management Table'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            tooltip: 'Add New User',
            icon: const Icon(LucideIcons.plusCircle, color: Colors.amber),
            onPressed: _openAddUser,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Summary chips ──────────────────────────────────────────
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _SummaryChip(
                      label: 'Total',
                      count: _fullData.length,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 10),
                    _SummaryChip(
                      label: 'Active',
                      count: _fullData
                          .where((u) => u.status == UserStatus.active)
                          .length,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 10),
                    _SummaryChip(
                      label: 'Suspended',
                      count: _fullData
                          .where((u) => u.status == UserStatus.suspended)
                          .length,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 10),
                    _SummaryChip(
                      label: 'Pending',
                      count: _fullData
                          .where((u) => u.status == UserStatus.pending)
                          .length,
                      color: Colors.orange,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Search bar ─────────────────────────────────────────────
              _GlassBox(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        LucideIcons.search,
                        color: Colors.amber,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Search name or email...',
                            hintStyle: TextStyle(color: Colors.white24),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          LucideIcons.filter,
                          color: _roleFilter != null
                              ? Colors.amber
                              : Colors.white38,
                          size: 20,
                        ),
                        tooltip: 'Filter by role',
                        onPressed: _showRoleFilterSheet,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Data table ─────────────────────────────────────────────
              _isLoading
                  ? const Padding(
                      padding: EdgeInsets.only(top: 48),
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.amber),
                      ),
                    )
                  : _displayData.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 48),
                        child: Column(
                          children: [
                            Icon(
                              LucideIcons.userX,
                              size: 48,
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No users found',
                              style: TextStyle(color: Colors.white24),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: _GlassBox(
                        child: DataTable(
                          sortAscending: _sortAscending,
                          sortColumnIndex: _sortColumnIndex,
                          headingTextStyle: const TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          dataTextStyle: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                          dividerThickness: 0.3,
                          columns: [
                            DataColumn(
                              label: const Text('NAME'),
                              onSort: _onSort,
                            ),
                            DataColumn(
                              label: const Text('EMAIL'),
                              onSort: _onSort,
                            ),
                            const DataColumn(label: Text('ROLE')),
                            const DataColumn(label: Text('STATUS')),
                            DataColumn(
                              label: const Text('JOINED'),
                              onSort: _onSort,
                            ),
                            const DataColumn(label: Text('ACTIONS')),
                          ],
                          rows: _displayData.map((user) {
                            return DataRow(
                              cells: [
                                // NAME
                                DataCell(
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundImage: NetworkImage(
                                          user.avatarUrl,
                                        ),
                                        backgroundColor: Colors.white10,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        user.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // EMAIL
                                DataCell(
                                  Text(
                                    user.email,
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                // ROLE
                                DataCell(
                                  _badge(user.role.name, _roleColor(user.role)),
                                ),
                                // STATUS
                                DataCell(
                                  _badge(
                                    user.status.name,
                                    _statusColor(user.status),
                                  ),
                                ),
                                // JOINED
                                DataCell(
                                  Text(
                                    dateFormat.format(user.joinedAt),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                // ACTIONS
                                DataCell(
                                  Row(
                                    children: [
                                      // Toggle active/suspended
                                      if (user.role != UserRole.admin)
                                        Tooltip(
                                          message:
                                              user.status == UserStatus.active
                                              ? 'Suspend'
                                              : 'Activate',
                                          child: InkWell(
                                            onTap: () => _toggleStatus(user),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(6),
                                              child: Icon(
                                                user.status == UserStatus.active
                                                    ? LucideIcons.userX
                                                    : LucideIcons.userCheck,
                                                size: 16,
                                                color:
                                                    user.status ==
                                                        UserStatus.active
                                                    ? Colors.orange
                                                    : Colors.green,
                                              ),
                                            ),
                                          ),
                                        ),
                                      // Delete
                                      if (user.role != UserRole.admin)
                                        Tooltip(
                                          message: 'Delete',
                                          child: InkWell(
                                            onTap: () => _deleteUser(user),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.all(6),
                                              child: Icon(
                                                LucideIcons.trash2,
                                                size: 16,
                                                color: Colors.redAccent,
                                              ),
                                            ),
                                          ),
                                        ),
                                      // Admin badge (no actions)
                                      if (user.role == UserRole.admin)
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 6,
                                          ),
                                          child: Icon(
                                            LucideIcons.shieldCheck,
                                            size: 16,
                                            color: Colors.purpleAccent,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Summary Chip ─────────────────────────────────────────────────────────────

class _SummaryChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _SummaryChip({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: color.withValues(alpha: 0.7), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// ── Glass Box ────────────────────────────────────────────────────────────────

class _GlassBox extends StatelessWidget {
  final Widget child;

  const _GlassBox({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: child,
    );
  }
}
