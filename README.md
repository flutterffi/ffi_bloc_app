# ffi_bloc_app

Bluetooth LE sample app for **flutterffi**, built with **flutter_bloc** and **flutter_blue_plus**.

Demonstrates a production-style layering: repository (data) → blocs (domain/UI state) → widgets (presentation).

## Features

- Scan nearby BLE peripherals (15s timeout, deduped by device id, sorted by RSSI)
- Connect / disconnect with connection-state feedback
- Read live RSSI while connected
- Runtime permission handling (Android 12+ / iOS)

## Architecture

```text
lib/
├── ble/                    # Data layer
│   ├── ble_repository.dart           # abstract contract
│   ├── flutter_blue_ble_repository.dart
│   └── models/ble_device_item.dart
├── scan/                   # ScanBloc + events/states
├── connection/             # ConnectionBloc + events/states
├── ui/pages/               # HomePage, DevicePage
├── app.dart
└── main.dart
```

| Layer | Responsibility |
|-------|----------------|
| `BleRepository` | BLE scan/connect; hides `flutter_blue_plus` |
| `ScanBloc` | Scan lifecycle, device list |
| `ConnectionBloc` | Connect, disconnect, RSSI |
| UI | `BlocBuilder` / `BlocConsumer` only |

## Requirements

- Flutter 3.16+ (SDK ^3.11 in `pubspec.yaml`)
- Physical device with BLE (simulators have limited BLE support)

## Getting started

```bash
flutter pub get
flutter run
```

## Tests

```bash
flutter test
flutter analyze
```

## Permissions

- **Android**: `BLUETOOTH_SCAN`, `BLUETOOTH_CONNECT`, `ACCESS_FINE_LOCATION` (see `AndroidManifest.xml`)
- **iOS**: `NSBluetoothAlwaysUsageDescription` in `Info.plist`

## License

MIT — see [LICENSE](LICENSE).
