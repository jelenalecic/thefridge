import 'package:thefridge/features/fridge/domain/models/expiry_filter.dart';
import 'package:thefridge/features/fridge/domain/models/fridge_status.dart';
import 'package:thefridge/features/fridge/domain/models/sort_filter.dart';
import 'package:thefridge/features/fridge/domain/models/fridge_item.dart';

class FridgeState {
  final List<FridgeItem> items;
  final ExpiryFilter filter;
  final SortBy sortBy;
  final FridgeStatus status;
  final String? errorMessage;

  const FridgeState({
    required this.items,
    required this.filter,
    required this.sortBy,
    required this.status,
    this.errorMessage,
  });

  factory FridgeState.initial() => const FridgeState(
    items: [],
    filter: ExpiryFilter.all,
    sortBy: SortBy.bestBefore,
    status: FridgeStatus.initial,
    errorMessage: null,
  );

  FridgeState copyWith({
    List<FridgeItem>? items,
    ExpiryFilter? filter,
    SortBy? sortBy,
    FridgeStatus? status,
    String? errorMessage,
  }) {
    return FridgeState(
      items: items ?? this.items,
      filter: filter ?? this.filter,
      sortBy: sortBy ?? this.sortBy,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  bool get isEmpty => items.isEmpty;

  List<FridgeItem> get visible {
    final filtered = items.where((i) {
      switch (filter) {
        case ExpiryFilter.all:
          return true;
        case ExpiryFilter.soon:
          final d = i.daysLeft;
          return d != null && d >= 0 && d <= 3;
        case ExpiryFilter.expired:
          return i.isExpired;
      }
    }).toList();

    filtered.sort((a, b) {
      switch (sortBy) {
        case SortBy.bestBefore:
          final at =
              a.bestBefore?.millisecondsSinceEpoch ?? 1 << 62; // nulls last
          final bt = b.bestBefore?.millisecondsSinceEpoch ?? 1 << 62;
          return at.compareTo(bt);
        case SortBy.timeStored:
          return a.dateAdded.compareTo(b.dateAdded);
      }
    });

    return filtered;
  }
}
