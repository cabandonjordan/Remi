import 'package:flutter/material.dart';
import 'package:app/widgets/remi_avatar.dart';

enum _TriageLevel { normal, caution, urgent, emergency }

class _TriageSignal {
  const _TriageSignal({
    required this.level,
    required this.reason,
    required this.message,
    required this.keywords,
  });

  final _TriageLevel level;
  final String reason;
  final String message;
  final List<String> keywords;
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  late AnimationController _listeningController;
  final TextEditingController _messageController = TextEditingController();
  bool _isPanicMode = false;
  bool _lockAdviceToEmergency = false;
  _TriageSignal? _latestTriageSignal;

  final List<Map<String, dynamic>> _messages = [
    {
      'type': 'remi',
      'text': 'Hi! I can help monitor how you are doing. Tell me about your pain, swelling, temperature, or any wound changes.',
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

    final triage = _triageText(text);

    setState(() {
      _messages.add({
        'type': 'user',
        'text': text,
        'timestamp': DateTime.now(),
      });
      _latestTriageSignal = triage;
      _isPanicMode = triage.level != _TriageLevel.normal;
      _lockAdviceToEmergency = triage.level == _TriageLevel.emergency;
      _messageController.clear();
    });

    // Simulate Remi response
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'type': 'remi',
            'text': _buildAssistantReply(triage),
            'timestamp': DateTime.now(),
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final avatarState = _lockAdviceToEmergency
        ? RemiAvatarState.alert
        : _isPanicMode
            ? RemiAvatarState.thinking
            : RemiAvatarState.happy;

    return Scaffold(
      backgroundColor: _lockAdviceToEmergency
          ? const Color(0xFFFFF4F0)
          : _isPanicMode
              ? const Color(0xFFFFF8E8)
              : const Color(0xFFFAF9F6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _lockAdviceToEmergency
            ? Colors.red.shade200
            : _isPanicMode
                ? Colors.orange.shade200
                : Colors.transparent,
        title: Row(
          children: [
            RemiAvatar(
              size: 40,
              state: avatarState,
              autoAnimate: true,
            ),
            const SizedBox(width: 12),
            Text(
              'Remi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _lockAdviceToEmergency ? Colors.red.shade900 : null,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          if (_latestTriageSignal != null && _latestTriageSignal!.level != _TriageLevel.normal)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              color: _lockAdviceToEmergency ? Colors.red.shade100 : Colors.orange.shade100,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    _lockAdviceToEmergency ? Icons.emergency : Icons.info_outline,
                    color: _lockAdviceToEmergency ? Colors.red.shade700 : Colors.orange.shade700,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _latestTriageSignal!.message,
                      style: TextStyle(
                        color: _lockAdviceToEmergency ? Colors.red.shade900 : Colors.orange.shade900,
                        fontSize: 13,
                        height: 1.45,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
              color: _lockAdviceToEmergency ? Colors.red.shade100 : Colors.orange.shade100,
              child: Row(
                children: [
                  Icon(
                    _lockAdviceToEmergency ? Icons.warning_amber_rounded : Icons.info_outline,
                    color: _lockAdviceToEmergency ? Colors.red : Colors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _lockAdviceToEmergency
                          ? 'Emergency guidance is active. Please seek professional medical care now and use emergency services if symptoms feel severe or unsafe.'
                          : 'Let\'s take a moment. Try the breathing exercise below.',
                      style: TextStyle(
                        color: _lockAdviceToEmergency ? Colors.red.shade900 : Colors.orange.shade900,
                        fontSize: 13,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                      ),
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
                        enabled: !_lockAdviceToEmergency,
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: _lockAdviceToEmergency
                              ? 'Emergency mode is active'
                              : 'Tell me how you\'re feeling...',
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
                      onTap: _lockAdviceToEmergency ? null : () => _sendMessage(_messageController.text),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _lockAdviceToEmergency ? Colors.red.shade300 : Colors.teal.shade400,
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

  _TriageSignal _triageText(String text) {
    final lower = text.toLowerCase();
    final emergencyKeywords = [
      'chest pain',
      'trouble breathing',
      'shortness of breath',
      'blue lips',
      'passing out',
      'fainting',
      'severe bleeding',
      'uncontrolled bleeding',
      'suicidal',
      'overdose',
      'stroke',
      'heart attack',
      'call 911',
      'emergency room',
    ];
    final urgentKeywords = [
      'fever',
      'spreading redness',
      'foul smell',
      'pus',
      'worsening pain',
      'sharp pain',
      'hot to touch',
      'swelling worse',
      'not improving',
      'pain 8',
      'pain 9',
      'pain 10',
    ];
    final cautionKeywords = [
      'concerned',
      'worried',
      'nauseous',
      'dizzy',
      'itchy',
      'redness',
      'tender',
      'sore',
      'help',
    ];

    final emergencyHits = emergencyKeywords.where(lower.contains).toList(growable: false);
    if (emergencyHits.isNotEmpty) {
      return _TriageSignal(
        level: _TriageLevel.emergency,
        reason: 'Emergency keywords detected: ${emergencyHits.join(', ')}',
        message:
            'Emergency red flags detected. Please seek professional medical care now. If breathing, bleeding, chest pain, or loss of consciousness is involved, call emergency services immediately.',
        keywords: emergencyHits,
      );
    }

    final urgentHits = urgentKeywords.where(lower.contains).toList(growable: false);
    if (urgentHits.length >= 2 || (urgentHits.isNotEmpty && lower.contains(RegExp(r'\b(48|72)\s*hours?\b'))) ) {
      return _TriageSignal(
        level: _TriageLevel.emergency,
        reason: 'Persistent or compounding urgent symptoms detected.',
        message:
            'Concerning symptom trend detected over time. The assistant is locked to emergency guidance: please seek professional medical care promptly for an in-person assessment.',
        keywords: urgentHits,
      );
    }

    if (urgentHits.isNotEmpty) {
      return _TriageSignal(
        level: _TriageLevel.urgent,
        reason: 'Urgent symptom keywords detected: ${urgentHits.join(', ')}',
        message:
            'Possible complication signals detected. Please contact a clinician or urgent care today, especially if the pain, swelling, or fever is getting worse.',
        keywords: urgentHits,
      );
    }

    final cautionHits = cautionKeywords.where(lower.contains).toList(growable: false);
    if (cautionHits.isNotEmpty) {
      return _TriageSignal(
        level: _TriageLevel.caution,
        reason: 'Caution keywords detected: ${cautionHits.join(', ')}',
        message:
            'I noticed signs worth watching closely. If symptoms escalate, become more painful, or do not improve, please reach out to a healthcare professional.',
        keywords: cautionHits,
      );
    }

    return _TriageSignal(
      level: _TriageLevel.normal,
      reason: 'No red-flag keywords detected.',
      message: 'No red flags detected in the current message.',
      keywords: const [],
    );
  }

  String _buildAssistantReply(_TriageSignal triage) {
    switch (triage.level) {
      case _TriageLevel.emergency:
        return 'I detected a serious safety signal, so I can\'t provide routine advice. Please seek professional medical care now. If this involves chest pain, trouble breathing, severe bleeding, confusion, or fainting, call emergency services immediately.';
      case _TriageLevel.urgent:
        return 'I\'m seeing warning signs that deserve a same-day clinician or urgent care check. If the symptoms are worsening, don\'t wait to get evaluated in person.';
      case _TriageLevel.caution:
        return 'I noticed something that deserves closer monitoring. If the pain, swelling, redness, or temperature increases, please contact a healthcare professional.';
      case _TriageLevel.normal:
        return 'I hear you. I can help track what\'s changing and compare it against your recovery timeline.';
    }
  }

  Widget _buildChatBubble(Map<String, dynamic> message) {
    final isRemi = message['type'] == 'remi';
    final isEmergency = isRemi && _lockAdviceToEmergency;
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
                color: isEmergency
                    ? Colors.red.shade50
                    : isRemi
                        ? const Color(0xFFF5F5F5)
                        : Colors.teal.shade100,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(24),
                  topRight: const Radius.circular(24),
                  bottomLeft: Radius.circular(isRemi ? 0 : 24),
                  bottomRight: Radius.circular(isRemi ? 24 : 0),
                ),
                border: isEmergency ? Border.all(color: Colors.red.shade200, width: 1.4) : null,
              ),
              child: Text(
                message['text'],
                style: TextStyle(
                  color: isEmergency
                      ? Colors.red.shade900
                      : isRemi
                          ? Colors.grey.shade800
                          : Colors.grey.shade900,
                  fontSize: 15,
                  height: 1.4,
                  fontWeight: isEmergency ? FontWeight.w600 : FontWeight.normal,
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
