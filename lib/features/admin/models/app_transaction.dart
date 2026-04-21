enum TransactionType { booking, refund, topUp, withdrawal, fee }

enum TransactionStatus { completed, pending, failed, refunded }

class AppTransaction {
  final String id;
  final String userId;
  final String userName;
  final String description;
  final double amount;
  final TransactionType type;
  final TransactionStatus status;
  final DateTime createdAt;

  const AppTransaction({
    required this.id,
    required this.userId,
    required this.userName,
    required this.description,
    required this.amount,
    required this.type,
    required this.status,
    required this.createdAt,
  });
}

// ── Demo Data ────────────────────────────────────────────────────────────────

final List<AppTransaction> demoTransactions = [
  AppTransaction(
    id: 'TXN-0001',
    userId: 'u1',
    userName: 'Alice Morgan',
    description: 'Booking – Aromatherapy Massage (Sarah J.)',
    amount: 85.00,
    type: TransactionType.booking,
    status: TransactionStatus.completed,
    createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
  ),
  AppTransaction(
    id: 'TXN-0002',
    userId: 'u2',
    userName: 'James Park',
    description: 'Booking – Private Chef Dining (Michael C.)',
    amount: 120.00,
    type: TransactionType.booking,
    status: TransactionStatus.completed,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  AppTransaction(
    id: 'TXN-0003',
    userId: 'u5',
    userName: 'Elena Rodriguez',
    description: 'Refund – Personal Shopping cancellation',
    amount: 65.00,
    type: TransactionType.refund,
    status: TransactionStatus.refunded,
    createdAt: DateTime.now().subtract(const Duration(days: 4)),
  ),
  AppTransaction(
    id: 'TXN-0004',
    userId: 'u1',
    userName: 'Alice Morgan',
    description: 'Wallet Top-Up',
    amount: 200.00,
    type: TransactionType.topUp,
    status: TransactionStatus.completed,
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
  ),
  AppTransaction(
    id: 'TXN-0005',
    userId: 'u3',
    userName: 'Sarah Johnson',
    description: 'Provider Earnings Withdrawal',
    amount: 340.00,
    type: TransactionType.withdrawal,
    status: TransactionStatus.completed,
    createdAt: DateTime.now().subtract(const Duration(days: 6)),
  ),
  AppTransaction(
    id: 'TXN-0006',
    userId: 'u2',
    userName: 'James Park',
    description: 'Platform Service Fee',
    amount: 12.00,
    type: TransactionType.fee,
    status: TransactionStatus.completed,
    createdAt: DateTime.now().subtract(const Duration(days: 7)),
  ),
  AppTransaction(
    id: 'TXN-0007',
    userId: 'u6',
    userName: 'David Kim',
    description: 'Wallet Top-Up – Payment Pending',
    amount: 150.00,
    type: TransactionType.topUp,
    status: TransactionStatus.pending,
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
  ),
  AppTransaction(
    id: 'TXN-0008',
    userId: 'u4',
    userName: 'Michael Chen',
    description: 'Provider Earnings Withdrawal – Failed',
    amount: 90.00,
    type: TransactionType.withdrawal,
    status: TransactionStatus.failed,
    createdAt: DateTime.now().subtract(const Duration(days: 3, hours: 2)),
  ),
  AppTransaction(
    id: 'TXN-0009',
    userId: 'u1',
    userName: 'Alice Morgan',
    description: 'Booking – Gold Suite Lounge entry',
    amount: 150.00,
    type: TransactionType.booking,
    status: TransactionStatus.completed,
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
  ),
  AppTransaction(
    id: 'TXN-0010',
    userId: 'u7',
    userName: 'Priya Patel',
    description: 'Platform Service Fee',
    amount: 8.50,
    type: TransactionType.fee,
    status: TransactionStatus.pending,
    createdAt: DateTime.now().subtract(const Duration(hours: 1)),
  ),
];
