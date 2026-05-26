import 'package:flutter/material.dart';

import '../../ble/models/ble_device_item.dart';
import '../../presentation/state/scan_state.dart';

class BleDeviceList extends StatelessWidget {
  const BleDeviceList({
    required this.scan,
    required this.onDeviceTap,
    super.key,
  });

  final ScanState scan;
  final void Function(BleDeviceItem device) onDeviceTap;

  @override
  Widget build(BuildContext context) {
    if (scan.devices.isEmpty) {
      return Center(
        child: Text(
          scan.isScanning
              ? 'Searching for peripherals…'
              : 'No devices yet',
        ),
      );
    }

    return ListView.separated(
      itemCount: scan.devices.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final device = scan.devices[index];
        return ListTile(
          leading: const Icon(Icons.bluetooth),
          title: Text(device.name),
          subtitle: Text(device.id),
          trailing: Text('${device.rssi} dBm'),
          onTap: () => onDeviceTap(device),
        );
      },
    );
  }
}
