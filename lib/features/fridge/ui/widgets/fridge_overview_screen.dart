import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thefridge/core/coloring/app_theme.dart';
import 'package:thefridge/core/coloring/colors.dart';
import 'package:thefridge/core/coloring/theme_service.dart';
import 'package:thefridge/features/fridge/domain/models/fridge_item.dart';
import 'package:thefridge/features/fridge/domain/models/fridge_status.dart';
import 'package:thefridge/features/fridge/ui/state/fridge_provider.dart';
import 'package:thefridge/features/fridge/ui/widgets/fridge_controls_bar.dart';
import 'package:thefridge/features/fridge/ui/widgets/fridge_grid_widget.dart';

class FridgeScreen extends ConsumerStatefulWidget {
  const FridgeScreen({super.key});

  @override
  ConsumerState<FridgeScreen> createState() => _FridgeScreenState();
}

class _FridgeScreenState extends ConsumerState<FridgeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(fridgeControllerProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fridgeControllerProvider);
    final hasAnyItems = state.items.isNotEmpty;
    final hasVisible = state.visible.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: accent,
        title: Text(
          'TheFridge',
          style: TextStyle(color: appBarText, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            color: Colors.pink,
            icon: Icon(Icons.dark_mode, color: appBarText),
            onPressed: () {
              ThemeService.setTheme(AppThemeType.dark, context);
            },
          ),
          IconButton(
            icon: Icon(Icons.light_mode, color: appBarText),
            onPressed: () {
              ThemeService.setTheme(AppThemeType.light, context);
            },
          ),

          _buildOptionsMenu(),
          const SizedBox(width: 8),
        ],
      ),
      body: state.status == FridgeStatus.loading
          ? Container(
              color: surface,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : state.status == FridgeStatus.error
          ? Center(child: Text(state.errorMessage ?? 'Unknown error'))
          : hasAnyItems
          ? Container(
              color: surface,
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  FridgeControlsBar(key: UniqueKey()),
                  const SizedBox(height: 8),
                  hasVisible
                      ? Expanded(
                          child: FridgeGridWidget(
                            items: state.visible,
                            onItemPressed: (FridgeItem item) {},
                            onItemLongPressed: (FridgeItem item) {
                              askIfUserWantsToDelete(item);
                            },
                          ),
                        )
                      : Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              'No items for selected filters',
                              style: TextStyle(color: primaryText),
                            ),
                          ),
                        ),
                  const SizedBox(height: 12),
                ],
              ),
            )
          : Container(
              alignment: Alignment.center,
              color: surface,
              child: FilledButton.icon(
                onPressed: () => ref
                    .read(fridgeControllerProvider.notifier)
                    .fillWithMockData(),
                icon: const Icon(Icons.auto_fix_high),
                label: const Text('Fill the fridge in'),
              ),
            ),
    );
  }

  Widget _buildOptionsMenu() {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert, size: 20, color: appBarText),
      color: accent,
      surfaceTintColor: appBarText,
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          onTap: () {
            performClearing();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.delete_forever, color: appBarText),
              Text('Clear the fridge', style: TextStyle(color: appBarText)),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> performClearing() async {
    final messenger = ScaffoldMessenger.of(context);
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remove all items from the fridge?'),
        content: const Text('This will remove all items from the fridge.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Perform clearing'),
          ),
        ],
      ),
    );
    if (shouldClear == true) {
      await ref.read(fridgeControllerProvider.notifier).clearAll();
      messenger.showSnackBar(const SnackBar(content: Text('Fridge cleared')));
    }
  }

  void askIfUserWantsToDelete(FridgeItem item) async {
    final messenger = ScaffoldMessenger.of(context);
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Are you sure you want to delete ${item.name}?'),
        content: const Text(
          'This will remove this item from the fridge permanently.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (shouldDelete == true) {
      ref.read(fridgeControllerProvider.notifier).delete(item.id);
      messenger.showSnackBar(SnackBar(content: Text('${item.name} deleted.')));
    }
  }
}
