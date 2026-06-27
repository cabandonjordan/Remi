import 'package:flutter/material.dart';

enum RemiAvatarState { waving, resting, happy, thinking, alert }

class RemiAvatar extends StatefulWidget {
  final RemiAvatarState state;
  final double size;
  final bool autoAnimate;

  const RemiAvatar({
    Key? key,
    this.state = RemiAvatarState.waving,
    this.size = 120,
    this.autoAnimate = true,
  }) : super(key: key);

  @override
  State<RemiAvatar> createState() => _RemiAvatarState();
}

class _RemiAvatarState extends State<RemiAvatar> with TickerProviderStateMixin {
  late AnimationController _wavingController;
  late AnimationController _floatingController;

  @override
  void initState() {
    super.initState();
    _wavingController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    if (widget.autoAnimate && widget.state == RemiAvatarState.waving) {
      _wavingController.repeat();
    }
  }

  @override
  void dispose() {
    _wavingController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(RemiAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      if (widget.state == RemiAvatarState.waving && widget.autoAnimate) {
        _wavingController.repeat();
      } else {
        _wavingController.stop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        double floatOffset = 0;
        if (widget.state != RemiAvatarState.waving) {
          floatOffset = _floatingController.value * 8 - 4;
        }

        return Transform.translate(
          offset: Offset(0, floatOffset),
          child: child,
        );
      },
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer glow
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
            // Main avatar body (soft abstract 3D shape)
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.9),
                    theme.colorScheme.primary.withOpacity(0.7),
                  ],
                ),
              ),
              child: Center(
                child: Container(
                  width: widget.size * 0.85,
                  height: widget.size * 0.85,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.4),
                        Colors.white.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Eyes
            Positioned(
              top: widget.size * 0.3,
              left: widget.size * 0.3,
              child: _buildEye(widget.size * 0.1, theme),
            ),
            Positioned(
              top: widget.size * 0.3,
              right: widget.size * 0.3,
              child: _buildEye(widget.size * 0.1, theme),
            ),
            // Waving hand (if state is waving)
            if (widget.state == RemiAvatarState.waving)
              Positioned(
                right: widget.size * 0.15,
                top: widget.size * 0.25,
                child: AnimatedBuilder(
                  animation: _wavingController,
                  builder: (context, child) {
                    final angle = (_wavingController.value - 0.5) * 0.8;
                    return Transform.rotate(
                      angle: angle,
                      origin: Offset(0, widget.size * 0.15),
                      child: child,
                    );
                  },
                  child: Icon(
                    Icons.waving_hand,
                    size: widget.size * 0.3,
                    color: Colors.white,
                  ),
                ),
              ),
            // Smile or expression based on state
            Positioned(
              bottom: widget.size * 0.25,
              child: _buildExpression(widget.size, theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEye(double size, ThemeData theme) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Center(
        child: Container(
          width: size * 0.5,
          height: size * 0.5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildExpression(double size, ThemeData theme) {
    switch (widget.state) {
      case RemiAvatarState.waving:
      case RemiAvatarState.happy:
        return Icon(
          Icons.sentiment_very_satisfied,
          size: size * 0.25,
          color: Colors.white,
        );
      case RemiAvatarState.thinking:
        return Icon(
          Icons.sentiment_satisfied,
          size: size * 0.25,
          color: Colors.white,
        );
      case RemiAvatarState.resting:
        return Icon(
          Icons.sentiment_neutral,
          size: size * 0.25,
          color: Colors.white,
        );
      case RemiAvatarState.alert:
        return Icon(
          Icons.warning_amber_rounded,
          size: size * 0.26,
          color: Colors.white,
        );
    }
  }
}
