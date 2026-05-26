import 'package:equatable/equatable.dart';

import '../ble/models/ble_device_item.dart';

sealed class ConnectionEvent extends Equatable {
  const ConnectionEvent();

  @override
  List<Object?> get props => [];
}

final class ConnectionConnectRequested extends ConnectionEvent {
  const ConnectionConnectRequested(this.device);

  final BleDeviceItem device;

  @override
  List<Object?> get props => [device];
}

final class ConnectionDisconnectRequested extends ConnectionEvent {
  const ConnectionDisconnectRequested();
}

final class ConnectionLost extends ConnectionEvent {
  const ConnectionLost();
}

final class ConnectionFailed extends ConnectionEvent {
  const ConnectionFailed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class ConnectionRssiRequested extends ConnectionEvent {
  const ConnectionRssiRequested();
}

final class ConnectionRssiUpdated extends ConnectionEvent {
  const ConnectionRssiUpdated(this.rssi);

  final int rssi;

  @override
  List<Object?> get props => [rssi];
}
