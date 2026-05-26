import 'package:equatable/equatable.dart';

import '../../ble/models/ble_device_item.dart';

enum BleConnectionStatus { idle, connecting, connected, failure }

class BleConnectionState extends Equatable {
  const BleConnectionState({
    this.status = BleConnectionStatus.idle,
    this.device,
    this.rssi,
    this.errorMessage,
  });

  final BleConnectionStatus status;
  final BleDeviceItem? device;
  final int? rssi;
  final String? errorMessage;

  BleConnectionState copyWith({
    BleConnectionStatus? status,
    BleDeviceItem? device,
    int? rssi,
    String? errorMessage,
    bool clearDevice = false,
    bool clearError = false,
  }) {
    return BleConnectionState(
      status: status ?? this.status,
      device: clearDevice ? null : (device ?? this.device),
      rssi: rssi ?? this.rssi,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, device, rssi, errorMessage];
}
