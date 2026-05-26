import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ble/ble_repository.dart';
import 'connection/connection_bloc.dart';
import 'scan/scan_bloc.dart';
import 'ui/pages/home_page.dart';

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
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ScanBloc(context.read<BleRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                ConnectionBloc(context.read<BleRepository>()),
          ),
        ],
        child: const HomePage(),
      ),
    );
  }
}
