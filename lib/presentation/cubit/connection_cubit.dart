import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ble/ble_repository.dart';
import '../../ble/models/ble_device_item.dart';
import '../state/connection_state.dart';

/// Method-driven connection controller (Cubit / MVVM-style ViewModel).
class ConnectionCubit extends Cubit<BleConnectionState> {
  ConnectionCubit(this._repository) : super(const BleConnectionState()) {
    _connectedSub = _repository.connectedDevice.listen((device) {
      if (device == null && state.status == BleConnectionStatus.connected) {
        emit(const BleConnectionState());
      }
    });
  }

  final BleRepository _repository;
  StreamSubscription<BleDeviceItem?>? _connectedSub;

  Future<void> connect(BleDeviceItem device) async {
    emit(
      BleConnectionState(
        status: BleConnectionStatus.connecting,
        device: device,
      ),
    );
    try {
      await _repository.connect(device);
      emit(
        BleConnectionState(
          status: BleConnectionStatus.connected,
          device: device,
        ),
      );
    } catch (e) {
      emit(
        BleConnectionState(
          status: BleConnectionStatus.failure,
          errorMessage: e.toString(),
          device: device,
        ),
      );
    }
  }

  Future<void> disconnect() async {
    await _repository.disconnect();
    emit(const BleConnectionState());
  }

  Future<void> readRssi() async {
    final rssi = await _repository.readRssi();
    if (rssi != null) {
      emit(state.copyWith(rssi: rssi));
    }
  }

  @override
  Future<void> close() async {
    await _connectedSub?.cancel();
    return super.close();
  }
}
