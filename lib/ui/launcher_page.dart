import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../ble/ble_repository.dart';
import 'shell/bloc_mode_shell.dart';
import 'shell/cubit_mode_shell.dart';

/// Pick Bloc (Event) or Cubit (method) presentation — same BLE repository.
class LauncherPage extends StatelessWidget {
  const LauncherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FFI Bloc App')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Same MVVM layers: View → ViewModel → Repository. '
            'Compare how scan/connect are expressed.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          _ModeCard(
            title: 'Bloc (Event)',
            subtitle:
                'ScanStarted / ConnectionConnectRequested — explicit intents, blocTest by events.',
            icon: Icons.hub_outlined,
            color: Colors.indigo,
            onTap: () => _open(context, const BlocModeShell()),
          ),
          const SizedBox(height: 12),
          _ModeCard(
            title: 'Cubit (Method)',
            subtitle:
                'startScan() / connect() — MVVM-style methods, same ScanState / BleConnectionState.',
            icon: Icons.tune,
            color: Colors.deepPurple,
            onTap: () => _open(context, const CubitModeShell()),
          ),
          const SizedBox(height: 24),
          Text(
            'Riverpod variant: ffi_riverpod_app repo (Notifier + ProviderScope).',
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }

  void _open(BuildContext context, Widget shell) {
    final repository = context.read<BleRepository>();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RepositoryProvider<BleRepository>.value(
          value: repository,
          child: shell,
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withValues(alpha: 0.15),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(subtitle),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
