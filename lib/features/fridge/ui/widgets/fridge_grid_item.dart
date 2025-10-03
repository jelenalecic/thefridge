import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:thefridge/core/coloring/colors.dart';
import 'package:thefridge/core/widgets/fade_slide_in_widget.dart';
import 'package:thefridge/features/fridge/domain/models/fridge_category.dart';
import 'package:thefridge/features/fridge/domain/models/fridge_item.dart';
import 'package:thefridge/features/fridge/domain/models/fridge_unit.dart';

class FridgeGridItem extends StatelessWidget {
  const FridgeGridItem({
    required this.item,

    required this.onItemLongPressed,
    required this.index,
    super.key,
  });

  final FridgeItem item;
  final int index;

  final Function(FridgeItem item) onItemLongPressed;

  @override
  Widget build(BuildContext context) {
    return FadeSlideIn(
      key: UniqueKey(),
      index: index,
      child: Card(
        color: card,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: InkWell(
          onLongPress: () {
            onItemLongPressed(item);
          },
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: item.getColor().withValues(alpha: 0.8),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(
                          item.category.icon,
                          size: 40,
                          color: primaryText,
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.only(left: 6, bottom: 6),
                          child: Text(
                            '${item.quantity} ${item.unit.label}',
                            style: TextStyle(color: primaryText, fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Container(
                        child: item.isExpired
                            ? Container(
                                margin: EdgeInsets.only(right: 6, bottom: 6),
                                width: 28,
                                height: 28,
                                child: Text(
                                  '!!!',
                                  style: TextStyle(
                                    color: errorColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.only(right: 6, bottom: 6),
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: item.getColor().withValues(alpha: 0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 24,
                                      color: primaryText,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 2),
                                      child: Text(
                                        '${item.daysLeft}',
                                        style: TextStyle(
                                          color: primaryText,
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      item.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(color: primaryText),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
