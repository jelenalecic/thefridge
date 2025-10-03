import 'package:flutter/material.dart';
import 'package:thefridge/features/fridge/domain/models/fridge_item.dart';
import 'package:thefridge/features/fridge/ui/widgets/fridge_grid_item.dart';

class FridgeGridWidget extends StatelessWidget {
  const FridgeGridWidget({
    required this.items,
    required this.onItemLongPressed,
    super.key,
  });

  final List<FridgeItem> items;
  final Function(FridgeItem item) onItemLongPressed;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 150,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final item = items[i];
        return FridgeGridItem(
          item: item,
          index: i,
          onItemLongPressed: (FridgeItem item) {
            onItemLongPressed(item);
          },
        );
      },
    );
  }
}
