import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../ble/ble_repository.dart';
import '../ble/models/ble_device_item.dart';
import 'scan_event.dart';
import 'scan_state.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  ScanBloc(this._repository) : super(const ScanState()) {
    on<ScanStarted>(_onStarted);
    on<ScanStopped>(_onStopped);
    on<ScanResultsUpdated>(_onResultsUpdated);
    on<ScanFailed>(_onFailed);
  }

  final BleRepository _repository;
  StreamSubscription<List<BleDeviceItem>>? _scanSubscription;

  Future<void> _onStarted(
    ScanStarted event,
    Emitter<ScanState> emit,
  ) async {
    try {
      await _repository.ensurePermissions();
      await _scanSubscription?.cancel();
      _scanSubscription = _repository.scanResults.listen(
        (devices) => add(ScanResultsUpdated(devices)),
        onError: (Object e) => add(ScanFailed(e.toString())),
      );
      await _repository.startScan();
      emit(
        state.copyWith(
          status: ScanStatus.scanning,
          clearError: true,
        ),
      );
    } catch (e) {
      add(ScanFailed(e.toString()));
    }
  }

  Future<void> _onStopped(
    ScanStopped event,
    Emitter<ScanState> emit,
  ) async {
    await _scanSubscription?.cancel();
    _scanSubscription = null;
    await _repository.stopScan();
    emit(state.copyWith(status: ScanStatus.idle));
  }

  void _onResultsUpdated(
    ScanResultsUpdated event,
    Emitter<ScanState> emit,
  ) {
    emit(
      state.copyWith(
        devices: event.devices,
        status: ScanStatus.scanning,
      ),
    );
  }

  void _onFailed(ScanFailed event, Emitter<ScanState> emit) {
    emit(
      state.copyWith(
        status: ScanStatus.failure,
        errorMessage: event.message,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _scanSubscription?.cancel();
    return super.close();
  }
}
