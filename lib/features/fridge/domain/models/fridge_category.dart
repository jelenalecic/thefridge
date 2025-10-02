import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/widgets.dart';

enum FridgeCategory {
  dairy,
  meat,
  fish,
  vegetables,
  fruits,
  sweets,
  juices,
  leftover,
  beverage,
  other,
}

extension FridgeCategoryIcon on FridgeCategory {
  IconData get icon {
    switch (this) {
      case FridgeCategory.dairy:
        return FontAwesomeIcons.cheese;
      case FridgeCategory.meat:
        return FontAwesomeIcons.drumstickBite;
      case FridgeCategory.fish:
        return FontAwesomeIcons.fish;
      case FridgeCategory.vegetables:
        return FontAwesomeIcons.carrot;
      case FridgeCategory.fruits:
        return FontAwesomeIcons.appleWhole;
      case FridgeCategory.sweets:
        return FontAwesomeIcons.cakeCandles;
      case FridgeCategory.juices:
        return FontAwesomeIcons.bottleWater;
      case FridgeCategory.leftover:
        return FontAwesomeIcons.box;
      case FridgeCategory.beverage:
        return FontAwesomeIcons.mugHot;
      case FridgeCategory.other:
        return FontAwesomeIcons.question;
    }
  }
}
