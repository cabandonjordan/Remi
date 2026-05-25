import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/remi_avatar.dart';

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
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.08),
                    // Remi Avatar with animation
                    RemiAvatar(
                      state: RemiAvatarState.waving,
                      size: 180,
                      autoAnimate: true,
                    )
                        .animate()
                        .scale(
                          begin: Offset(0.8, 0.8),
                          end: const Offset(1.0, 1.0),
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.elasticOut,
                        )
                        .fadeIn(duration: const Duration(milliseconds: 400)),
                    SizedBox(height: screenHeight * 0.1),
                    // Greeting Text with stagger animation
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
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
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.08),
                  ],
                ),
              ),
            ),
            // Button at bottom
            Padding(
              padding: const EdgeInsets.all(32),
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
}
