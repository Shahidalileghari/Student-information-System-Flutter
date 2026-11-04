import 'package:flutter/material.dart';
class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key, required this.label, required this.value, required this.icon});
  final String label, value;
  final IconData icon;
  @override Widget build(BuildContext context) => Card(child: Padding(
    padding: const EdgeInsets.all(14), child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Icon(icon, color: Theme.of(context).colorScheme.primary),
        Text(value, style: Theme.of(context).textTheme.headlineMedium), Text(label)],
    )));
}
