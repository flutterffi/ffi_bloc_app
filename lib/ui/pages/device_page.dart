import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ble/models/ble_device_item.dart';
import '../../connection/connection_bloc.dart';
import '../../connection/connection_event.dart';
import '../../connection/connection_state.dart';

class DevicePage extends StatelessWidget {
  const DevicePage({required this.device, super.key});

  final BleDeviceItem device;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(device.name)),
      body: BlocConsumer<ConnectionBloc, BleConnectionState>(
        listener: (context, state) {
          if (state.status == BleConnectionStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Connection failed')),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _InfoRow(label: 'ID', value: device.id),
                _InfoRow(label: 'Name', value: device.name),
                _InfoRow(
                  label: 'Status',
                  value: _statusLabel(state.status),
                ),
                if (state.rssi != null)
                  _InfoRow(label: 'RSSI', value: '${state.rssi} dBm'),
                const SizedBox(height: 24),
                if (state.status == BleConnectionStatus.connected) ...[
                  FilledButton.icon(
                    onPressed: () => context
                        .read<ConnectionBloc>()
                        .add(const ConnectionRssiRequested()),
                    icon: const Icon(Icons.signal_cellular_alt),
                    label: const Text('Read RSSI'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      context
                          .read<ConnectionBloc>()
                          .add(const ConnectionDisconnectRequested());
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.link_off),
                    label: const Text('Disconnect'),
                  ),
                ] else if (state.status == BleConnectionStatus.connecting)
                  const Center(child: CircularProgressIndicator())
                else
                  FilledButton(
                    onPressed: () => context.read<ConnectionBloc>().add(
                          ConnectionConnectRequested(device),
                        ),
                    child: const Text('Connect'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _statusLabel(BleConnectionStatus status) {
    return switch (status) {
      BleConnectionStatus.idle => 'Idle',
      BleConnectionStatus.connecting => 'Connecting',
      BleConnectionStatus.connected => 'Connected',
      BleConnectionStatus.failure => 'Failed',
    };
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
