import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../ble/ble_repository.dart';
import 'connection_event.dart';
import 'connection_state.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, BleConnectionState> {
  ConnectionBloc(this._repository) : super(const BleConnectionState()) {
    on<ConnectionConnectRequested>(_onConnect);
    on<ConnectionDisconnectRequested>(_onDisconnect);
    on<ConnectionLost>(_onLost);
    on<ConnectionFailed>(_onFailed);
    on<ConnectionRssiRequested>(_onRssiRequested);
    on<ConnectionRssiUpdated>(_onRssiUpdated);

    _connectedSub = _repository.connectedDevice.listen((device) {
      if (device == null && state.status == BleConnectionStatus.connected) {
        add(const ConnectionLost());
      }
    });
  }

  final BleRepository _repository;
  StreamSubscription<dynamic>? _connectedSub;

  Future<void> _onConnect(
    ConnectionConnectRequested event,
    Emitter<BleConnectionState> emit,
  ) async {
    emit(
      BleConnectionState(
        status: BleConnectionStatus.connecting,
        device: event.device,
      ),
    );
    try {
      await _repository.connect(event.device);
      emit(
        BleConnectionState(
          status: BleConnectionStatus.connected,
          device: event.device,
        ),
      );
    } catch (e) {
      add(ConnectionFailed(e.toString()));
    }
  }

  Future<void> _onDisconnect(
    ConnectionDisconnectRequested event,
    Emitter<BleConnectionState> emit,
  ) async {
    await _repository.disconnect();
    emit(const BleConnectionState());
  }

  void _onLost(ConnectionLost event, Emitter<BleConnectionState> emit) {
    emit(const BleConnectionState());
  }

  void _onFailed(ConnectionFailed event, Emitter<BleConnectionState> emit) {
    emit(
      BleConnectionState(
        status: BleConnectionStatus.failure,
        errorMessage: event.message,
        device: state.device,
      ),
    );
  }

  Future<void> _onRssiRequested(
    ConnectionRssiRequested event,
    Emitter<BleConnectionState> emit,
  ) async {
    final rssi = await _repository.readRssi();
    if (rssi != null) {
      add(ConnectionRssiUpdated(rssi));
    }
  }

  void _onRssiUpdated(
    ConnectionRssiUpdated event,
    Emitter<BleConnectionState> emit,
  ) {
    emit(state.copyWith(rssi: event.rssi));
  }

  @override
  Future<void> close() async {
    await _connectedSub?.cancel();
    return super.close();
  }
}
