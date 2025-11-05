import 'package:flutter/material.dart';

class CommunityInsights extends StatelessWidget {
  final Map<String, dynamic>? insights;
  const CommunityInsights({super.key, required this.insights});

  @override
  Widget build(BuildContext context) {
    if (insights == null) return const SizedBox.shrink();
    final tags = (insights!['top_interests'] as List? ?? []).cast<String>();
    final avg = insights!['avg_age'] ?? '-';
    final gender = insights!['gender_ratio'] ?? {};
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Text('Community Insights', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Row(children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Avg age: $avg'), const SizedBox(height: 6), Text('Gender: ${gender['M'] ?? 0}% M • ${gender['F'] ?? 0}% F'), const SizedBox(height: 6), Text('${insights!['crowd_summary'] ?? ''}'),]),])),
      const SizedBox(height: 8),
      if (tags.isNotEmpty) Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Wrap(spacing: 8, children: tags.map((t) => Chip(label: Text(t))).toList())),
      const SizedBox(height: 12),
    ]);
  }
}
