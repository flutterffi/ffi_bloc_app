import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ble/models/ble_device_item.dart';
import '../../presentation/bloc/connection_bloc.dart';
import '../../presentation/bloc/connection_event.dart';
import '../../presentation/bloc/scan_bloc.dart';
import '../../presentation/bloc/scan_event.dart';
import '../../presentation/state/connection_state.dart';
import '../../presentation/state/scan_state.dart';
import '../widgets/ble_device_list.dart';
import '../widgets/ble_status_banner.dart';
import 'device_page_bloc.dart';

class HomePageBloc extends StatelessWidget {
  const HomePageBloc({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLE · Bloc (Event)'),
        actions: [
          BlocBuilder<ScanBloc, ScanState>(
            builder: (context, state) {
              return IconButton(
                tooltip: state.isScanning ? 'Stop scan' : 'Start scan',
                onPressed: () {
                  final bloc = context.read<ScanBloc>();
                  if (state.isScanning) {
                    bloc.add(const ScanStopped());
                  } else {
                    bloc.add(const ScanStarted());
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
          BlocBuilder<ScanBloc, ScanState>(
            builder: (context, scan) {
              return BlocBuilder<ConnectionBloc, BleConnectionState>(
                builder: (context, connection) {
                  return BleStatusBanner(scan: scan, connection: connection);
                },
              );
            },
          ),
          Expanded(
            child: BlocBuilder<ScanBloc, ScanState>(
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
      floatingActionButton: BlocBuilder<ScanBloc, ScanState>(
        builder: (context, scan) {
          return FloatingActionButton.extended(
            onPressed: () {
              final bloc = context.read<ScanBloc>();
              if (scan.isScanning) {
                bloc.add(const ScanStopped());
              } else {
                bloc.add(const ScanStarted());
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
    context.read<ScanBloc>().add(const ScanStopped());
    context.read<ConnectionBloc>().add(ConnectionConnectRequested(device));
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DevicePageBloc(device: device),
      ),
    );
  }
}
