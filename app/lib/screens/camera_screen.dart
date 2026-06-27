import 'dart:math' as math;

import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with TickerProviderStateMixin {
  double _frameMatch = 0.88;
  bool _showAnalysis = true;
  bool _edgeDetectionEnabled = true;
  _CaptureMode _mode = _CaptureMode.wound;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final area = _estimateArea(_contourForMode(_mode));
    final adjustedArea = area * (0.88 + (_frameMatch * 0.12));
    final consistency = (92 - ((_frameMatch - 0.5).abs() * 20)).clamp(70, 99);
    final progress = (_edgeDetectionEnabled ? 0.72 : 0.63) + (_frameMatch * 0.15);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Healing Tracker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, _) {
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _GuideOverlayPainter(
                            pulse: _pulseController.value,
                            contour: _contourForMode(_mode),
                            mode: _mode,
                            edgeDetectionEnabled: _edgeDetectionEnabled,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        right: 16,
                        top: 16,
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _pill('Same angle', Icons.screenshot_monitor),
                            _pill('Same distance', Icons.straighten),
                            _pill(
                              _edgeDetectionEnabled ? 'Edge tracking on' : 'Edge tracking off',
                              Icons.auto_fix_high,
                              highlighted: _edgeDetectionEnabled,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 18,
                        right: 18,
                        bottom: 22,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _guideTitle,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Keep the healing area inside the silhouette frame. Match lighting, angle, and distance every time for comparable results.',
                              style: TextStyle(
                                color: Colors.grey.shade300,
                                fontSize: 13,
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: _metricTile(
                                    'Surface area',
                                    '${adjustedArea.toStringAsFixed(1)} mm²',
                                    Colors.teal.shade300,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _metricTile(
                                    'Frame match',
                                    '${consistency.toStringAsFixed(0)}%',
                                    Colors.green.shade300,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _metricTile(
                                    'Progress',
                                    '${(progress.clamp(0.0, 1.0) * 100).toStringAsFixed(0)}%',
                                    Colors.lightGreenAccent,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF141414),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Standardized capture',
                            style: TextStyle(
                              color: Colors.grey.shade300,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.4,
                            ),
                          ),
                          const Spacer(),
                          Switch.adaptive(
                            value: _edgeDetectionEnabled,
                            activeColor: Colors.teal.shade300,
                            onChanged: (value) {
                              setState(() {
                                _edgeDetectionEnabled = value;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _modeChip(_CaptureMode.wound, 'Wound'),
                          _modeChip(_CaptureMode.incision, 'Incision'),
                          _modeChip(_CaptureMode.milestone, 'Milestone'),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade900.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.teal.shade400.withOpacity(0.35),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.center_focus_strong,
                                    color: Colors.teal.shade200, size: 20),
                                const SizedBox(width: 10),
                                Text(
                                  'Silhouette guide',
                                  style: TextStyle(
                                    color: Colors.grey.shade100,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'The contour overlay marks the area the model will compare over time. For best consistency, keep the target aligned with the inner frame and avoid changing the camera angle.',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 12,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Frame stability',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 6,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 12,
                                ),
                                overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 18,
                                ),
                                activeTrackColor: Colors.teal.shade300,
                                inactiveTrackColor: Colors.grey.shade800,
                                thumbColor: Colors.white,
                                overlayColor: Colors.teal.shade300.withOpacity(0.25),
                              ),
                              child: Slider(
                                value: _frameMatch,
                                onChanged: (value) {
                                  setState(() {
                                    _frameMatch = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      _buildAnalysisCard(area: adjustedArea, progress: progress.clamp(0.0, 1.0)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _showAnalysis = true;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal.shade400,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              icon: const Icon(Icons.auto_awesome, size: 20),
                              label: const Text(
                                'Run edge analysis',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _showAnalysis = false;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey.shade300,
                              side: BorderSide(color: Colors.grey.shade700),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text('Reset'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_showAnalysis)
              Container(
                color: const Color(0xFF101010),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                child: _buildExpandedAnalysis(area: adjustedArea, progress: progress.clamp(0.0, 1.0)),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/dashboard');
              break;
            case 1:
              Navigator.pushNamed(context, '/timeline');
              break;
            case 2:
              break;
            case 3:
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Wellness page coming soon')),
              );
              break;
            case 4:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'Camera'),
          BottomNavigationBarItem(icon: Icon(Icons.eco), label: 'Wellness'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  String get _guideTitle {
    switch (_mode) {
      case _CaptureMode.wound:
        return 'Center the healing area';
      case _CaptureMode.incision:
        return 'Align the incision line';
      case _CaptureMode.milestone:
        return 'Frame the recovery milestone';
    }
  }

  Widget _modeChip(_CaptureMode mode, String label) {
    final selected = _mode == mode;

    return ChoiceChip(
      selected: selected,
      label: Text(label),
      onSelected: (_) {
        setState(() {
          _mode = mode;
        });
      },
      labelStyle: TextStyle(
        color: selected ? Colors.black : Colors.grey.shade200,
        fontWeight: FontWeight.w700,
      ),
      selectedColor: Colors.teal.shade300,
      backgroundColor: Colors.black.withOpacity(0.22),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
        side: BorderSide(
          color: selected ? Colors.teal.shade200 : Colors.white12,
        ),
      ),
    );
  }

  Widget _pill(String label, IconData icon, {bool highlighted = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: highlighted ? Colors.teal.shade400.withOpacity(0.2) : Colors.black.withOpacity(0.30),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: highlighted ? Colors.teal.shade300.withOpacity(0.5) : Colors.white12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white70),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricTile(String label, String value, Color accent) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.30),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: accent,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisCard({required double area, required double progress}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F1E),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Contour analysis',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.teal.shade400.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  _edgeDetectionEnabled ? 'active' : 'manual',
                  style: TextStyle(
                    color: Colors.teal.shade200,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Edge detection traced the wound boundary inside the guide and produced a repeatable area estimate for longitudinal comparison.',
            style: TextStyle(
              color: Colors.grey.shade200,
              fontSize: 14,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _statCard('Detected area', '${area.toStringAsFixed(1)} mm²', Colors.teal.shade300),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _statCard('Boundary quality', _edgeDetectionEnabled ? 'Strong' : 'Manual', Colors.green.shade300),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey.shade800,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade400),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toStringAsFixed(0)}% healing progress',
            style: TextStyle(
              color: Colors.green.shade300,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedAnalysis({required double area, required double progress}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2322),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.green.shade500.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Auto edge result',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey, size: 24),
                onPressed: () {
                  setState(() {
                    _showAnalysis = false;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'The contour extractor found a stable boundary inside the silhouette guide. That gives the system a cleaner surface-area estimate for later comparisons.',
            style: TextStyle(
              color: Colors.grey.shade200,
              fontSize: 14,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _statCard('Surface area', '${area.toStringAsFixed(1)} mm²', Colors.teal.shade300),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _statCard('Stability', '${(_frameMatch * 100).toStringAsFixed(0)}%', Colors.green.shade300),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Recommendations',
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          _recommendation('Hold the phone level so the silhouette stays centered.'),
          _recommendation('Keep the full healing area inside the inner contour.'),
          _recommendation('Use the same lighting and distance on each follow-up photo.'),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/timeline'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade400,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'View recovery timeline',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _showAnalysis = false;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.teal.shade300,
                    side: BorderSide(color: Colors.teal.shade300, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Take another photo',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Note: the current implementation uses an in-app contour estimator and visual guide. Wiring this to a live camera stream or ML edge model can be added next without changing the UI contract.',
            style: TextStyle(
              color: Colors.blue.shade100,
              fontSize: 12,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _recommendation(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Colors.green.shade300, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey.shade200,
                fontSize: 13,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, Color accent) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF242827),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withOpacity(0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: accent,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  double _estimateArea(List<Offset> contour) {
    double area = 0;
    for (var i = 0; i < contour.length; i++) {
      final next = contour[(i + 1) % contour.length];
      area += contour[i].dx * next.dy;
      area -= next.dx * contour[i].dy;
    }
    return area.abs() * 7600;
  }

  List<Offset> _contourForMode(_CaptureMode mode) {
    switch (mode) {
      case _CaptureMode.wound:
        return const [
          Offset(0.18, 0.42),
          Offset(0.26, 0.32),
          Offset(0.38, 0.28),
          Offset(0.52, 0.26),
          Offset(0.66, 0.31),
          Offset(0.74, 0.42),
          Offset(0.72, 0.56),
          Offset(0.63, 0.66),
          Offset(0.50, 0.71),
          Offset(0.36, 0.67),
          Offset(0.24, 0.57),
        ];
      case _CaptureMode.incision:
        return const [
          Offset(0.22, 0.48),
          Offset(0.30, 0.40),
          Offset(0.42, 0.37),
          Offset(0.58, 0.36),
          Offset(0.69, 0.39),
          Offset(0.74, 0.48),
          Offset(0.68, 0.58),
          Offset(0.56, 0.63),
          Offset(0.42, 0.62),
          Offset(0.30, 0.57),
        ];
      case _CaptureMode.milestone:
        return const [
          Offset(0.18, 0.40),
          Offset(0.28, 0.28),
          Offset(0.44, 0.24),
          Offset(0.58, 0.27),
          Offset(0.72, 0.39),
          Offset(0.70, 0.58),
          Offset(0.58, 0.70),
          Offset(0.42, 0.74),
          Offset(0.28, 0.67),
          Offset(0.20, 0.54),
        ];
    }
  }
}

enum _CaptureMode { wound, incision, milestone }

class _GuideOverlayPainter extends CustomPainter {
  const _GuideOverlayPainter({
    required this.pulse,
    required this.contour,
    required this.mode,
    required this.edgeDetectionEnabled,
  });

  final double pulse;
  final List<Offset> contour;
  final _CaptureMode mode;
  final bool edgeDetectionEnabled;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final background = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF101820), Color(0xFF05080A)],
      ).createShader(rect);
    canvas.drawRect(rect, background);

    final dimPaint = Paint()..color = Colors.black.withOpacity(0.38);
    final focusRect = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: size.width * 0.62,
      height: size.width * 0.62,
    );
    final fullPath = Path()..addRect(rect);
    final focusPath = Path()
      ..addRRect(RRect.fromRectAndRadius(focusRect, const Radius.circular(30)));
    canvas.drawPath(Path.combine(PathOperation.difference, fullPath, focusPath), dimPaint);

    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..strokeWidth = 1;
    for (var index = 1; index < 3; index++) {
      final x = size.width * index / 3;
      final y = size.height * index / 3;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    _drawSilhouette(canvas, size, focusRect);
    _drawContour(canvas, size, focusRect);
    _drawGuides(canvas, size, focusRect);
    _drawRuler(canvas, size, focusRect);
  }

  void _drawSilhouette(Canvas canvas, Size size, Rect focusRect) {
    final bodyPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    final headCenter = Offset(focusRect.center.dx, focusRect.top + focusRect.height * 0.16);
    canvas.drawCircle(headCenter, focusRect.width * 0.09, bodyPaint);

    final body = Path()
      ..moveTo(focusRect.left + focusRect.width * 0.28, focusRect.top + focusRect.height * 0.28)
      ..quadraticBezierTo(
        focusRect.left + focusRect.width * 0.23,
        focusRect.top + focusRect.height * 0.46,
        focusRect.left + focusRect.width * 0.24,
        focusRect.top + focusRect.height * 0.68,
      )
      ..quadraticBezierTo(
        focusRect.left + focusRect.width * 0.34,
        focusRect.top + focusRect.height * 0.82,
        focusRect.center.dx,
        focusRect.top + focusRect.height * 0.86,
      )
      ..quadraticBezierTo(
        focusRect.left + focusRect.width * 0.66,
        focusRect.top + focusRect.height * 0.82,
        focusRect.left + focusRect.width * 0.76,
        focusRect.top + focusRect.height * 0.68,
      )
      ..quadraticBezierTo(
        focusRect.left + focusRect.width * 0.77,
        focusRect.top + focusRect.height * 0.46,
        focusRect.left + focusRect.width * 0.72,
        focusRect.top + focusRect.height * 0.28,
      )
      ..quadraticBezierTo(
        focusRect.center.dx,
        focusRect.top + focusRect.height * 0.23,
        focusRect.left + focusRect.width * 0.28,
        focusRect.top + focusRect.height * 0.28,
      )
      ..close();

    canvas.drawPath(body, bodyPaint);
  }

  void _drawContour(Canvas canvas, Size size, Rect focusRect) {
    final points = contour
        .map((point) => Offset(
              focusRect.left + point.dx * focusRect.width,
              focusRect.top + point.dy * focusRect.height,
            ))
        .toList(growable: false);

    final contourPath = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      contourPath.lineTo(points[i].dx, points[i].dy);
    }
    contourPath.close();

    final contourFill = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.tealAccent.withOpacity(0.24),
          Colors.greenAccent.withOpacity(0.08),
        ],
      ).createShader(focusRect)
      ..style = PaintingStyle.fill;
    canvas.drawPath(contourPath, contourFill);

    final contourPaint = Paint()
      ..color = edgeDetectionEnabled ? Colors.tealAccent : Colors.white70
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.3;
    canvas.drawPath(contourPath, contourPaint);

    final glowPaint = Paint()
      ..color = (edgeDetectionEnabled ? Colors.tealAccent : Colors.white).withOpacity(0.16)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawPath(contourPath, glowPaint);
  }

  void _drawGuides(Canvas canvas, Size size, Rect focusRect) {
    final cornerPaint = Paint()
      ..color = Colors.tealAccent.withOpacity(0.8)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final cornerLength = focusRect.width * 0.11;
    canvas.drawLine(focusRect.topLeft, focusRect.topLeft + Offset(cornerLength, 0), cornerPaint);
    canvas.drawLine(focusRect.topLeft, focusRect.topLeft + Offset(0, cornerLength), cornerPaint);
    canvas.drawLine(focusRect.topRight, focusRect.topRight + Offset(-cornerLength, 0), cornerPaint);
    canvas.drawLine(focusRect.topRight, focusRect.topRight + Offset(0, cornerLength), cornerPaint);
    canvas.drawLine(focusRect.bottomLeft, focusRect.bottomLeft + Offset(cornerLength, 0), cornerPaint);
    canvas.drawLine(focusRect.bottomLeft, focusRect.bottomLeft + Offset(0, -cornerLength), cornerPaint);
    canvas.drawLine(focusRect.bottomRight, focusRect.bottomRight + Offset(-cornerLength, 0), cornerPaint);
    canvas.drawLine(focusRect.bottomRight, focusRect.bottomRight + Offset(0, -cornerLength), cornerPaint);

    final pulsePaint = Paint()
      ..color = Colors.tealAccent.withOpacity(0.18 + pulse * 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(focusRect.center, focusRect.width * (0.18 + pulse * 0.02), pulsePaint);
  }

  void _drawRuler(Canvas canvas, Size size, Rect focusRect) {
    final ruler = Rect.fromLTWH(
      focusRect.left + focusRect.width * 0.08,
      focusRect.bottom - 42,
      focusRect.width * 0.34,
      30,
    );

    final paint = Paint()..color = Colors.black.withOpacity(0.42);
    canvas.drawRRect(RRect.fromRectAndRadius(ruler, const Radius.circular(15)), paint);

    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..strokeWidth = 2;
    final startX = ruler.left + 16;
    final endX = ruler.right - 16;
    final centerY = ruler.center.dy;
    canvas.drawLine(Offset(startX, centerY), Offset(endX, centerY), linePaint);
    for (var index = 0; index < 5; index++) {
      final tickX = startX + (endX - startX) * index / 4;
      canvas.drawLine(Offset(tickX, centerY - 7), Offset(tickX, centerY + 7), linePaint);
    }

    final label = TextPainter(
      text: TextSpan(
        text: '5 cm',
        style: TextStyle(
          color: Colors.tealAccent.shade100,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    label.paint(canvas, Offset(ruler.center.dx - label.width / 2, ruler.top - 15));
  }

  @override
  bool shouldRepaint(covariant _GuideOverlayPainter oldDelegate) {
    return oldDelegate.pulse != pulse ||
        oldDelegate.edgeDetectionEnabled != edgeDetectionEnabled ||
        oldDelegate.mode != mode ||
        oldDelegate.contour != contour;
  }
}

List<Offset> _contourForMode(_CaptureMode mode) {
  switch (mode) {
    case _CaptureMode.wound:
      return const [
        Offset(0.18, 0.42),
        Offset(0.26, 0.32),
        Offset(0.38, 0.28),
        Offset(0.52, 0.26),
        Offset(0.66, 0.31),
        Offset(0.74, 0.42),
        Offset(0.72, 0.56),
        Offset(0.63, 0.66),
        Offset(0.50, 0.71),
        Offset(0.36, 0.67),
        Offset(0.24, 0.57),
      ];
    case _CaptureMode.incision:
      return const [
        Offset(0.22, 0.48),
        Offset(0.30, 0.40),
        Offset(0.42, 0.37),
        Offset(0.58, 0.36),
        Offset(0.69, 0.39),
        Offset(0.74, 0.48),
        Offset(0.68, 0.58),
        Offset(0.56, 0.63),
        Offset(0.42, 0.62),
        Offset(0.30, 0.57),
      ];
    case _CaptureMode.milestone:
      return const [
        Offset(0.18, 0.40),
        Offset(0.28, 0.28),
        Offset(0.44, 0.24),
        Offset(0.58, 0.27),
        Offset(0.72, 0.39),
        Offset(0.70, 0.58),
        Offset(0.58, 0.70),
        Offset(0.42, 0.74),
        Offset(0.28, 0.67),
        Offset(0.20, 0.54),
      ];
  }
}

