import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:thefridge/core/coloring/colors.dart';
import 'package:thefridge/features/fridge/domain/models/expiry_filter.dart';
import 'package:thefridge/features/fridge/domain/models/sort_filter.dart';
import 'package:thefridge/features/fridge/presentation/state/fridge_provider.dart';

class FridgeControlsBar extends ConsumerWidget {
  const FridgeControlsBar({super.key});

  ButtonStyle get dropdownButtonStyle => ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(accent),
    foregroundColor: WidgetStatePropertyAll(appBarText),
    textStyle: WidgetStatePropertyAll(TextStyle(color: appBarText)),
    overlayColor: WidgetStatePropertyAll(surface),
  );

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
                filterButton(
                  icon: Icons.all_inclusive,
                  label: 'All',
                  isSelected: state.filter == ExpiryFilter.all,
                  onTap: () {
                    controller.setFilter(ExpiryFilter.all);
                  },
                ),
                filterButton(
                  icon: FontAwesomeIcons.clock,
                  label: 'Soon',
                  isSelected: state.filter == ExpiryFilter.soon,
                  onTap: () {
                    controller.setFilter(ExpiryFilter.soon);
                  },
                ),

                filterButton(
                  icon: FontAwesomeIcons.hourglassEnd,
                  label: 'Expired',
                  isSelected: state.filter == ExpiryFilter.expired,
                  onTap: () {
                    controller.setFilter(ExpiryFilter.expired);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Theme(
              data: Theme.of(context).copyWith(
                dropdownMenuTheme: DropdownMenuThemeData(
                  inputDecorationTheme: InputDecorationTheme(
                    isDense: true,
                    filled: true,
                    fillColor: surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  textStyle: TextStyle(color: primaryText),
                  menuStyle: MenuStyle(
                    backgroundColor: WidgetStatePropertyAll(accent),
                    surfaceTintColor: const WidgetStatePropertyAll(
                      Colors.transparent,
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    elevation: const WidgetStatePropertyAll(4),
                  ),
                ),
              ),
              child: DropdownMenu<SortBy>(
                initialSelection: state.sortBy,
                trailingIcon: Icon(
                  Icons.arrow_drop_down_rounded,
                  color: primaryText,
                ),
                onSelected: (v) => v != null ? controller.setSort(v) : null,
                dropdownMenuEntries: [
                  DropdownMenuEntry(
                    value: SortBy.bestBefore,
                    label: 'Best before',
                    leadingIcon: Icon(
                      Icons.schedule,
                      color: appBarText,
                      fontWeight: state.sortBy == SortBy.bestBefore
                          ? FontWeight.bold
                          : null,
                    ),
                    style: dropdownButtonStyle.copyWith(
                      textStyle: WidgetStatePropertyAll(
                        TextStyle(
                          fontWeight: state.sortBy == SortBy.bestBefore
                              ? FontWeight.bold
                              : null,
                        ),
                      ),
                    ),
                  ),
                  DropdownMenuEntry(
                    value: SortBy.timeStored,
                    label: 'Time stored',
                    leadingIcon: Icon(
                      Icons.storage_rounded,
                      color: appBarText,
                      fontWeight: state.sortBy == SortBy.timeStored
                          ? FontWeight.bold
                          : null,
                    ),
                    style: dropdownButtonStyle.copyWith(
                      textStyle: WidgetStatePropertyAll(
                        TextStyle(
                          fontWeight: state.sortBy == SortBy.timeStored
                              ? FontWeight.bold
                              : null,
                        ),
                      ),
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

  Widget filterButton({
    required IconData icon,
    required VoidCallback onTap,
    required String label,
    bool isSelected = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6),
        margin: EdgeInsets.only(right: 6),
        child: Column(
          children: [
            FaIcon(
              icon,
              size: 20,
              color: isSelected ? accent : primaryText.withValues(alpha: 0.4),
            ),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? accent : primaryText.withValues(alpha: 0.4),
                fontSize: 12,
              ),
            ),
            if (isSelected)
              Container(
                margin: EdgeInsets.only(top: 2),
                height: 1,
                color: accent,
                width: 35,
              ),
          ],
        ),
      ),
    );
  }
}
