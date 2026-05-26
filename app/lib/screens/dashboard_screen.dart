import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _ringController;
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _ringController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _ringController.dispose();
    _floatController.dispose();
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
        ).animate().fadeIn(duration: 600.ms),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Notifications',
            onPressed: () {},
          ).animate().fadeIn(duration: 700.ms, delay: 100.ms),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/welcome-back');
            },
          ).animate().fadeIn(duration: 700.ms, delay: 200.ms),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // Warm, contextual greeting with fade-in
              Text(
                '${_getTimeBasedGreeting()},',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3E3F),
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.2, end: 0, duration: 600.ms),
              Text(
                'Jordan.',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF009688),
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 100.ms)
                  .slideX(begin: -0.2, end: 0, duration: 600.ms, delay: 100.ms),
              const SizedBox(height: 16),
              Text(
                'How is your energy today? 🌿',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 200.ms)
                  .slideX(begin: -0.2, end: 0, duration: 600.ms, delay: 200.ms),
              const SizedBox(height: 40),

              // Enhanced animated Remi avatar with concentric rings
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer pulsing ring
                    ScaleTransition(
                      scale: Tween(begin: 1.0, end: 1.4).animate(
                        CurvedAnimation(
                            parent: _ringController, curve: Curves.easeInOut),
                      ),
                      child: Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.teal.shade300.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    // Middle ring
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.teal.shade200.withOpacity(0.4),
                          width: 1.5,
                        ),
                      ),
                    ),
                    // Main avatar with pulse and float
                    ScaleTransition(
                      scale: Tween(begin: 0.95, end: 1.05).animate(
                        CurvedAnimation(
                            parent: _pulseController, curve: Curves.easeInOut),
                      ),
                      child: SlideTransition(
                        position: Tween(begin: Offset.zero, end: const Offset(0, -0.02))
                            .animate(CurvedAnimation(
                                parent: _floatController,
                                curve: Curves.easeInOut)),
                        child: Container(
                          width: 160,
                          height: 160,
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
                                color: Colors.teal.shade200.withOpacity(0.6),
                                blurRadius: 40,
                                spreadRadius: 15,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '😊',
                                      style: TextStyle(fontSize: 35),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 800.ms)
                            .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 800.ms),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Introduction card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.teal.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.favorite, color: Colors.teal, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "I\'m Remi, your health companion.",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF2D3E3F),
                                ),
                              ),
                              Text(
                                "I\'m here to listen, guide, and support you.",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 800.ms, delay: 300.ms)
                  .slideY(begin: 0.3, end: 0, duration: 800.ms, delay: 300.ms),
              const SizedBox(height: 28),

              // Quick Actions Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ).animate().fadeIn(duration: 600.ms, delay: 400.ms),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Customize',
                      style: TextStyle(
                        color: Colors.teal.shade400,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 400.ms),
                ],
              ),
              const SizedBox(height: 16),

              // Quick action cards with staggered animation
              _buildAnimatedQuickActionCard(
                index: 0,
                icon: Icons.favorite_outline,
                title: 'Talk to Remi',
                description: 'Chat about anything on your mind',
                backgroundColor: const Color(0xFFE8F5E9),
                accentColor: const Color(0xFF4CAF50),
                onTap: () => Navigator.pushNamed(context, '/chat'),
              ),

              _buildAnimatedQuickActionCard(
                index: 1,
                icon: Icons.camera_alt_outlined,
                title: 'Scan an Injury',
                description: 'Use your camera to check an injury',
                backgroundColor: const Color(0xFFFFF3E0),
                accentColor: const Color(0xFFFFA726),
                onTap: () => Navigator.pushNamed(context, '/camera'),
              ),

              _buildAnimatedQuickActionCard(
                index: 2,
                icon: Icons.assignment_outlined,
                title: 'Log a Symptom',
                description: 'Track how you\'re feeling today',
                backgroundColor: const Color(0xFFE3F2FD),
                accentColor: const Color(0xFF42A5F5),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Symptom logging coming soon!')),
                  );
                },
              ),

              const SizedBox(height: 12),

              // 4th card - View Recovery Journey
              _buildAnimatedQuickActionCard(
                index: 3,
                icon: Icons.timeline,
                title: 'View Recovery Journey',
                description: 'Track your healing progress',
                backgroundColor: const Color(0xFFF3E5F5),
                accentColor: const Color(0xFFAB47BC),
                onTap: () => Navigator.pushNamed(context, '/timeline'),
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.teal.shade400,
          unselectedItemColor: Colors.grey.shade400,
          onTap: (index) {
            switch (index) {
              case 0:
                // Already on home
                break;
              case 1:
                Navigator.pushNamed(context, '/timeline');
                break;
              case 2:
                Navigator.pushNamed(context, '/camera');
                break;
              case 3:
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Insights page coming soon')),
                );
                break;
              case 4:
                Navigator.pushNamed(context, '/profile');
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined),
              activeIcon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              activeIcon: Icon(Icons.add_circle),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart),
              label: 'Insights',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedQuickActionCard({
    required int index,
    required IconData icon,
    required String title,
    required String description,
    required Color backgroundColor,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            hoverColor: accentColor.withOpacity(0.1),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withOpacity(0.1),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(icon, size: 28, color: accentColor),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xFF2D3E3F),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios,
                      color: accentColor.withOpacity(0.6), size: 18),
                ],
              ),
            ),
          ),
        ),
      )
          .animate(delay: Duration(milliseconds: 100 * index))
          .fadeIn(duration: 600.ms)
          .slideX(begin: 0.3, end: 0, duration: 600.ms, curve: Curves.easeOut),
    );
  }
}

