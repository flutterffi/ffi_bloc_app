import 'package:flutter/material.dart';

import 'ui/launcher_page.dart';

class FfiBlocApp extends StatelessWidget {
  const FfiBlocApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FFI Bloc BLE',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const LauncherPage(),
    );
  }
}
