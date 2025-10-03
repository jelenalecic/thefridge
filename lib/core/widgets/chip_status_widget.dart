import 'package:flutter/material.dart';
import 'package:thefridge/core/widgets/chip_widget.dart';
import 'package:thefridge/features/fridge/domain/models/expiry_status.dart';

class ChipStatusWidget extends StatelessWidget {
  const ChipStatusWidget({super.key, required this.status});

  final ExpiryStatus status;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    switch (status) {
      case ExpiryStatus.expired:
        return ChipWidget(
          label: 'Expired',
          bg: cs.errorContainer,
          fg: cs.onErrorContainer,
        );
      case ExpiryStatus.soon:
        return ChipWidget(
          label: 'Soon',
          bg: cs.tertiaryContainer,
          fg: cs.onTertiaryContainer,
        );
      case ExpiryStatus.fresh:
        return ChipWidget(
          label: 'Fresh',
          bg: cs.secondaryContainer,
          fg: cs.onSecondaryContainer,
        );
      case ExpiryStatus.none:
        return const SizedBox.shrink();
    }
  }
}
