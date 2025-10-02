import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:thefridge/core/theming/colors.dart';
import 'package:thefridge/features/fridge/domain/models/fridge_category.dart';
import 'package:thefridge/features/fridge/domain/models/fridge_item.dart';
import 'package:thefridge/features/fridge/domain/models/fridge_unit.dart';

class FridgeGridItem extends StatelessWidget {
  const FridgeGridItem({required this.item, super.key});

  final FridgeItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: card,
      elevation: 11,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              badge(item),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(item.category.icon, size: 20, color: primaryText),
                    const SizedBox(height: 8),
                    Text(
                      '${item.quantity} ${item.unit.label}',
                      style: TextStyle(color: primaryText, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: item.isExpired
                ? const SizedBox.shrink()
                : Container(
                    margin: EdgeInsets.only(right: 6, bottom: 6),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: item.getColor(),
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 20,
                          color: Colors.white70,
                        ),
                        Text(
                          '${item.daysLeft}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget badge(FridgeItem item) {
    return Container(
      height: 12,
      decoration: BoxDecoration(
        color: item.getColor().withValues(alpha: 0.8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
    );
  }
}
