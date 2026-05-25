import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WelcomeBackScreen extends StatefulWidget {
  const WelcomeBackScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeBackScreen> createState() => _WelcomeBackScreenState();
}

class _WelcomeBackScreenState extends State<WelcomeBackScreen> {
  bool _showPasswordForm = false;
  bool _rememberMe = false;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else if (hour < 21) {
      return 'Good evening';
    } else {
      return 'Good night';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final greeting = _getTimeBasedGreeting();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F1E8), // Warm cream
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.06),
                // Time-aware greeting
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '$greeting, ',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF5A7A7A),
                        ),
                      ),
                      TextSpan(
                        text: 'Jordan',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1F3A3A),
                        ),
                      ),
                      TextSpan(
                        text: '.',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(duration: const Duration(milliseconds: 500))
                    .slideY(
                      begin: -0.2,
                      end: 0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutCubic,
                    ),
                const SizedBox(height: 12),
                Text(
                  "I'm glad you're back.",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                  ),
                )
                    .animate()
                    .fadeIn(
                      delay: const Duration(milliseconds: 150),
                      duration: const Duration(milliseconds: 500),
                    )
                    .slideY(
                      begin: -0.2,
                      end: 0,
                      delay: const Duration(milliseconds: 150),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutCubic,
                    ),
                SizedBox(height: screenHeight * 0.08),
                // Remi Avatar - Happy State
                Image.asset(
                  'lib/assets/images/REMI-LOGO-Official.png',
                  height: 180,
                )
                    .animate()
                    .scale(
                      begin: Offset(0.7, 0.7),
                      end: const Offset(1.0, 1.0),
                      delay: const Duration(milliseconds: 300),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.elasticOut,
                    )
                    .fadeIn(
                      delay: const Duration(milliseconds: 300),
                      duration: const Duration(milliseconds: 500),
                    ),
                SizedBox(height: screenHeight * 0.08),
                // Biometric Login Section
                if (!_showPasswordForm)
                  Column(
                    children: [
                      Text(
                        'Quick Sign In',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F3A3A),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Biometric button
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.15),
                              blurRadius: 16,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 72,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                '/dashboard',
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.fingerprint,
                                  size: 32,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Use Face ID or Fingerprint',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(
                            delay: const Duration(milliseconds: 600),
                            duration: const Duration(milliseconds: 500),
                          )
                          .slideY(
                            begin: 0.3,
                            end: 0,
                            delay: const Duration(milliseconds: 600),
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOutCubic,
                          ),
                      const SizedBox(height: 20),
                      // Divider with text
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'or',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ],
                      )
                          .animate()
                          .fadeIn(
                            delay: const Duration(milliseconds: 700),
                            duration: const Duration(milliseconds: 400),
                          ),
                      const SizedBox(height: 20),
                      // Password login link
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showPasswordForm = true;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'Sign in with password',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(
                              delay: const Duration(milliseconds: 800),
                              duration: const Duration(milliseconds: 400),
                            ),
                      ),
                    ],
                  )
                else
                  // Password Form
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showPasswordForm = false;
                            _emailController.clear();
                            _passwordController.clear();
                            _rememberMe = false;
                          });
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_back,
                              size: 20,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Back',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(duration: const Duration(milliseconds: 300))
                          .slideY(
                            begin: -0.1,
                            end: 0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutCubic,
                          ),
                      const SizedBox(height: 16),
                      // Divider
                      Container(
                        height: 1,
                        color: Colors.grey.shade200,
                      ),
                      const SizedBox(height: 20),
                      // Email field
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: theme.colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      )
                          .animate()
                          .fadeIn(
                            duration: const Duration(milliseconds: 300),
                          )
                          .slideY(
                            begin: -0.2,
                            end: 0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutCubic,
                          ),
                      const SizedBox(height: 16),
                      // Password field
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        textInputAction: TextInputAction.go,
                        onSubmitted: (_) {
                          Navigator.pushReplacementNamed(
                            context,
                            '/dashboard',
                          );
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: theme.colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      )
                          .animate()
                          .fadeIn(
                            delay: const Duration(milliseconds: 100),
                            duration: const Duration(milliseconds: 300),
                          )
                          .slideY(
                            begin: 0.2,
                            end: 0,
                            delay: const Duration(milliseconds: 100),
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutCubic,
                          ),
                      const SizedBox(height: 12),
                      // Remember me & Forgot password row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              Text(
                                'Remember me',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Password reset link sent to your email'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Text(
                              'Forgot password?',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      )
                          .animate()
                          .fadeIn(
                            delay: const Duration(milliseconds: 150),
                            duration: const Duration(milliseconds: 300),
                          ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              '/dashboard',
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Sign In',
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(
                            delay: const Duration(milliseconds: 200),
                            duration: const Duration(milliseconds: 300),
                          )
                          .slideY(
                            begin: 0.2,
                            end: 0,
                            delay: const Duration(milliseconds: 200),
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutCubic,
                          ),
                    ],
                  ),
                SizedBox(height: screenHeight * 0.04),
                // Don't have account link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushReplacementNamed(context, '/conversational-signup'),
                      child: Text(
                        'Create one',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(
                      delay: const Duration(milliseconds: 900),
                      duration: const Duration(milliseconds: 400),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
