enum FridgeUnit { pcs, g, kg, ml, l, pack, slice, bottle, can, jar }

extension FridgeUnitLabel on FridgeUnit {
  String get label {
    switch (this) {
      case FridgeUnit.pcs:
        return 'pcs';
      case FridgeUnit.g:
        return 'g';
      case FridgeUnit.kg:
        return 'kg';
      case FridgeUnit.ml:
        return 'ml';
      case FridgeUnit.l:
        return 'L';
      case FridgeUnit.pack:
        return 'pack';
      case FridgeUnit.slice:
        return 'slice';
      case FridgeUnit.bottle:
        return 'bottle';
      case FridgeUnit.can:
        return 'can';
      case FridgeUnit.jar:
        return 'jar';
    }
  }
}
