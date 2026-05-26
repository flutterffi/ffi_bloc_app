import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ble/models/ble_device_item.dart';
import '../../connection/connection_bloc.dart';
import '../../connection/connection_event.dart';
import '../../connection/connection_state.dart';
import '../../scan/scan_bloc.dart';
import '../../scan/scan_event.dart';
import '../../scan/scan_state.dart';
import 'device_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLE Scanner'),
        actions: [
          BlocBuilder<ScanBloc, ScanState>(
            builder: (context, state) {
              if (state.isScanning) {
                return IconButton(
                  tooltip: 'Stop scan',
                  onPressed: () =>
                      context.read<ScanBloc>().add(const ScanStopped()),
                  icon: const Icon(Icons.stop),
                );
              }
              return IconButton(
                tooltip: 'Start scan',
                onPressed: () =>
                    context.read<ScanBloc>().add(const ScanStarted()),
                icon: const Icon(Icons.bluetooth_searching),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _StatusBanner(),
          Expanded(child: _DeviceList()),
        ],
      ),
      floatingActionButton: BlocBuilder<ScanBloc, ScanState>(
        builder: (context, state) {
          final scanning = state.isScanning;
          return FloatingActionButton.extended(
            onPressed: () {
              final bloc = context.read<ScanBloc>();
              if (scanning) {
                bloc.add(const ScanStopped());
              } else {
                bloc.add(const ScanStarted());
              }
            },
            icon: Icon(scanning ? Icons.stop : Icons.search),
            label: Text(scanning ? 'Stop' : 'Scan'),
          );
        },
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectionBloc, BleConnectionState>(
      builder: (context, connection) {
        return BlocBuilder<ScanBloc, ScanState>(
          builder: (context, scan) {
            String message;
            Color color;
            if (connection.status == BleConnectionStatus.connected &&
                connection.device != null) {
              message = 'Connected: ${connection.device!.name}';
              color = Colors.green.shade100;
            } else if (connection.status == BleConnectionStatus.connecting) {
              message = 'Connecting…';
              color = Colors.amber.shade100;
            } else if (scan.status == ScanStatus.failure) {
              message = scan.errorMessage ?? 'Scan failed';
              color = Colors.red.shade100;
            } else if (scan.isScanning) {
              message = 'Scanning… ${scan.devices.length} device(s)';
              color = Colors.blue.shade50;
            } else {
              message = 'Tap Scan to discover BLE devices';
              color = Colors.grey.shade200;
            }
            return Material(
              color: color,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(message),
              ),
            );
          },
        );
      },
    );
  }
}

class _DeviceList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScanBloc, ScanState>(
      builder: (context, state) {
        if (state.devices.isEmpty) {
          return Center(
            child: Text(
              state.isScanning
                  ? 'Searching for peripherals…'
                  : 'No devices yet',
            ),
          );
        }
        return ListView.separated(
          itemCount: state.devices.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final device = state.devices[index];
            return _DeviceTile(device: device);
          },
        );
      },
    );
  }
}

class _DeviceTile extends StatelessWidget {
  const _DeviceTile({required this.device});

  final BleDeviceItem device;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.bluetooth),
      title: Text(device.name),
      subtitle: Text(device.id),
      trailing: Text('${device.rssi} dBm'),
      onTap: () {
        context.read<ScanBloc>().add(const ScanStopped());
        context
            .read<ConnectionBloc>()
            .add(ConnectionConnectRequested(device));
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => DevicePage(device: device),
          ),
        );
      },
    );
  }
}
