class Conversation {
  final String id;
  final String otherParticipantName;
  final String otherParticipantAvatar;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isOnline;

  Conversation({
    required this.id,
    required this.otherParticipantName,
    required this.otherParticipantAvatar,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.isOnline = false,
  });

  static List<Conversation> demoConversations = [
    Conversation(
      id: '1',
      otherParticipantName: 'Alice Johnson',
      otherParticipantAvatar: 'https://randomuser.me/api/portraits/women/1.jpg',
      lastMessage: 'I will be there in 15 minutes. See you soon!',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
      unreadCount: 2,
      isOnline: true,
    ),
    Conversation(
      id: '2',
      otherParticipantName: 'John Smith',
      otherParticipantAvatar: 'https://randomuser.me/api/portraits/men/2.jpg',
      lastMessage: 'The service is completed. Please let me know if you need anything else.',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
      unreadCount: 0,
      isOnline: false,
    ),
    Conversation(
      id: '3',
      otherParticipantName: 'Emma Wilson',
      otherParticipantAvatar: 'https://randomuser.me/api/portraits/women/3.jpg',
      lastMessage: 'Can we reschedule our appointment to tomorrow?',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 0,
      isOnline: true,
    ),
  ];
}
