import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:thefridge/features/fridge/domain/models/fridge_category.dart';
import 'package:thefridge/features/fridge/domain/models/fridge_unit.dart';

class FridgeItem {
  final String id;
  final String name;
  final FridgeCategory category;
  final double quantity;
  final FridgeUnit unit;
  final DateTime dateAdded;
  final DateTime? bestBefore;
  final String? note;

  const FridgeItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.dateAdded,
    this.bestBefore,
    this.note,
  });

  bool get isExpired =>
      bestBefore != null && DateTime.now().isAfter(bestBefore!);

  int? get daysLeft => bestBefore?.difference(DateTime.now()).inDays;

  int get daysStored => DateTime.now().difference(dateAdded).inDays;

  FridgeItem copyWith({
    String? id,
    String? name,
    FridgeCategory? category,
    double? quantity,
    FridgeUnit? unit,
    DateTime? dateAdded,
    DateTime? bestBefore,
    String? note,
  }) {
    return FridgeItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      dateAdded: dateAdded ?? this.dateAdded,
      bestBefore: bestBefore ?? this.bestBefore,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'category': category.name,
    'quantity': quantity,
    'unit': unit.name,
    'dateAdded': dateAdded.toIso8601String(),
    'bestBefore': bestBefore?.toIso8601String(),
    'note': note,
  };

  factory FridgeItem.fromMap(Map<String, dynamic> map) => FridgeItem(
    id: map['id'] as String,
    name: map['name'] as String,
    category: FridgeCategory.values.firstWhere(
      (e) => e.name == map['category'] as String,
    ),
    quantity: (map['quantity'] as num).toDouble(),
    unit: FridgeUnit.values.firstWhere((e) => e.name == map['unit'] as String),
    dateAdded: DateTime.parse(map['dateAdded'] as String),
    bestBefore: map['bestBefore'] == null
        ? null
        : DateTime.parse(map['bestBefore']),
    note: map['note'] as String?,
  );

  String toJson() => jsonEncode(toMap());

  factory FridgeItem.fromJson(String source) =>
      FridgeItem.fromMap(jsonDecode(source) as Map<String, dynamic>);

  Color getColor() {
    if (isExpired) {
      return Colors.red;
    } else if (daysLeft != null && daysLeft! <= 3) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
}
