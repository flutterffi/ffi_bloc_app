import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ffi_bloc_app/ble/ble_repository.dart';
import 'package:ffi_bloc_app/ble/models/ble_device_item.dart';
import 'package:ffi_bloc_app/presentation/cubit/scan_cubit.dart';
import 'package:ffi_bloc_app/presentation/state/scan_state.dart';

class _FakeBleRepository implements BleRepository {
  final _results = StreamController<List<BleDeviceItem>>.broadcast();

  @override
  Stream<List<BleDeviceItem>> get scanResults => _results.stream;

  @override
  Stream<bool> get isScanning => const Stream.empty();

  @override
  Stream<BleDeviceItem?> get connectedDevice => const Stream.empty();

  @override
  Future<void> ensurePermissions() async {}

  @override
  Future<void> startScan() async {
    _results.add(const [
      BleDeviceItem(id: 'aa:bb', name: 'Demo', rssi: -55),
    ]);
  }

  @override
  Future<void> stopScan() async {}

  @override
  Future<void> connect(BleDeviceItem device) async {}

  @override
  Future<void> disconnect() async {}

  @override
  Future<int?> readRssi() async => -60;
}

void main() {
  late _FakeBleRepository repository;

  setUp(() => repository = _FakeBleRepository());

  blocTest<ScanCubit, ScanState>(
    'emits scanning then devices when startScan',
    build: () => ScanCubit(repository),
    act: (cubit) => cubit.startScan(),
    wait: const Duration(milliseconds: 50),
    expect: () => [
      isA<ScanState>()
          .having((s) => s.status, 'status', ScanStatus.scanning)
          .having((s) => s.devices.length, 'devices', 1)
          .having((s) => s.devices.first.name, 'name', 'Demo'),
    ],
  );
}
