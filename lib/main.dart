import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'ble/ble_repository.dart';
import 'ble/flutter_blue_ble_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    RepositoryProvider<BleRepository>(
      create: (_) => FlutterBlueBleRepository(),
      child: const FfiBlocApp(),
    ),
  );
}
