import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ffi_bloc_app/ble/ble_repository.dart';
import 'package:ffi_bloc_app/ble/models/ble_device_item.dart';
import 'package:ffi_bloc_app/scan/scan_bloc.dart';
import 'package:ffi_bloc_app/scan/scan_event.dart';
import 'package:ffi_bloc_app/scan/scan_state.dart';

class _FakeBleRepository implements BleRepository {
  final _results = StreamController<List<BleDeviceItem>>.broadcast();
  final _scanning = StreamController<bool>.broadcast();
  final _connected = StreamController<BleDeviceItem?>.broadcast();

  @override
  Stream<List<BleDeviceItem>> get scanResults => _results.stream;

  @override
  Stream<bool> get isScanning => _scanning.stream;

  @override
  Stream<BleDeviceItem?> get connectedDevice => _connected.stream;

  @override
  Future<void> ensurePermissions() async {}

  @override
  Future<void> startScan() async {
    _scanning.add(true);
    _results.add(const [
      BleDeviceItem(id: 'aa:bb', name: 'Demo', rssi: -55),
    ]);
  }

  @override
  Future<void> stopScan() async {
    _scanning.add(false);
  }

  @override
  Future<void> connect(BleDeviceItem device) async {}

  @override
  Future<void> disconnect() async {}

  @override
  Future<int?> readRssi() async => -60;
}

void main() {
  late _FakeBleRepository repository;

  setUp(() {
    repository = _FakeBleRepository();
  });

  blocTest<ScanBloc, ScanState>(
    'emits scanning then devices when scan starts',
    build: () => ScanBloc(repository),
    act: (bloc) => bloc.add(const ScanStarted()),
    wait: const Duration(milliseconds: 50),
    expect: () => [
      isA<ScanState>().having((s) => s.status, 'status', ScanStatus.scanning),
      isA<ScanState>()
          .having((s) => s.devices.length, 'devices', 1)
          .having((s) => s.devices.first.name, 'name', 'Demo'),
    ],
  );
}
