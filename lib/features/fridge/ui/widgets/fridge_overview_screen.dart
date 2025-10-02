import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thefridge/features/fridge/domain/models/fridge_status.dart';
import 'package:thefridge/features/fridge/ui/state/fridge_provider.dart';

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
    final st = ref.watch(fridgeControllerProvider);

    if (st.status == FridgeStatus.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (st.status == FridgeStatus.error) {
      return Scaffold(
        body: Center(child: Text(st.errorMessage ?? 'Unknown error')),
      );
    }

    // ready
    return Scaffold(
      appBar: AppBar(title: const Text('TheFridge')),
      body: st.visible.isEmpty
          ? Center(
              child: FilledButton.icon(
                onPressed: () => ref
                    .read(fridgeControllerProvider.notifier)
                    .fillWithMockData(),
                icon: const Icon(Icons.auto_fix_high),
                label: const Text('Fill me in'),
              ),
            )
          : Column(
              children: [
                IconButton(
                  tooltip: 'Clear all',
                  onPressed: () async {
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
                      await ref
                          .read(fridgeControllerProvider.notifier)
                          .clearAll();

                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Fridge cleared')),
                      );
                    }
                  },
                  icon: const Icon(Icons.delete_forever),
                ),

                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: st.visible.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      final it = st.visible[i];
                      return ListTile(
                        title: Text(it.name),
                        subtitle: Text(
                          '${it.quantity} ${it.unit} • stored ${it.daysStored}d',
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
