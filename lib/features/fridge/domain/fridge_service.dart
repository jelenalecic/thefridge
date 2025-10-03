import 'package:thefridge/features/fridge/data/fridge_local_store.dart';
import 'package:thefridge/features/fridge/domain/models/expiry_filter.dart';
import 'package:thefridge/features/fridge/domain/models/sort_filter.dart';
import 'package:thefridge/features/fridge/domain/models/fridge_item.dart';

class FridgeService {
  FridgeService(this.store);

  final FridgeLocalStore store;
  List<FridgeItem> cache = [];
  bool initialized = false;

  Future<void> init() async {
    if (initialized) return;
    cache = await store.loadAllItems();
    initialized = true;
  }

  bool get isEmpty => cache.isEmpty;

  List<FridgeItem> getAll() => List.unmodifiable(cache);

  Future<void> clearAll() async {
    cache = [];
    await store.saveItems(cache);
  }

  Future<void> upsert(FridgeItem item) async {
    final index = cache.indexWhere((e) => e.id == item.id);
    if (index == -1) {
      cache = [...cache, item];
    } else {
      cache = [...cache]..[index] = item;
    }
    await store.saveItems(cache);
  }

  Future<void> delete(String id) async {
    cache = cache.where((e) => e.id != id).toList();
    await store.saveItems(cache);
  }

  List<FridgeItem> visible({
    ExpiryFilter filter = ExpiryFilter.all,
    SortBy sortBy = SortBy.bestBefore,
  }) {
    final filtered = cache.where((item) {
      if (filter == ExpiryFilter.all) return true;
      if (filter == ExpiryFilter.expired) return item.isExpired;
      final daysLeft = item.daysLeft;
      return daysLeft != null && daysLeft >= 0 && daysLeft <= 3;
    }).toList();

    int bestBeforeMillis(FridgeItem item) {
      final date = item.bestBefore ?? DateTime(9999);
      return date.millisecondsSinceEpoch;
    }

    filtered.sort((a, b) {
      if (sortBy == SortBy.timeStored) {
        return a.dateAdded.compareTo(b.dateAdded);
      }
      return bestBeforeMillis(a).compareTo(bestBeforeMillis(b));
    });

    return filtered;
  }
}
