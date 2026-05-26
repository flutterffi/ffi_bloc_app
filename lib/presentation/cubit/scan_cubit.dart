import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ble/ble_repository.dart';
import '../../ble/models/ble_device_item.dart';
import '../state/scan_state.dart';

/// Method-driven scan controller (Cubit / MVVM-style ViewModel).
class ScanCubit extends Cubit<ScanState> {
  ScanCubit(this._repository) : super(const ScanState());

  final BleRepository _repository;
  StreamSubscription<List<BleDeviceItem>>? _scanSubscription;

  Future<void> startScan() async {
    try {
      await _repository.ensurePermissions();
      await _scanSubscription?.cancel();
      _scanSubscription = _repository.scanResults.listen(
        (devices) => emit(
          state.copyWith(
            devices: devices,
            status: ScanStatus.scanning,
            clearError: true,
          ),
        ),
        onError: (Object e) => emit(
          state.copyWith(
            status: ScanStatus.failure,
            errorMessage: e.toString(),
          ),
        ),
      );
      await _repository.startScan();
      emit(
        state.copyWith(
          status: ScanStatus.scanning,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ScanStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> stopScan() async {
    await _scanSubscription?.cancel();
    _scanSubscription = null;
    await _repository.stopScan();
    emit(state.copyWith(status: ScanStatus.idle));
  }

  @override
  Future<void> close() async {
    await _scanSubscription?.cancel();
    return super.close();
  }
}
