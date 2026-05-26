import 'package:flutter/material.dart';

import '../../presentation/state/connection_state.dart';
import '../../presentation/state/scan_state.dart';

class BleStatusBanner extends StatelessWidget {
  const BleStatusBanner({
    required this.scan,
    required this.connection,
    super.key,
  });

  final ScanState scan;
  final BleConnectionState connection;

  @override
  Widget build(BuildContext context) {
    late final String message;
    late final Color color;

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
  }
}
