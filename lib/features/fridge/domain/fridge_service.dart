import 'dart:math';
import 'package:thefridge/features/fridge/data/fridge_local_store.dart';
import 'package:thefridge/features/fridge/domain/models/expiry_filter.dart';
import 'package:thefridge/features/fridge/domain/models/fridge_category.dart';
import 'package:thefridge/features/fridge/domain/models/fridge_unit.dart';
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

  String newId() => Random().nextInt(1 << 30).toString();

  Future<void> fillWithMockData() async {
    final now = DateTime.now();

    final mocks = <FridgeItem>[
      // Dairy & Meat
      FridgeItem(
        id: newId(),
        name: 'Milk',
        category: FridgeCategory.dairy,
        quantity: 1,
        unit: FridgeUnit.l,
        dateAdded: now.subtract(const Duration(days: 1)),
        bestBefore: now.add(const Duration(days: 3)),
      ),
      FridgeItem(
        id: newId(),
        name: 'Chicken breast',
        category: FridgeCategory.meat,
        quantity: 500,
        unit: FridgeUnit.g,
        dateAdded: now.subtract(const Duration(days: 3)),
        bestBefore: now.subtract(const Duration(days: 1)),
        note: 'Should have been cooked yesterday',
      ),
      FridgeItem(
        id: newId(),
        name: 'Greek yogurt',
        category: FridgeCategory.dairy,
        quantity: 2,
        unit: FridgeUnit.pcs,
        dateAdded: now.subtract(const Duration(days: 2)),
        bestBefore: now.add(const Duration(days: 1)),
      ),
      FridgeItem(
        id: newId(),
        name: 'Cheddar cheese',
        category: FridgeCategory.dairy,
        quantity: 200,
        unit: FridgeUnit.g,
        dateAdded: now,
        bestBefore: now.add(const Duration(days: 14)),
      ),
      FridgeItem(
        id: newId(),
        name: 'Eggs',
        category: FridgeCategory.dairy,
        quantity: 10,
        unit: FridgeUnit.pcs,
        dateAdded: now,
        bestBefore: now.add(const Duration(days: 12)),
      ),
      FridgeItem(
        id: newId(),
        name: 'Bacon',
        category: FridgeCategory.meat,
        quantity: 200,
        unit: FridgeUnit.g,
        dateAdded: now.subtract(const Duration(days: 1)),
        bestBefore: now.add(const Duration(days: 5)),
      ),

      // Vegetables & Fruits
      FridgeItem(
        id: newId(),
        name: 'Spinach',
        category: FridgeCategory.vegetables,
        quantity: 200,
        unit: FridgeUnit.g,
        dateAdded: now,
        bestBefore: now.add(const Duration(days: 5)),
      ),
      FridgeItem(
        id: newId(),
        name: 'Broccoli',
        category: FridgeCategory.vegetables,
        quantity: 1,
        unit: FridgeUnit.pcs,
        dateAdded: now,
        bestBefore: now.add(const Duration(days: 5)),
      ),
      FridgeItem(
        id: newId(),
        name: 'Carrots',
        category: FridgeCategory.vegetables,
        quantity: 1,
        unit: FridgeUnit.kg,
        dateAdded: now,
        bestBefore: now.add(const Duration(days: 10)),
      ),
      FridgeItem(
        id: newId(),
        name: 'Tomatoes',
        category: FridgeCategory.vegetables,
        quantity: 6,
        unit: FridgeUnit.pcs,
        dateAdded: now,
        bestBefore: now.add(const Duration(days: 6)),
      ),
      FridgeItem(
        id: newId(),
        name: 'Cucumber',
        category: FridgeCategory.vegetables,
        quantity: 2,
        unit: FridgeUnit.pcs,
        dateAdded: now,
        bestBefore: now.add(const Duration(days: 7)),
      ),
      FridgeItem(
        id: newId(),
        name: 'Lettuce',
        category: FridgeCategory.vegetables,
        quantity: 1,
        unit: FridgeUnit.pcs,
        dateAdded: now,
        bestBefore: now.add(const Duration(days: 4)),
      ),
      FridgeItem(
        id: newId(),
        name: 'Lemon',
        category: FridgeCategory.fruits,
        quantity: 1,
        unit: FridgeUnit.kg,
        dateAdded: now,
        bestBefore: now.add(const Duration(days: 14)),
      ),
      FridgeItem(
        id: newId(),
        name: 'Avocado',
        category: FridgeCategory.fruits,
        quantity: 3,
        unit: FridgeUnit.pcs,
        dateAdded: now,
        bestBefore: now.add(const Duration(days: 4)),
      ),
      FridgeItem(
        id: newId(),
        name: 'Bananas',
        category: FridgeCategory.fruits,
        quantity: 5,
        unit: FridgeUnit.pcs,
        dateAdded: now,
        bestBefore: now.add(const Duration(days: 3)),
      ),
      FridgeItem(
        id: newId(),
        name: 'Strawberries',
        category: FridgeCategory.fruits,
        quantity: 250,
        unit: FridgeUnit.g,
        dateAdded: now,
        bestBefore: now.add(const Duration(days: 2)),
      ),
      FridgeItem(
        id: newId(),
        name: 'Apples',
        category: FridgeCategory.fruits,
        quantity: 1,
        unit: FridgeUnit.kg,
        dateAdded: now,
        bestBefore: now.add(const Duration(days: 20)),
      ),
      FridgeItem(
        id: newId(),
        name: 'Blueberries',
        category: FridgeCategory.fruits,
        quantity: 150,
        unit: FridgeUnit.g,
        dateAdded: now,
        bestBefore: now.add(const Duration(days: 3)),
      ),

      // Drinks
      FridgeItem(
        id: newId(),
        name: 'Orange juice',
        category: FridgeCategory.juices,
        quantity: 1,
        unit: FridgeUnit.l,
        dateAdded: now.subtract(const Duration(days: 1)),
        bestBefore: now.add(const Duration(days: 7)),
      ),
      FridgeItem(
        id: newId(),
        name: 'Cola',
        category: FridgeCategory.beverage,
        quantity: 2,
        unit: FridgeUnit.bottle,
        dateAdded: now,
        bestBefore: now.add(const Duration(days: 180)),
      ),
      FridgeItem(
        id: newId(),
        name: 'Sparkling water',
        category: FridgeCategory.beverage,
        quantity: 6,
        unit: FridgeUnit.bottle,
        dateAdded: now,
        bestBefore: now.add(const Duration(days: 365)),
      ),
      FridgeItem(
        id: newId(),
        name: 'Beer',
        category: FridgeCategory.beverage,
        quantity: 4,
        unit: FridgeUnit.can,
        dateAdded: now,
        bestBefore: now.add(const Duration(days: 120)),
      ),
      FridgeItem(
        id: newId(),
        name: 'Wine',
        category: FridgeCategory.beverage,
        quantity: 1,
        unit: FridgeUnit.bottle,
        dateAdded: now,
        bestBefore: now.add(const Duration(days: 365)),
      ),

      // Sweets & Other
      FridgeItem(
        id: newId(),
        name: 'Chocolate',
        category: FridgeCategory.sweets,
        quantity: 1,
        unit: FridgeUnit.pack,
        dateAdded: now,
        bestBefore: now.add(const Duration(days: 90)),
      ),
      FridgeItem(
        id: newId(),
        name: 'Cake',
        category: FridgeCategory.sweets,
        quantity: 1,
        unit: FridgeUnit.pcs,
        dateAdded: now,
        bestBefore: now.add(const Duration(days: 2)),
      ),
      FridgeItem(
        id: newId(),
        name: 'Ice cream',
        category: FridgeCategory.sweets,
        quantity: 1,
        unit: FridgeUnit.jar,
        dateAdded: now,
        bestBefore: now.add(const Duration(days: 120)),
      ),
      FridgeItem(
        id: newId(),
        name: 'Cookies',
        category: FridgeCategory.sweets,
        quantity: 1,
        unit: FridgeUnit.pack,
        dateAdded: now,
        bestBefore: now.add(const Duration(days: 30)),
      ),

      // Ready meals
      FridgeItem(
        id: newId(),
        name: 'Greek moussaka',
        category: FridgeCategory.other,
        quantity: 1,
        unit: FridgeUnit.pcs,
        dateAdded: now,
        bestBefore: now.add(const Duration(days: 2)),
      ),
      FridgeItem(
        id: newId(),
        name: 'Pizza',
        category: FridgeCategory.other,
        quantity: 1,
        unit: FridgeUnit.pcs,
        dateAdded: now,
        bestBefore: now.add(const Duration(days: 1)),
      ),
      FridgeItem(
        id: newId(),
        name: 'Mushroom soup',
        category: FridgeCategory.other,
        quantity: 500,
        unit: FridgeUnit.ml,
        dateAdded: now,
        bestBefore: now.add(const Duration(days: 3)),
      ),
      FridgeItem(
        id: newId(),
        name: 'Chicken soup',
        category: FridgeCategory.other,
        quantity: 500,
        unit: FridgeUnit.ml,
        dateAdded: now,
        bestBefore: now.add(const Duration(days: 3)),
      ),
      FridgeItem(
        id: newId(),
        name: 'Lasagna',
        category: FridgeCategory.other,
        quantity: 1,
        unit: FridgeUnit.pcs,
        dateAdded: now,
        bestBefore: now.add(const Duration(days: 2)),
      ),
      FridgeItem(
        id: newId(),
        name: 'Sushi box',
        category: FridgeCategory.other,
        quantity: 1,
        unit: FridgeUnit.pack,
        dateAdded: now,
        bestBefore: now.add(const Duration(days: 1)),
      ),
      FridgeItem(
        id: newId(),
        name: 'Hummus',
        category: FridgeCategory.other,
        quantity: 200,
        unit: FridgeUnit.g,
        dateAdded: now,
        bestBefore: now.add(const Duration(days: 7)),
      ),
    ];

    cache = [...cache, ...mocks];
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
