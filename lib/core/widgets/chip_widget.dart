import 'package:flutter/material.dart';

class ChipWidget extends StatelessWidget {
  const ChipWidget({super.key, required this.label, this.bg, this.fg});

  final String label;
  final Color? bg;
  final Color? fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg ?? Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: fg ?? Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
