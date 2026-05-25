import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  late AnimationController _listeningController;
  final TextEditingController _messageController = TextEditingController();
  bool _isPanicMode = false;

  final List<Map<String, dynamic>> _messages = [
    {
      'type': 'remi',
      'text': 'Hi! I noticed you were up late last night. How is your energy level today?',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 2)),
    },
  ];

  @override
  void initState() {
    super.initState();
    _listeningController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _listeningController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.isEmpty) return;

    // Check for panic words
    final panicWords = ['scared', 'panic', 'dying', 'help', 'emergency'];
    final hasPanicWords = panicWords.any((word) => text.toLowerCase().contains(word));

    setState(() {
      _messages.add({
        'type': 'user',
        'text': text,
        'timestamp': DateTime.now(),
      });
      _isPanicMode = hasPanicWords;
      _messageController.clear();
    });

    // Simulate Remi response
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'type': 'remi',
            'text': _isPanicMode
                ? 'I sense you\'re worried. Let\'s take a moment together. Would you like to do a quick breathing exercise?'
                : 'I hear you. Let me help you understand what\'s happening.',
            'timestamp': DateTime.now(),
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isPanicMode ? const Color(0xFFFFF3E0) : const Color(0xFFFAF9F6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _isPanicMode ? Colors.orange.shade200 : Colors.transparent,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade300, Colors.teal.shade100],
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: ScaleTransition(
                  scale: Tween(begin: 0.8, end: 1.2).animate(
                    CurvedAnimation(parent: _listeningController, curve: Curves.easeInOut),
                  ),
                  child: const Icon(Icons.favorite, size: 20, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Remi',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildChatBubble(message);
              },
            ),
          ),
          if (_isPanicMode)
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.orange.shade100,
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.orange, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Let\'s take a moment. Try the breathing exercise below.',
                      style: TextStyle(color: Colors.orange.shade900, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_messages.isNotEmpty && _messages.last['type'] == 'remi')
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildQuickReplyChip(
                            label: 'Guide my breathing',
                            icon: Icons.air,
                            onTap: () => _sendMessage('Guide my breathing'),
                          ),
                          const SizedBox(width: 8),
                          _buildQuickReplyChip(
                            label: 'It still hurts',
                            icon: Icons.health_and_safety,
                            onTap: () => _sendMessage('It still hurts'),
                          ),
                          const SizedBox(width: 8),
                          _buildQuickReplyChip(
                            label: 'I feel better',
                            icon: Icons.thumb_up,
                            onTap: () => _sendMessage('I feel better'),
                          ),
                        ],
                      ),
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Tell me how you\'re feeling...',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(color: Colors.teal.shade400),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        onSubmitted: (value) => _sendMessage(value),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => _sendMessage(_messageController.text),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade400,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.send, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(Map<String, dynamic> message) {
    final isRemi = message['type'] == 'remi';
    return Align(
      alignment: isRemi ? Alignment.centerLeft : Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: isRemi ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isRemi
                    ? const Color(0xFFF5F5F5)
                    : Colors.teal.shade100,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(24),
                  topRight: const Radius.circular(24),
                  bottomLeft: Radius.circular(isRemi ? 0 : 24),
                  bottomRight: Radius.circular(isRemi ? 24 : 0),
                ),
              ),
              child: Text(
                message['text'],
                style: TextStyle(
                  color: isRemi ? Colors.grey.shade800 : Colors.grey.shade900,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message['timestamp']),
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickReplyChip({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.teal.shade50,
          border: Border.all(color: Colors.teal.shade200),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.teal.shade700),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.teal.shade700,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes == 0) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
