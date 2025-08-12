import 'dart:async';
import 'package:flutter/material.dart';
import '../controller/rename_file_controller.dart';
import '../widgets/rename_file_dropdown.dart';

class RenameFilePage extends StatefulWidget {
  const RenameFilePage({super.key});

  @override
  State<RenameFilePage> createState() => _RenameFilePageState();
}

class _RenameFilePageState extends State<RenameFilePage> {
  late final RenameFileController ctrl;
  final TextEditingController nameCtrl = TextEditingController();
  bool keepExt = true;

  @override
  void initState() {
    super.initState();
    ctrl = RenameFileController();

    unawaited(ctrl.init());
  }

  @override
  void dispose() {
    ctrl.dispose();
    nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rename File'),
        actions: [
          IconButton(
            tooltip: 'Ganti Folder',
            icon: const Icon(Icons.folder_open),
            onPressed: () => ctrl.pickAnotherFolder(),
          ),
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: () => ctrl.refreshFiles(),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: ctrl,
        builder: (context, _) {
          if (ctrl.loading && ctrl.files.isEmpty && ctrl.error == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (ctrl.error != null) {
            return _ErrorView(message: ctrl.error!, onRetry: () => ctrl.init());
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DirBanner(uri: ctrl.directoryUri),
                const SizedBox(height: 12),

                // Dropdown pilih file
                RenameFileDropdown(
                  files: ctrl.files,
                  value: ctrl.selected,
                  onChanged: (f) {
                    ctrl.select(f);
                    if (f != null) {
                      final base = (f.name ?? '').replaceFirst(
                        RegExp(r'\.[^.]+\$'),
                        '',
                      );
                      nameCtrl.text = base;
                    } else {
                      nameCtrl.clear();
                    }
                  },
                ),
                const SizedBox(height: 12),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: nameCtrl,
                        enabled: ctrl.selected != null,
                        decoration: const InputDecoration(
                          labelText: 'Nama baru',
                          hintText: 'contoh: report_harian',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      children: [
                        Switch(
                          value: keepExt,
                          onChanged: (v) => setState(() => keepExt = v),
                        ),
                        const Text('Pertahankan\nextensi'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                if (ctrl.selected != null)
                  _PreviewName(
                    keepExt: keepExt,
                    baseNameCtrl: nameCtrl,
                    sourceName: ctrl.selected!.name ?? '',
                  ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.drive_file_rename_outline),
                    label: const Text('Rename'),
                    onPressed: ctrl.loading ? null : _onRename,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _onRename() async {
    if (ctrl.selected == null) {
      _toast('Silakan pilih file.');
      return;
    }

    final input = nameCtrl.text.trim();
    if (input.isEmpty) {
      _toast('Nama baru tidak boleh kosong.');
      return;
    }

    final result = await ctrl.rename(input, keepExtension: keepExt);

    if (!mounted) return;

    if (result.ok) {
      _toast('Berhasil diubah ke: ${result.file?.name ?? '-'}');
      nameCtrl.clear();
    } else if (result.conflictingName != null) {
      _toast('Nama sudah ada: ${result.conflictingName}');
    } else if (result.message != null) {
      _toast(result.message!);
    }
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

class _DirBanner extends StatelessWidget {
  const _DirBanner({required this.uri});

  final String? uri;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.folder, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                uri == null ? 'Folder belum dipilih' : uri!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewName extends StatelessWidget {
  const _PreviewName({
    required this.keepExt,
    required this.baseNameCtrl,
    required this.sourceName,
  });

  final bool keepExt;
  final TextEditingController baseNameCtrl;
  final String sourceName;

  @override
  Widget build(BuildContext context) {
    final ext = _extractExtension(sourceName);
    final proposed =
        keepExt ? '${baseNameCtrl.text.trim()}$ext' : baseNameCtrl.text.trim();
    return Row(
      children: [
        const Icon(Icons.preview, size: 18),
        const SizedBox(width: 6),
        Text('Nama akhir: ', style: Theme.of(context).textTheme.bodyMedium),
        Flexible(
          child: Text(
            proposed.isEmpty ? '-' : proposed,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
      ],
    );
  }

  String _extractExtension(String name) {
    final dot = name.lastIndexOf('.');
    if (dot <= 0 || dot == name.length - 1) return '';
    return name.substring(dot);
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
