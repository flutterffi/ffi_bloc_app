import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ble/ble_repository.dart';
import '../../presentation/cubit/connection_cubit.dart';
import '../../presentation/cubit/scan_cubit.dart';
import '../cubit/home_page_cubit.dart';

class CubitModeShell extends StatelessWidget {
  const CubitModeShell({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ScanCubit(context.read<BleRepository>()),
        ),
        BlocProvider(
          create: (context) =>
              ConnectionCubit(context.read<BleRepository>()),
        ),
      ],
      child: const HomePageCubit(),
    );
  }
}
