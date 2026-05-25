import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with TickerProviderStateMixin {
  double _sliderValue = 0.5;
  bool _showAnalysis = false;
  late AnimationController _pulseController;
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('Healing Tracker',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Animated Camera Viewfinder
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  color: Colors.grey.shade900,
                  child: Center(
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                // Animated glowing corner brackets
                Positioned.fill(
                  child: Center(
                    child: SizedBox(
                      width: 280,
                      height: 280,
                      child: Stack(
                        children: [
                          Positioned(
                              top: 0,
                              left: 0,
                              child: _buildAnimatedBracket(topLeft: true)),
                          Positioned(
                              top: 0,
                              right: 0,
                              child: _buildAnimatedBracket(topRight: true)),
                          Positioned(
                              bottom: 0,
                              left: 0,
                              child: _buildAnimatedBracket(bottomLeft: true)),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: _buildAnimatedBracket(bottomRight: true)),
                        ],
                      ),
                    ),
                  ),
                ),
                // Pulsing center guide
                ScaleTransition(
                  scale: Tween(begin: 0.8, end: 1.2).animate(
                    CurvedAnimation(
                        parent: _pulseController, curve: Curves.easeInOut),
                  ),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.teal.shade200, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 80,
                  child: Column(
                    children: [
                      Text(
                        'Center your injury',
                        style: TextStyle(
                          color: Colors.teal.shade200,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Icon(Icons.arrow_downward,
                          color: Colors.teal.shade200, size: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Interactive Comparison with Slider
          Container(
            color: const Color(0xFF1A1A1A),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Compare Your Progress',
                  style: TextStyle(
                    color: Colors.grey.shade300,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 20),
                // Enhanced split-screen comparison
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: MouseRegion(
                    onHover: (_) => _scaleController.forward(),
                    onExit: (_) => _scaleController.reverse(),
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.teal.shade200, width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          // Yesterday
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.grey.shade700,
                                    Colors.grey.shade600,
                                  ],
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image_outlined,
                                      color: Colors.grey.shade400,
                                      size: 40),
                                  const SizedBox(height: 12),
                                  Text('Yesterday',
                                      style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      )),
                                  const SizedBox(height: 4),
                                  Text('May 26',
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 11,
                                      )),
                                ],
                              ),
                            ),
                          ),
                          // Divider with improvement
                          Container(
                            width: 4,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.teal.shade200,
                                  Colors.green.shade400,
                                ],
                              ),
                            ),
                            child: Center(
                              child: Icon(Icons.trending_up,
                                  color: Colors.white, size: 18),
                            ),
                          ),
                          // Today
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.teal.shade900.withOpacity(0.4),
                                    Colors.teal.shade800.withOpacity(0.3),
                                  ],
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  ScaleTransition(
                                    scale: _scaleController.drive(
                                        Tween(begin: 1.0, end: 1.1)),
                                    child: Icon(Icons.image_outlined,
                                        color: Colors.teal.shade300,
                                        size: 40),
                                  ),
                                  const SizedBox(height: 12),
                                  Text('Today',
                                      style: TextStyle(
                                        color: Colors.teal.shade200,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      )),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade900
                                          .withOpacity(0.5),
                                      borderRadius:
                                          BorderRadius.circular(8),
                                    ),
                                    child: Text('↑ 15% Better',
                                        style: TextStyle(
                                          color: Colors.green.shade300,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Interactive slider
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Drag to compare',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        )),
                    const SizedBox(height: 12),
                    SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 6,
                        thumbShape: RoundSliderThumbShape(
                            enabledThumbRadius: 14, elevation: 8),
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 20),
                        activeTrackColor: Colors.teal.shade300,
                        inactiveTrackColor: Colors.grey.shade700,
                        thumbColor: Colors.white,
                        overlayColor: Colors.teal.shade300.withOpacity(0.3),
                      ),
                      child: Slider(
                        value: _sliderValue,
                        onChanged: (value) =>
                            setState(() => _sliderValue = value),
                        divisions: 10,
                        label: _sliderValue < 0.5 ? 'Yesterday' : 'Today',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Analysis button
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        setState(() => _showAnalysis = true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade400,
                      foregroundColor: Colors.white,
                      elevation: 12,
                      shadowColor:
                          Colors.teal.shade400.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                    ),
                    icon: const Icon(Icons.auto_awesome, size: 22),
                    label: const Text('Get AI Analysis',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        )),
                  ),
                ),
              ],
            ),
          ),
          // Analysis Card
          if (_showAnalysis)
            Container(
              color: const Color(0xFF2A2A2A),
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('AI Analysis',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            )),
                        IconButton(
                          icon: const Icon(Icons.close,
                              color: Colors.grey, size: 24),
                          onPressed: () =>
                              setState(() => _showAnalysis = false),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.green.shade900.withOpacity(0.2),
                        border: Border.all(
                            color: Colors.green.shade600, width: 2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green.shade600
                                      .withOpacity(0.3),
                                ),
                                child: Icon(Icons.check_circle,
                                    color: Colors.green.shade400, size: 28),
                              ),
                              const SizedBox(width: 16),
                              const Text('Looking Great!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'The redness has decreased by 15% since yesterday. Your healing is progressing beautifully. Keep your current care routine and maintain the protective bandage.',
                            style: TextStyle(
                              color: Colors.grey.shade200,
                              fontSize: 15,
                              height: 1.7,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text('Healing Progress',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              )),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: 0.75,
                              minHeight: 8,
                              backgroundColor: Colors.grey.shade700,
                              valueColor: AlwaysStoppedAnimation(
                                  Colors.green.shade400),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('75% healed',
                              style: TextStyle(
                                color: Colors.green.shade300,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade900.withOpacity(0.2),
                        border: Border.all(
                            color: Colors.blue.shade600, width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: Colors.blue.shade300, size: 24),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              'Keep your bandage clean & dry. Next check-in: Tomorrow',
                              style: TextStyle(
                                color: Colors.blue.shade200,
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/timeline'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal.shade400,
                            foregroundColor: Colors.white,
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text('View Recovery Timeline',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: () =>
                              setState(() => _showAnalysis = false),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.teal.shade400,
                            side: BorderSide(
                                color: Colors.teal.shade400, width: 2),
                            padding:
                                const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text('Take Another Photo',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBracket({
    bool topLeft = false,
    bool topRight = false,
    bool bottomLeft = false,
    bool bottomRight = false,
  }) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: topLeft ? const Radius.circular(14) : Radius.zero,
          topRight: topRight ? const Radius.circular(14) : Radius.zero,
          bottomLeft: bottomLeft ? const Radius.circular(14) : Radius.zero,
          bottomRight: bottomRight ? const Radius.circular(14) : Radius.zero,
        ),
        border: Border(
          top: (topLeft || topRight)
              ? BorderSide(color: Colors.teal.shade200, width: 2.5)
              : BorderSide.none,
          left: (topLeft || bottomLeft)
              ? BorderSide(color: Colors.teal.shade200, width: 2.5)
              : BorderSide.none,
          bottom: (bottomLeft || bottomRight)
              ? BorderSide(color: Colors.teal.shade200, width: 2.5)
              : BorderSide.none,
          right: (topRight || bottomRight)
              ? BorderSide(color: Colors.teal.shade200, width: 2.5)
              : BorderSide.none,
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.teal.withOpacity(0.6),
              blurRadius: 16,
              spreadRadius: 3),
        ],
      ),
    );
  }
}
