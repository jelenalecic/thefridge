import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:thefridge/core/theming/theme_service.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  WidgetsFlutterBinding.ensureInitialized();

  await ThemeService.initTheme();
  runApp(await builder());
}
