import 'package:flutter/material.dart';
import 'package:app/widgets/remi_avatar.dart';

enum _TimelineSignalType { image, pain, temperature, swelling, note }

class RecoveryTimelineScreen extends StatefulWidget {
  const RecoveryTimelineScreen({Key? key}) : super(key: key);

  @override
  State<RecoveryTimelineScreen> createState() => _RecoveryTimelineScreenState();
}

class _RecoveryTimelineScreenState extends State<RecoveryTimelineScreen> {
  int _selectedIndex = 1;
  _TimelineEntry? _selectedEntry;

  late final List<_TimelineEntry> _entries = [
    _TimelineEntry(
      dateLabel: 'May 24',
      dayLabel: 'Day 1',
      title: 'Baseline capture established',
      summary:
          'Initial wound image, pain score, and local swelling note were recorded as the reference point for future comparisons.',
      signalType: _TimelineSignalType.image,
      imageSummary: 'Wound color normal, boundary clear, no drainage visible.',
      painScore: 4,
      temperatureC: 36.7,
      swellingScore: 2,
      woundColor: 'normal',
      trendLabel: 'Baseline',
      color: Colors.blue,
      accent: const Color(0xFF4F87C8),
      recommendation:
          'Keep using the same lighting and camera distance so tomorrow\'s scan stays comparable.',
    ),
    _TimelineEntry(
      dateLabel: 'May 25',
      dayLabel: 'Day 2',
      title: 'Pain improvement with steady visuals',
      summary:
          'The visual scan remained stable while the pain score dropped and swelling began to ease.',
      signalType: _TimelineSignalType.pain,
      imageSummary: 'Wound tone slightly lighter, edges still regular.',
      painScore: 3,
      temperatureC: 36.6,
      swellingScore: 2,
      woundColor: 'normal',
      trendLabel: 'Improving',
      color: Colors.green,
      accent: const Color(0xFF57A773),
      recommendation:
          'Recovery is moving in the right direction. Continue keeping the wound protected and dry.',
    ),
    _TimelineEntry(
      dateLabel: 'May 26',
      dayLabel: 'Day 3',
      title: 'Activity-related pain spike detected',
      summary:
          'The wound image still looks structurally stable, but pain increased sharply for 48 hours, which is a non-linear pattern worth flagging.',
      signalType: _TimelineSignalType.note,
      imageSummary: 'Color remains normal, but tenderness appears increased.',
      painScore: 7,
      temperatureC: 36.8,
      swellingScore: 3,
      woundColor: 'normal',
      trendLabel: 'Anomaly',
      color: Colors.orange,
      accent: const Color(0xFFD98B3A),
      recommendation:
          'Sharp pain increase with a normal-looking wound can mean irritation, tension, or early complication. Consider a check-in.',
      warning: true,
    ),
    _TimelineEntry(
      dateLabel: 'May 27',
      dayLabel: 'Day 4',
      title: 'Swelling trend is easing again',
      summary:
          'Temperature and swelling returned closer to baseline and the AI thread resolved the prior anomaly as a short-lived spike.',
      signalType: _TimelineSignalType.swelling,
      imageSummary: 'Edges remain tidy, redness unchanged from yesterday.',
      painScore: 5,
      temperatureC: 36.5,
      swellingScore: 2,
      woundColor: 'normal',
      trendLabel: 'Recovering',
      color: Colors.teal,
      accent: const Color(0xFF2B9A92),
      recommendation:
          'Keep monitoring pain against the image trend. If the spike repeats, escalate for a clinician review.',
    ),
    _TimelineEntry(
      dateLabel: 'May 28',
      dayLabel: 'Day 5',
      title: 'Unified thread confirms gradual healing',
      summary:
          'The multi-modal thread now shows stable wound color, lower swelling, and a more predictable pain trajectory.',
      signalType: _TimelineSignalType.image,
      imageSummary: 'Wound border cleaner and overall appearance more settled.',
      painScore: 4,
      temperatureC: 36.5,
      swellingScore: 1,
      woundColor: 'normal',
      trendLabel: 'Stable',
      color: Colors.green,
      accent: const Color(0xFF56B37A),
      recommendation:
          'The recovery pattern looks coherent again. Maintain the same logging routine to preserve continuity.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedEntry = _entries[2];
  }

  @override
  Widget build(BuildContext context) {
    final selectedEntry = _selectedEntry ?? _entries.first;
    final aggregate = _buildAggregateInsights(_entries);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F0),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Recovery Timeline',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Unified timeline exported as a clinical summary.'),
                ),
              );
            },
            icon: const Icon(Icons.ios_share),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderCard(aggregate),
                  const SizedBox(height: 18),
                  _buildUnifiedThreadCard(selectedEntry, aggregate),
                  const SizedBox(height: 18),
                  _sectionTitle(
                    'Chronological multi-modal thread',
                    'Images, pain scores, temperature, swelling, and notes are analyzed together instead of in isolation.',
                  ),
                  const SizedBox(height: 14),
                  ..._entries.map((entry) {
                    final isSelected = entry == _selectedEntry;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _TimelineCard(
                        entry: entry,
                        selected: isSelected,
                        onTap: () {
                          setState(() {
                            _selectedEntry = entry;
                          });
                        },
                      ),
                    );
                  }),
                  const SizedBox(height: 10),
                  _buildPatternPanel(aggregate),
                ],
              ),
            ),
          ),
          _buildBottomActions(context),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/dashboard');
              break;
            case 1:
              break;
            case 2:
              Navigator.pushNamed(context, '/camera');
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
          BottomNavigationBarItem(icon: Icon(Icons.timeline), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'Camera'),
          BottomNavigationBarItem(icon: Icon(Icons.eco), label: 'Wellness'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(_AggregateInsights aggregate) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.teal.shade700,
            Colors.teal.shade500,
            const Color(0xFF2F8F72),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.22),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.analytics_outlined, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Unified recovery thread',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Remi now reads the timeline as one chronological dataset, linking image changes with pain, temperature, and swelling so it can catch recovery patterns that would be missed by a single log.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: _statCard('Days', '${aggregate.daysTracked}', Colors.white)),
              const SizedBox(width: 10),
              Expanded(child: _statCard('Signals', '${aggregate.signalsTracked}', Colors.white)),
              const SizedBox(width: 10),
              Expanded(child: _statCard('Flags', '${aggregate.flagsDetected}', Colors.white)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUnifiedThreadCard(_TimelineEntry entry, _AggregateInsights aggregate) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200.withOpacity(0.8),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: entry.accent.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(entry.icon, color: entry.accent, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected checkpoint: ${entry.dayLabel}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: entry.accent,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      entry.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF243233),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            entry.summary,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _detailChip(
                  label: 'Pain',
                  value: '${entry.painScore}/10',
                  accent: entry.painScore >= 6 ? Colors.orange : Colors.green,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _detailChip(
                  label: 'Temp',
                  value: '${entry.temperatureC.toStringAsFixed(1)}°C',
                  accent: entry.temperatureC >= 37.2 ? Colors.orange : Colors.teal,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _detailChip(
                  label: 'Swelling',
                  value: '${entry.swellingScore}/5',
                  accent: entry.swellingScore >= 3 ? Colors.orange : Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: entry.warning
                  ? Colors.orange.shade50
                  : Colors.teal.shade50,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: entry.warning
                    ? Colors.orange.shade200
                    : Colors.teal.shade200,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      entry.warning ? Icons.warning_amber : Icons.check_circle,
                      color: entry.warning ? Colors.orange.shade700 : Colors.teal.shade700,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        entry.warning
                            ? 'Non-linear recovery pattern detected'
                            : 'Thread analysis remains coherent',
                        style: TextStyle(
                          color: entry.warning ? Colors.orange.shade900 : Colors.teal.shade900,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  entry.warning
                      ? 'Wound color stayed normal while pain climbed for 48 hours. That mismatch is a useful checkup signal because symptoms are diverging from the visual trend.'
                      : 'The visual trend and symptom trend are moving in the same direction, which is what we want in a stable recovery thread.',
                  style: TextStyle(
                    color: entry.warning ? Colors.orange.shade900 : Colors.teal.shade900,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'AI recommendation',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            entry.recommendation,
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          LinearProgressIndicator(
            value: aggregate.overallProgress,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(entry.accent),
          ),
          const SizedBox(height: 8),
          Text(
            '${(aggregate.overallProgress * 100).round()}% of the recovery thread appears stable',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatternPanel(_AggregateInsights aggregate) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF6FBF9),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.teal.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_graph, color: Colors.teal.shade700),
              const SizedBox(width: 10),
              const Text(
                'Non-linear pattern detection',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF274343),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'The AI evaluates the timeline as one connected thread and looks for mismatches across image, pain, temperature, and swelling trends.',
            style: TextStyle(
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          ...aggregate.flags.map(
            (flag) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.priority_high, color: Colors.orange.shade700, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      flag,
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 13,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _statCard(
                  'Mixed signals',
                  '${aggregate.mixedSignals}',
                  Colors.orange.shade700,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _statCard(
                  'Checkup risk',
                  aggregate.checkupRiskLabel,
                  Colors.teal.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Doctor\'s report exported with multimodal timeline data'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal.shade400,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(Icons.download),
            label: const Text(
              'Export doctor\'s report',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.teal.shade400,
              side: BorderSide(color: Colors.teal.shade400, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(Icons.arrow_back),
            label: const Text(
              'Back to Healing Tracker',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3E3F),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            height: 1.45,
          ),
        ),
      ],
    );
  }

  Widget _detailChip({
    required String label,
    required String value,
    required Color accent,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: accent,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.85),
          ),
        ),
      ],
    );
  }

  _AggregateInsights _buildAggregateInsights(List<_TimelineEntry> entries) {
    final painRange = entries.map((entry) => entry.painScore).reduce((a, b) => a > b ? a : b) -
        entries.map((entry) => entry.painScore).reduce((a, b) => a < b ? a : b);
    final temperatureSpike = entries.any((entry) => entry.temperatureC >= 37.0);
    final swellingTrend = entries.last.swellingScore <= entries.first.swellingScore;
    final flags = <String>[];

    final anomalyEntry = entries.firstWhere((entry) => entry.warning, orElse: () => entries[0]);
    flags.add(
      '${anomalyEntry.dateLabel}: wound color stayed ${anomalyEntry.woundColor} while pain increased to ${anomalyEntry.painScore}/10 over 48 hours.',
    );
    if (temperatureSpike) {
      flags.add('At least one check-in crossed the mild temperature threshold, which can be useful when paired with swelling history.');
    }
    if (painRange >= 3) {
      flags.add('Pain is moving more than the visuals alone suggest, so the symptom curve should remain part of the review.');
    }

    final mixedSignals = 1 + (temperatureSpike ? 1 : 0) + (painRange >= 3 ? 1 : 0);
    final checkupRisk = anomalyEntry.warning || !swellingTrend ? 'Moderate' : 'Low';

    return _AggregateInsights(
      daysTracked: entries.length,
      signalsTracked: entries.length * 4,
      flagsDetected: flags.length,
      mixedSignals: mixedSignals,
      checkupRiskLabel: checkupRisk,
      overallProgress: swellingTrend ? 0.82 : 0.72,
      flags: flags,
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({
    required this.entry,
    required this.selected,
    required this.onTap,
  });

  final _TimelineEntry entry;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.white.withOpacity(0.92),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? entry.accent : Colors.grey.shade200,
              width: selected ? 1.8 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200.withOpacity(0.8),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          entry.accent,
                          entry.accent.withOpacity(0.65),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: entry.accent.withOpacity(0.25),
                          blurRadius: 12,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Icon(entry.icon, color: Colors.white, size: 26),
                  ),
                  if (!selected)
                    Container(
                      width: 3,
                      height: 46,
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          entry.dateLabel,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: entry.accent,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: entry.warning
                                ? Colors.orange.shade50
                                : Colors.teal.shade50,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            entry.trendLabel,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: entry.warning ? Colors.orange.shade800 : Colors.teal.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      entry.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3E3F),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      entry.summary,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _miniMetric(Icons.favorite_border, '${entry.painScore}/10 pain', entry.painScore >= 6 ? Colors.orange : Colors.green),
                        _miniMetric(Icons.thermostat, '${entry.temperatureC.toStringAsFixed(1)}°C', entry.temperatureC >= 37.2 ? Colors.orange : Colors.teal),
                        _miniMetric(Icons.water_drop_outlined, 'Swelling ${entry.swellingScore}/5', entry.swellingScore >= 3 ? Colors.orange : Colors.blue),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      entry.imageSummary,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _miniMetric(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineEntry {
  const _TimelineEntry({
    required this.dateLabel,
    required this.dayLabel,
    required this.title,
    required this.summary,
    required this.signalType,
    required this.imageSummary,
    required this.painScore,
    required this.temperatureC,
    required this.swellingScore,
    required this.woundColor,
    required this.trendLabel,
    required this.color,
    required this.accent,
    required this.recommendation,
    this.warning = false,
  });

  final String dateLabel;
  final String dayLabel;
  final String title;
  final String summary;
  final _TimelineSignalType signalType;
  final String imageSummary;
  final int painScore;
  final double temperatureC;
  final int swellingScore;
  final String woundColor;
  final String trendLabel;
  final Color color;
  final Color accent;
  final String recommendation;
  final bool warning;

  IconData get icon {
    switch (signalType) {
      case _TimelineSignalType.image:
        return Icons.photo_camera;
      case _TimelineSignalType.pain:
        return Icons.healing;
      case _TimelineSignalType.temperature:
        return Icons.thermostat;
      case _TimelineSignalType.swelling:
        return Icons.water_drop_outlined;
      case _TimelineSignalType.note:
        return Icons.notes;
    }
  }
}

class _AggregateInsights {
  const _AggregateInsights({
    required this.daysTracked,
    required this.signalsTracked,
    required this.flagsDetected,
    required this.mixedSignals,
    required this.checkupRiskLabel,
    required this.overallProgress,
    required this.flags,
  });

  final int daysTracked;
  final int signalsTracked;
  final int flagsDetected;
  final int mixedSignals;
  final String checkupRiskLabel;
  final double overallProgress;
  final List<String> flags;
}

class _ThreadLinePainter extends CustomPainter {
  const _ThreadLinePainter();

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
