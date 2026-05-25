import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/remi_avatar.dart';

class ConversationalSignupScreen extends StatefulWidget {
  const ConversationalSignupScreen({Key? key}) : super(key: key);

  @override
  State<ConversationalSignupScreen> createState() =>
      _ConversationalSignupScreenState();
}

class _ConversationalSignupScreenState extends State<ConversationalSignupScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _smileController;
  
  int _currentStep = 0;
  final int _totalSteps = 3;

  final Map<int, TextEditingController> _controllers = {
    0: TextEditingController(),
    1: TextEditingController(),
    2: TextEditingController(),
  };

  final List<Map<String, String>> _questions = [
    {
      'question': 'What should I call you?',
      'placeholder': 'Your name',
      'hint': 'This helps me know you better',
    },
    {
      'question': 'What\'s your email?',
      'placeholder': 'you@example.com',
      'hint': 'We\'ll keep it safe',
    },
    {
      'question': 'Create a password',
      'placeholder': 'At least 8 characters',
      'hint': 'Make it secure',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _smileController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _smileController.dispose();
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _nextQuestion() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      // Sign up complete, navigate to dashboard
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  void _previousQuestion() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F8F6), // Light sky blue
      body: SafeArea(
        child: Column(
          children: [
            // Header with progress and Remi mini avatar
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button (only if not first question)
                  if (_currentStep > 0)
                    IconButton(
                      onPressed: _previousQuestion,
                      icon: const Icon(Icons.arrow_back),
                      color: theme.colorScheme.primary,
                    )
                  else
                    const SizedBox(width: 48),
                  // Growing smile progress indicator
                  _buildSmileProgress(theme),
                  // Space for balance
                  const SizedBox(width: 48),
                ],
              ),
            ),
            // Step counter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Step ${_currentStep + 1} of $_totalSteps',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Main content - PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentStep = index;
                  });
                },
                itemCount: _totalSteps,
                itemBuilder: (context, index) {
                  return _buildQuestionCard(
                    context,
                    index,
                    theme,
                    screenHeight,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmileProgress(ThemeData theme) {
    return AnimatedBuilder(
      animation: _smileController,
      builder: (context, child) {
        // Animate the smile width based on current step
        final progress = (_currentStep + _smileController.value * 0.1) / _totalSteps;
        final smileWidth = 60.0 * progress;

        return Container(
          width: 70,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.3),
            ),
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background smile
                Icon(
                  Icons.sentiment_satisfied,
                  size: 30,
                  color: theme.colorScheme.primary.withOpacity(0.2),
                ),
                // Growing colored smile
                ClipRect(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress,
                    child: Icon(
                      Icons.sentiment_satisfied,
                      size: 30,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuestionCard(
    BuildContext context,
    int index,
    ThemeData theme,
    double screenHeight,
  ) {
    final question = _questions[index];
    final isPasswordField = index == 2;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.06),
            // Chat bubble from Remi
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RemiAvatar(
                      state: RemiAvatarState.thinking,
                      size: 32,
                      autoAnimate: false,
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        question['question']!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1F3A3A),
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: const Duration(milliseconds: 400))
                  .slideX(
                    begin: -0.3,
                    end: 0,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                  ),
            ),
            SizedBox(height: screenHeight * 0.06),
            // Input field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _controllers[index],
                  obscureText: isPasswordField,
                  enabled: true,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) => _nextQuestion(),
                  decoration: InputDecoration(
                    hintText: question['placeholder'],
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade400,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    prefixIcon: _getIconForQuestion(index),
                  ),
                )
                    .animate()
                    .fadeIn(
                      delay: const Duration(milliseconds: 200),
                      duration: const Duration(milliseconds: 400),
                    )
                    .slideY(
                      begin: 0.3,
                      end: 0,
                      delay: const Duration(milliseconds: 200),
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                    ),
                const SizedBox(height: 8),
                Text(
                  question['hint']!,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.grey.shade500,
                  ),
                )
                    .animate()
                    .fadeIn(
                      delay: const Duration(milliseconds: 300),
                      duration: const Duration(milliseconds: 400),
                    ),
              ],
            ),
            SizedBox(height: screenHeight * 0.08),
            // Next/Continue button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7DD3C0),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Text(
                  _currentStep == _totalSteps - 1 ? 'Create Account' : 'Next',
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
                    duration: const Duration(milliseconds: 400),
                  )
                  .slideY(
                    begin: 0.3,
                    end: 0,
                    delay: const Duration(milliseconds: 400),
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _getIconForQuestion(int index) {
    switch (index) {
      case 0:
        return Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Icon(Icons.person_outline, color: Colors.grey.shade400),
        );
      case 1:
        return Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Icon(Icons.email_outlined, color: Colors.grey.shade400),
        );
      case 2:
        return Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Icon(Icons.lock_outline, color: Colors.grey.shade400),
        );
      default:
        return null;
    }
  }
}
