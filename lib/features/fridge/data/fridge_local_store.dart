import 'package:shared_preferences/shared_preferences.dart';
import 'package:thefridge/features/fridge/domain/models/fridge_item.dart';

class FridgeLocalStore {
  static const String _storageKey = 'thefridge.items.v1';

  Future<List<FridgeItem>> loadAllItems() async {
    //fake wait
    await Future.delayed(Duration(seconds: 1), () {});
    final prefs = await SharedPreferences.getInstance();
    final encodedItems = prefs.getStringList(_storageKey) ?? [];
    final decodedItems = encodedItems
        .map((json) => FridgeItem.fromJson(json))
        .toList();
    return decodedItems;
  }

  Future<void> saveItems(List<FridgeItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedItems = items.map((item) => item.toJson()).toList();
    await prefs.setStringList(_storageKey, encodedItems);
  }
}
