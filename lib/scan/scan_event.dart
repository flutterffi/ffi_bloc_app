import 'package:equatable/equatable.dart';

import '../ble/models/ble_device_item.dart';

sealed class ScanEvent extends Equatable {
  const ScanEvent();

  @override
  List<Object?> get props => [];
}

final class ScanStarted extends ScanEvent {
  const ScanStarted();
}

final class ScanStopped extends ScanEvent {
  const ScanStopped();
}

final class ScanResultsUpdated extends ScanEvent {
  const ScanResultsUpdated(this.devices);

  final List<BleDeviceItem> devices;

  @override
  List<Object?> get props => [devices];
}

final class ScanFailed extends ScanEvent {
  const ScanFailed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
