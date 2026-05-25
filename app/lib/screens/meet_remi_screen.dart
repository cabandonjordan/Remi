import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MeetRemiScreen extends StatefulWidget {
  const MeetRemiScreen({Key? key}) : super(key: key);

  @override
  State<MeetRemiScreen> createState() => _MeetRemiScreenState();
}

class _MeetRemiScreenState extends State<MeetRemiScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0), // Warm cream background
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.04),
                    // Remi Logo with animation
                    Image.asset(
                      'lib/assets/images/REMI-LOGO-Official.png',
                      height: 160,
                    )
                        .animate()
                        .scale(
                          begin: Offset(0.8, 0.8),
                          end: const Offset(1.0, 1.0),
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.elasticOut,
                        )
                        .fadeIn(duration: const Duration(milliseconds: 400)),
                    SizedBox(height: screenHeight * 0.05),
                    // Greeting Text with stagger animation
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          Text(
                            "Hi, I'm Remi",
                            style: theme.textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF1F3A3A),
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                          )
                              .animate()
                              .fadeIn(duration: const Duration(milliseconds: 600))
                              .slideX(
                                begin: -0.3,
                                end: 0,
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.easeOutCubic,
                              ),
                          const SizedBox(height: 16),
                          Text(
                            "I'm here to help you heal, stress less, and feel better.",
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: const Color(0xFF5A7A7A),
                              height: 1.5,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          )
                              .animate()
                              .fadeIn(
                                delay: const Duration(milliseconds: 200),
                                duration: const Duration(milliseconds: 600),
                              )
                              .slideY(
                                begin: 0.2,
                                end: 0,
                                delay: const Duration(milliseconds: 200),
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.easeOutCubic,
                              ),
                          const SizedBox(height: 20),
                          // Feature cards
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                _buildFeatureCard(
                                  icon: Icons.favorite_outline,
                                  title: 'Personalized',
                                  subtitle: 'Tailored to your needs',
                                  theme: theme,
                                  delay: 400,
                                ),
                                const SizedBox(height: 12),
                                _buildFeatureCard(
                                  icon: Icons.psychology_outlined,
                                  title: 'Supportive',
                                  subtitle: 'Always here for you',
                                  theme: theme,
                                  delay: 500,
                                ),
                                const SizedBox(height: 12),
                                _buildFeatureCard(
                                  icon: Icons.lightbulb_outline,
                                  title: 'Compassionate',
                                  subtitle: 'Understanding your journey',
                                  theme: theme,
                                  delay: 600,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                  ],
                ),
              ),
            ),
            // Button at bottom
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      '/conversational-signup',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7DD3C0), // Pastel mint green
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    "Let's get to know each other",
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(
                      delay: const Duration(milliseconds: 400),
                      duration: const Duration(milliseconds: 600),
                    )
                    .slideY(
                      begin: 0.5,
                      end: 0,
                      delay: const Duration(milliseconds: 400),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOutCubic,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required ThemeData theme,
    required int delay,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF7DD3C0).withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF7DD3C0).withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF7DD3C0).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF7DD3C0),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF1F3A3A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF5A7A7A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: delay),
          duration: const Duration(milliseconds: 600),
        )
        .slideX(
          begin: 0.3,
          end: 0,
          delay: Duration(milliseconds: delay),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
        );
  }
}
