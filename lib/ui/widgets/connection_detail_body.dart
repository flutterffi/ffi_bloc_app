import 'package:flutter/material.dart';

import '../../ble/models/ble_device_item.dart';
import '../../presentation/state/connection_state.dart';

class ConnectionDetailBody extends StatelessWidget {
  const ConnectionDetailBody({
    required this.device,
    required this.connection,
    required this.onConnect,
    required this.onDisconnect,
    required this.onReadRssi,
    super.key,
  });

  final BleDeviceItem device;
  final BleConnectionState connection;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;
  final VoidCallback onReadRssi;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _InfoRow(label: 'ID', value: device.id),
          _InfoRow(label: 'Name', value: device.name),
          _InfoRow(label: 'Status', value: _statusLabel(connection.status)),
          if (connection.rssi != null)
            _InfoRow(label: 'RSSI', value: '${connection.rssi} dBm'),
          const SizedBox(height: 24),
          if (connection.status == BleConnectionStatus.connected) ...[
            FilledButton.icon(
              onPressed: onReadRssi,
              icon: const Icon(Icons.signal_cellular_alt),
              label: const Text('Read RSSI'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onDisconnect,
              icon: const Icon(Icons.link_off),
              label: const Text('Disconnect'),
            ),
          ] else if (connection.status == BleConnectionStatus.connecting)
            const Center(child: CircularProgressIndicator())
          else
            FilledButton(
              onPressed: onConnect,
              child: const Text('Connect'),
            ),
        ],
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
            child: Text(label, style: Theme.of(context).textTheme.labelLarge),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
