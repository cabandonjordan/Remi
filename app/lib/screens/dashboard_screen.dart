import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String _getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 18) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Remi',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // Warm, contextual greeting
              Text(
                '${_getTimeBasedGreeting()}, Jordan.',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3E3F),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'How is your energy level today?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 48),

              // Centerpiece: Soft, pulsing Remi avatar/orb
              Center(
                child: ScaleTransition(
                  scale: Tween(begin: 0.9, end: 1.1).animate(
                    CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
                  ),
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.teal.shade300,
                          Colors.teal.shade100,
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal.shade200.withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.favorite,
                        size: 80,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // Quick Actions
              Text(
                'What can I help with?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 16),

              _buildQuickActionCard(
                icon: Icons.chat_bubble_outline,
                title: 'Talk to Remi',
                description: 'Start a conversation',
                backgroundColor: const Color(0xFFE8F5E9),
                accentColor: const Color(0xFF4CAF50),
                onTap: () => Navigator.pushNamed(context, '/chat'),
              ),
              const SizedBox(height: 12),

              _buildQuickActionCard(
                icon: Icons.camera_alt_outlined,
                title: 'Scan an Injury',
                description: 'Visual healing tracker',
                backgroundColor: const Color(0xFFE0F2F1),
                accentColor: const Color(0xFF009688),
                onTap: () => Navigator.pushNamed(context, '/camera'),
              ),
              const SizedBox(height: 12),

              _buildQuickActionCard(
                icon: Icons.notes_outlined,
                title: 'Log a Symptom',
                description: 'Quick symptom check-in',
                backgroundColor: const Color(0xFFFFF9C4),
                accentColor: const Color(0xFFFBC02D),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Symptom logging coming soon!')),
                  );
                },
              ),
              const SizedBox(height: 12),

              _buildQuickActionCard(
                icon: Icons.timeline,
                title: 'View Recovery Journey',
                description: 'Your healing progress',
                backgroundColor: const Color(0xF0E8D5F6),
                accentColor: const Color(0xFF7C3AED),
                onTap: () => Navigator.pushNamed(context, '/timeline'),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String description,
    required Color backgroundColor,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 32, color: accentColor),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF2D3E3F),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: accentColor, size: 20),
          ],
        ),
      ),
    );
  }
}

