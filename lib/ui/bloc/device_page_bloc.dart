import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ble/models/ble_device_item.dart';
import '../../presentation/bloc/connection_bloc.dart';
import '../../presentation/bloc/connection_event.dart';
import '../../presentation/state/connection_state.dart';
import '../widgets/connection_detail_body.dart';

class DevicePageBloc extends StatelessWidget {
  const DevicePageBloc({required this.device, super.key});

  final BleDeviceItem device;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${device.name} · Bloc')),
      body: BlocConsumer<ConnectionBloc, BleConnectionState>(
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
          return ConnectionDetailBody(
            device: device,
            connection: state,
            onConnect: () => context.read<ConnectionBloc>().add(
                  ConnectionConnectRequested(device),
                ),
            onDisconnect: () {
              context
                  .read<ConnectionBloc>()
                  .add(const ConnectionDisconnectRequested());
              Navigator.of(context).pop();
            },
            onReadRssi: () => context
                .read<ConnectionBloc>()
                .add(const ConnectionRssiRequested()),
          );
        },
      ),
    );
  }
}
