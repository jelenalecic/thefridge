import 'package:flutter/material.dart';
import 'package:thefridge/core/coloring/colors.dart';
import 'package:thefridge/core/utils/date_time.dart';
import 'package:thefridge/core/widgets/chip_status_widget.dart';
import 'package:thefridge/core/widgets/chip_widget.dart';
import 'package:thefridge/features/fridge/domain/models/fridge_item.dart';
import 'package:thefridge/features/fridge/domain/models/fridge_category.dart';
import 'package:thefridge/features/fridge/domain/models/fridge_unit.dart';

class FridgeItemPreviewPage extends StatelessWidget {
  const FridgeItemPreviewPage({
    super.key,
    required this.item,
    required this.heroIcon,
    required this.heroColor,
  });

  final FridgeItem item;
  final String heroColor;
  final String heroIcon;

  @override
  Widget build(BuildContext context) {
    final status = item.bestBefore.expiryStatus;
    final iconData = item.category.icon;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Material(
            color: surface,
            elevation: 12,
            borderRadius: BorderRadius.circular(16),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Hero(
                  tag: heroColor,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: item.getColor(),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Hero(
                            tag: heroIcon,
                            child: Icon(iconData, color: primaryText, size: 40),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              item.name,
                              style: TextStyle(
                                color: primaryText,
                                fontSize: 30,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).maybePop(),
                            icon: Icon(Icons.close, color: primaryText),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ChipWidget(label: item.category.name),
                          ChipWidget(
                            label: '${item.quantity} ${item.unit.label}',
                          ),
                          if (item.bestBefore != null)
                            ChipWidget(
                              label:
                                  'Best before: ${formatDate(item.bestBefore!)}',
                            ),
                          ChipStatusWidget(status: status),
                        ],
                      ),
                      if ((item.note ?? '').isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(item.note!, style: TextStyle(color: primaryText)),
                      ],
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: primaryText,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Added: ${formatDate(item.dateAdded)}',
                            style: TextStyle(color: primaryText),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () => Navigator.of(context).maybePop(),
                            child: Text(
                              'Close',
                              style: TextStyle(color: primaryText),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
