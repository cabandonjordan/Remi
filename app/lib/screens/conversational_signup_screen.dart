import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ConversationalSignupScreen extends StatefulWidget {
  const ConversationalSignupScreen({Key? key}) : super(key: key);

  @override
  State<ConversationalSignupScreen> createState() =>
      _ConversationalSignupScreenState();
}

class _ConversationalSignupScreenState extends State<ConversationalSignupScreen>
    with TickerProviderStateMixin {
  bool _showForm = false;
  late AnimationController _loadingController;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // Auto-transition from loading to form after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showForm = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _loadingController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    // Sign up logic would go here
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF0F8F6),
      body: SafeArea(
        child: _showForm ? _buildSignupForm(theme) : _buildLoadingState(theme),
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'lib/assets/images/REMI-LOGO-Official.png',
            height: 160,
          )
              .animate(onPlay: (controller) => _loadingController.forward())
              .scale(
                begin: Offset(0.7, 0.7),
                end: const Offset(1.0, 1.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
              )
              .fadeIn(duration: const Duration(milliseconds: 400)),
          const SizedBox(height: 32),
          Text(
            "Setting up your account...",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F3A3A),
            ),
          )
              .animate()
              .fadeIn(delay: const Duration(milliseconds: 200), duration: const Duration(milliseconds: 600))
              .slideY(begin: 0.2, end: 0, delay: const Duration(milliseconds: 200), duration: const Duration(milliseconds: 600), curve: Curves.easeOutCubic),
          const SizedBox(height: 16),
          Text(
            "Let me get to know you better",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          )
              .animate()
              .fadeIn(delay: const Duration(milliseconds: 400), duration: const Duration(milliseconds: 600)),
          const SizedBox(height: 32),
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              color: theme.colorScheme.primary,
              strokeWidth: 3,
            ),
          )
              .animate()
              .fadeIn(delay: const Duration(milliseconds: 600), duration: const Duration(milliseconds: 600)),
        ],
      ),
    );
  }

  Widget _buildSignupForm(ThemeData theme) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Let's get started",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1F3A3A),
                  ),
                )
                    .animate()
                    .fadeIn(duration: const Duration(milliseconds: 500))
                    .slideX(begin: -0.3, end: 0, duration: const Duration(milliseconds: 500), curve: Curves.easeOutCubic),
                const SizedBox(height: 8),
                Text(
                  "Tell me a bit about yourself",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 100), duration: const Duration(milliseconds: 500))
                    .slideX(begin: -0.3, end: 0, delay: const Duration(milliseconds: 100), duration: const Duration(milliseconds: 500), curve: Curves.easeOutCubic),
              ],
            ),
            SizedBox(height: screenHeight * 0.06),
            
            // Name Field
            _buildInputField(
              controller: _nameController,
              label: 'What should I call you?',
              hint: 'Your name',
              icon: Icons.person_outline,
              delay: 200,
              theme: theme,
            ),
            const SizedBox(height: 20),
            
            // Email Field
            _buildInputField(
              controller: _emailController,
              label: 'What\'s your email?',
              hint: 'you@example.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              delay: 300,
              theme: theme,
            ),
            const SizedBox(height: 20),
            
            // Password Field
            _buildInputField(
              controller: _passwordController,
              label: 'Create a password',
              hint: 'At least 8 characters',
              icon: Icons.lock_outline,
              isPassword: true,
              delay: 400,
              theme: theme,
            ),
            const SizedBox(height: 20),
            
            // Confirm Password Field
            _buildInputField(
              controller: _confirmPasswordController,
              label: 'Confirm password',
              hint: 'Re-enter your password',
              icon: Icons.check_circle_outline,
              isPassword: true,
              delay: 500,
              theme: theme,
            ),
            SizedBox(height: screenHeight * 0.06),
            
            // Sign Up Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _handleSignUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7DD3C0),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Text(
                  'Create Account',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            )
                .animate()
                .fadeIn(delay: const Duration(milliseconds: 600), duration: const Duration(milliseconds: 400))
                .slideY(begin: 0.3, end: 0, delay: const Duration(milliseconds: 600), duration: const Duration(milliseconds: 400), curve: Curves.easeOutCubic),
            const SizedBox(height: 16),
            
            // Sign In Link
            Center(
              child: TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/welcome-back'),
                child: RichText(
                  text: TextSpan(
                    text: "Already have an account? ",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                    children: [
                      TextSpan(
                        text: 'Sign In',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
                .animate()
                .fadeIn(delay: const Duration(milliseconds: 650), duration: const Duration(milliseconds: 400)),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    required int delay,
    required ThemeData theme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F3A3A),
          ),
        )
            .animate()
            .fadeIn(delay: Duration(milliseconds: delay), duration: const Duration(milliseconds: 400))
            .slideY(begin: 0.1, end: 0, delay: Duration(milliseconds: delay), duration: const Duration(milliseconds: 400), curve: Curves.easeOutCubic),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade400,
            ),
            prefixIcon: Icon(icon, color: Colors.grey.shade400),
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        )
            .animate()
            .fadeIn(delay: Duration(milliseconds: delay + 50), duration: const Duration(milliseconds: 400))
            .slideY(begin: 0.2, end: 0, delay: Duration(milliseconds: delay + 50), duration: const Duration(milliseconds: 400), curve: Curves.easeOutCubic),
      ],
    );
  }
}
