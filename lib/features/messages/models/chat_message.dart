class ChatMessage {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isMe;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.isMe,
  });

  static List<ChatMessage> demoMessages = [
    ChatMessage(
      id: '1',
      senderId: 'user1',
      text: 'Hi Alice! Are you available today?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 60)),
      isMe: true,
    ),
    ChatMessage(
      id: '2',
      senderId: 'alice',
      text: 'Hi! Yes, I am. What time?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 55)),
      isMe: false,
    ),
    ChatMessage(
      id: '3',
      senderId: 'user1',
      text: 'Can you come at 3:00 PM?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 50)),
      isMe: true,
    ),
    ChatMessage(
      id: '4',
      senderId: 'alice',
      text: 'Sure, I will be there then. See you!',
      timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
      isMe: false,
    ),
    ChatMessage(
      id: '5',
      senderId: 'alice',
      text: 'Wait, let me check my schedule again.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 40)),
      isMe: false,
    ),
    ChatMessage(
      id: '6',
      senderId: 'alice',
      text: 'Okay, it is fine. I will be there!',
      timestamp: DateTime.now().subtract(const Duration(minutes: 35)),
      isMe: false,
    ),
  ];
}
