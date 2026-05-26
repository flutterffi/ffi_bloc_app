import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ble/models/ble_device_item.dart';
import '../../presentation/cubit/connection_cubit.dart';
import '../../presentation/state/connection_state.dart';
import '../widgets/connection_detail_body.dart';

class DevicePageCubit extends StatelessWidget {
  const DevicePageCubit({required this.device, super.key});

  final BleDeviceItem device;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${device.name} · Cubit')),
      body: BlocConsumer<ConnectionCubit, BleConnectionState>(
        listener: (context, state) {
          if (state.status == BleConnectionStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Connection failed'),
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<ConnectionCubit>();
          return ConnectionDetailBody(
            device: device,
            connection: state,
            onConnect: () => cubit.connect(device),
            onDisconnect: () async {
              await cubit.disconnect();
              if (context.mounted) Navigator.of(context).pop();
            },
            onReadRssi: cubit.readRssi,
          );
        },
      ),
    );
  }
}
