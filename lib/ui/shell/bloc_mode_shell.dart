import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ble/ble_repository.dart';
import '../../presentation/bloc/connection_bloc.dart';
import '../../presentation/bloc/scan_bloc.dart';
import '../bloc/home_page_bloc.dart';

class BlocModeShell extends StatelessWidget {
  const BlocModeShell({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ScanBloc(context.read<BleRepository>()),
        ),
        BlocProvider(
          create: (context) =>
              ConnectionBloc(context.read<BleRepository>()),
        ),
      ],
      child: const HomePageBloc(),
    );
  }
}
