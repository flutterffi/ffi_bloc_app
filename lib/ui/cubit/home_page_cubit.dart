import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ble/models/ble_device_item.dart';
import '../../presentation/cubit/connection_cubit.dart';
import '../../presentation/cubit/scan_cubit.dart';
import '../../presentation/state/connection_state.dart';
import '../../presentation/state/scan_state.dart';
import '../widgets/ble_device_list.dart';
import '../widgets/ble_status_banner.dart';
import 'device_page_cubit.dart';

class HomePageCubit extends StatelessWidget {
  const HomePageCubit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLE · Cubit (Method)'),
        actions: [
          BlocBuilder<ScanCubit, ScanState>(
            builder: (context, state) {
              return IconButton(
                tooltip: state.isScanning ? 'Stop scan' : 'Start scan',
                onPressed: () {
                  final cubit = context.read<ScanCubit>();
                  if (state.isScanning) {
                    cubit.stopScan();
                  } else {
                    cubit.startScan();
                  }
                },
                icon: Icon(
                  state.isScanning ? Icons.stop : Icons.bluetooth_searching,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          BlocBuilder<ScanCubit, ScanState>(
            builder: (context, scan) {
              return BlocBuilder<ConnectionCubit, BleConnectionState>(
                builder: (context, connection) {
                  return BleStatusBanner(scan: scan, connection: connection);
                },
              );
            },
          ),
          Expanded(
            child: BlocBuilder<ScanCubit, ScanState>(
              builder: (context, scan) {
                return BleDeviceList(
                  scan: scan,
                  onDeviceTap: (device) => _onDeviceTap(context, device),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: BlocBuilder<ScanCubit, ScanState>(
        builder: (context, scan) {
          return FloatingActionButton.extended(
            onPressed: () {
              final cubit = context.read<ScanCubit>();
              if (scan.isScanning) {
                cubit.stopScan();
              } else {
                cubit.startScan();
              }
            },
            icon: Icon(scan.isScanning ? Icons.stop : Icons.search),
            label: Text(scan.isScanning ? 'Stop' : 'Scan'),
          );
        },
      ),
    );
  }

  void _onDeviceTap(BuildContext context, BleDeviceItem device) {
    context.read<ScanCubit>().stopScan();
    context.read<ConnectionCubit>().connect(device);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DevicePageCubit(device: device),
      ),
    );
  }
}
