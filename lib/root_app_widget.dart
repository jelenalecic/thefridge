import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thefridge/features/fridge/ui/widgets/fridge_overview_screen.dart'
    show FridgeScreen;

class RootAppWidget extends ConsumerStatefulWidget {
  const RootAppWidget({super.key});

  @override
  RootWidgetState createState() => RootWidgetState();

  ///get nearest [RootWidgetState] UP in the tree
  static RootWidgetState of(BuildContext context) {
    return context.findAncestorStateOfType<RootWidgetState>()!;
  }
}

class RootWidgetState extends ConsumerState<RootAppWidget> {
  ValueKey valueKey = ValueKey(0);

  void redrawApp() {
    setState(() {
      final random = Random();
      int randomInt = random.nextInt(999999);
      valueKey = ValueKey(randomInt);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TheFridge',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: ProviderScope(child: FridgeScreen()),
    );
  }
}
