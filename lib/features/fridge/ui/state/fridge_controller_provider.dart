import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thefridge/features/fridge/data/fridge_local_store.dart';
import 'package:thefridge/features/fridge/domain/mock/mock_data.dart';
import 'package:thefridge/features/fridge/domain/models/expiry_filter.dart';
import 'package:thefridge/features/fridge/domain/models/fridge_category.dart';
import 'package:thefridge/features/fridge/domain/models/fridge_status.dart';
import 'package:thefridge/features/fridge/domain/models/sort_filter.dart';
import 'package:thefridge/features/fridge/domain/models/fridge_unit.dart';
import 'package:thefridge/features/fridge/domain/models/fridge_item.dart';
import 'package:thefridge/features/fridge/domain/models/fridge_state.dart';
import 'package:thefridge/features/fridge/domain/fridge_service.dart';

class FridgeController extends Notifier<FridgeState> {
  final FridgeService service = FridgeService(FridgeLocalStore());
  final Random random = Random();

  @override
  FridgeState build() {
    return FridgeState.initial();
  }

  Future<void> load() async {
    state = state.copyWith(status: FridgeStatus.loading, errorMessage: null);
    try {
      await service.init();
      final items = service.getAll();
      state = state.copyWith(items: items, status: FridgeStatus.ready);
    } catch (e) {
      state = state.copyWith(
        status: FridgeStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> upsert(FridgeItem item) async {
    await service.upsert(item);
    state = state.copyWith(items: service.getAll());
  }

  Future<void> addNew({
    required String name,
    required String id,
    required FridgeCategory category,
    required double quantity,
    required FridgeUnit unit,
    DateTime? bestBefore,
    String? note,
  }) async {
    final now = DateTime.now();
    final newItem = FridgeItem(
      id: id,
      name: name.trim(),
      category: category,
      quantity: quantity,
      unit: unit,
      dateAdded: now,
      bestBefore: bestBefore,
      note: (note?.trim().isEmpty ?? true) ? null : note!.trim(),
    );
    await service.upsert(newItem);
    state = state.copyWith(items: service.getAll());
  }

  Future<void> delete(String id) async {
    await service.delete(id);
    state = state.copyWith(items: service.getAll());
  }

  Future<void> clearAll() async {
    await service.clearAll();
    state = state.copyWith(items: const []);
  }

  void setFilter(ExpiryFilter filter) {
    state = state.copyWith(filter: filter);
  }

  void setSort(SortBy sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }

  Future<void> fillWithMockData() async {
    await service.clearAll();
    await fillInMockData(service);
    state = state.copyWith(items: service.getAll());
  }
}
