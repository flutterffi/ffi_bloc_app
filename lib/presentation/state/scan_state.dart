import 'package:equatable/equatable.dart';

import '../../ble/models/ble_device_item.dart';

enum ScanStatus { idle, scanning, failure }

class ScanState extends Equatable {
  const ScanState({
    this.status = ScanStatus.idle,
    this.devices = const [],
    this.errorMessage,
  });

  final ScanStatus status;
  final List<BleDeviceItem> devices;
  final String? errorMessage;

  bool get isScanning => status == ScanStatus.scanning;

  ScanState copyWith({
    ScanStatus? status,
    List<BleDeviceItem>? devices,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ScanState(
      status: status ?? this.status,
      devices: devices ?? this.devices,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, devices, errorMessage];
}
