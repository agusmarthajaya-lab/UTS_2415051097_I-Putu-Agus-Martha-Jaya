import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  final int totalCount;
  final int completedCount;
  final int pendingCount;
  final double completionRate;

  const StatsCard({
    super.key,
    required this.totalCount,
    required this.completedCount,
    required this.pendingCount,
    required this.completionRate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Statistik Progres Tugas',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${(completionRate * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: completionRate,
                minHeight: 10,
                backgroundColor: Colors.deepPurple.shade50,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    label: 'Total',
                    value: totalCount.toString(),
                    color: Colors.blue.shade700,
                    icon: Icons.assignment_outlined,
                  ),
                ),
                Container(height: 36, width: 1, color: Colors.grey.shade300),
                Expanded(
                  child: _buildStatItem(
                    label: 'Selesai',
                    value: completedCount.toString(),
                    color: Colors.green.shade700,
                    icon: Icons.check_circle_outline,
                  ),
                ),
                Container(height: 36, width: 1, color: Colors.grey.shade300),
                Expanded(
                  child: _buildStatItem(
                    label: 'Pending',
                    value: pendingCount.toString(),
                    color: Colors.orange.shade800,
                    icon: Icons.pending_actions_outlined,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
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
