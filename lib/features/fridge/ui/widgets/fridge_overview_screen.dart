import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thefridge/core/theming/app_theme.dart';
import 'package:thefridge/core/theming/colors.dart';
import 'package:thefridge/core/theming/theme_service.dart';
import 'package:thefridge/features/fridge/domain/models/expiry_filter.dart';
import 'package:thefridge/features/fridge/domain/models/sort_filter.dart';
import 'package:thefridge/features/fridge/domain/models/fridge_item.dart';
import 'package:thefridge/features/fridge/domain/models/fridge_status.dart';
import 'package:thefridge/features/fridge/ui/state/fridge_provider.dart';
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

    if (state.status == FridgeStatus.loading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (state.status == FridgeStatus.error) {
      return Scaffold(
        body: Center(child: Text(state.errorMessage ?? 'Unknown error')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: surface,
        title: Text('TheFridge', style: TextStyle(color: primaryText)),
        actions: [
          IconButton(
            icon: Icon(Icons.dark_mode, color: primaryText),
            onPressed: () {
              ThemeService.setTheme(AppThemeType.dark, context);
            },
          ),
          IconButton(
            icon: Icon(Icons.light_mode, color: primaryText),
            onPressed: () {
              ThemeService.setTheme(AppThemeType.light, context);
            },
          ),
          IconButton(
            tooltip: 'Clear all',
            color: primaryText,
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final shouldClear = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Remove all items from the fridge?'),
                  content: const Text(
                    'This will remove all items from the fridge.',
                  ),
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
                messenger.showSnackBar(
                  const SnackBar(content: Text('Fridge cleared')),
                );
              }
            },
            icon: const Icon(Icons.delete_forever),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: state.visible.isEmpty
          ? Container(
              alignment: Alignment.center,
              color: surface,
              child: FilledButton.icon(
                onPressed: () => ref
                    .read(fridgeControllerProvider.notifier)
                    .fillWithMockData(),
                icon: const Icon(Icons.auto_fix_high),
                label: const Text('Fill the fridge in'),
              ),
            )
          : Container(
              color: surface,
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  const _ControlsBar(),
                  const SizedBox(height: 8),
                  Expanded(child: _FridgeGrid(items: state.visible)),
                ],
              ),
            ),
    );
  }
}

class _ControlsBar extends ConsumerWidget {
  const _ControlsBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fridgeControllerProvider);
    final controller = ref.read(fridgeControllerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  tooltip: 'All',
                  isSelected: state.filter == ExpiryFilter.all,
                  onPressed: () => controller.setFilter(ExpiryFilter.all),
                  icon: const Icon(Icons.all_inclusive),
                ),
                IconButton(
                  tooltip: 'Soon',
                  isSelected: state.filter == ExpiryFilter.soon,
                  onPressed: () => controller.setFilter(ExpiryFilter.soon),
                  icon: const Icon(Icons.access_time),
                ),
                IconButton(
                  tooltip: 'Expired',
                  isSelected: state.filter == ExpiryFilter.expired,
                  onPressed: () => controller.setFilter(ExpiryFilter.expired),
                  icon: const Icon(Icons.warning_amber),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          DropdownButtonHideUnderline(
            child: DropdownButton<SortBy>(
              value: state.sortBy,
              onChanged: (v) {
                if (v != null) controller.setSort(v);
              },
              items: const [
                DropdownMenuItem(
                  value: SortBy.bestBefore,
                  child: Text('Best before'),
                ),
                DropdownMenuItem(
                  value: SortBy.timeStored,
                  child: Text('Time stored'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FridgeGrid extends StatelessWidget {
  const _FridgeGrid({required this.items});

  final List<FridgeItem> items;

  @override
  Widget build(BuildContext context) {
    return FridgeGridWidget(items: items);
  }
}
