import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thefridge/features/fridge/domain/models/fridge_state.dart';
import 'package:thefridge/features/fridge/ui/state/fridge_controller_provider.dart';

final fridgeControllerProvider =
    NotifierProvider<FridgeController, FridgeState>(FridgeController.new);
