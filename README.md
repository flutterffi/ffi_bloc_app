# ffi_bloc_app

Bluetooth LE sample for **flutterffi** — **Bloc (Event)** and **Cubit (Method)** in one repo, sharing the same `BleRepository` and state models.

Compare with [ffi_riverpod_app](https://github.com/flutterffi/ffi_riverpod_app) (Riverpod Notifier) and the [three-way interview topic](https://github.com/flutterffi/flutter_interview/blob/main/topics/bloc-riverpod-ble.md).

## Modes in the app

| Mode | Entry on launcher | Presentation |
|------|-------------------|--------------|
| **Bloc (Event)** | “Bloc (Event)” card | `ScanBloc` / `ConnectionBloc` + `add(Event)` |
| **Cubit (Method)** | “Cubit (Method)” card | `ScanCubit` / `ConnectionCubit` + `startScan()` / `connect()` |

Both map to **MVVM**: View → ViewModel role (Bloc/Cubit) → Repository → `flutter_blue_plus`.

## Project layout

```text
lib/
├── ble/                          # Shared data layer
├── presentation/
│   ├── state/                    # Shared ScanState, BleConnectionState
│   ├── bloc/                     # Event-driven
│   └── cubit/                    # Method-driven
└── ui/
    ├── launcher_page.dart
    ├── shell/                    # Provider trees per mode
    ├── bloc/                     # Bloc-specific pages
    ├── cubit/                    # Cubit-specific pages
    └── widgets/                  # Shared UI (banner, list, detail)
```

## Run

```bash
flutter pub get
flutter run
```

Use a **physical device** for BLE.

## Tests

```bash
flutter test    # scan_bloc_test + scan_cubit_test
flutter analyze
```

## License

MIT — see [LICENSE](LICENSE).
