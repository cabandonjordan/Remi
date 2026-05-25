import 'package:flutter/material.dart';

class RecoveryTimelineScreen extends StatelessWidget {
  const RecoveryTimelineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final milestones = [
      {
        'date': 'May 24',
        'title': 'First scan of your cut',
        'description': 'Initial assessment complete',
        'icon': Icons.photo_camera,
        'color': Colors.blue,
      },
      {
        'date': 'May 25',
        'title': 'You reported feeling better',
        'description': 'Pain level reduced by 30%',
        'icon': Icons.sentiment_satisfied,
        'color': Colors.green,
      },
      {
        'date': 'May 26',
        'title': 'You completed breathing exercise',
        'description': '3-minute guided session',
        'icon': Icons.air,
        'color': Colors.purple,
      },
      {
        'date': 'May 27',
        'title': 'Wound healing progressing well',
        'description': 'Redness decreased by 15%',
        'icon': Icons.healing,
        'color': Colors.teal,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Your Recovery Journey',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                children: [
                  // Header Stats
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.teal.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recovery Progress',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal.shade900,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatCard('Days Tracked', '4', Colors.blue),
                            _buildStatCard('Check-ins', '8', Colors.green),
                            _buildStatCard('Progress', '85%', Colors.orange),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Timeline
                  Column(
                    children: List.generate(milestones.length, (index) {
                      final milestone = milestones[index];
                      final isLast = index == milestones.length - 1;

                      return Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Timeline dot and line
                              Column(
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          milestone['color'] as Color,
                                          (milestone['color'] as Color)
                                              .withOpacity(0.6),
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              (milestone['color'] as Color)
                                                  .withOpacity(0.3),
                                          blurRadius: 12,
                                          spreadRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Icon(
                                        milestone['icon'] as IconData,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                  if (!isLast)
                                    Container(
                                      width: 3,
                                      height: 60,
                                      margin: const EdgeInsets.only(top: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 24),

                              // Milestone card
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  margin: const EdgeInsets.only(top: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade100,
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        milestone['date'] as String,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: (milestone['color']
                                              as Color),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        milestone['title'] as String,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2D3E3F),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        milestone['description'] as String,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // Export Button (Fixed at bottom)
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Doctor\'s report exported as PDF'),
                        duration: Duration(seconds: 2),
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
                    'Export Doctor\'s Report',
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
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
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
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
