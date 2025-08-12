import 'package:flutter/material.dart';
import 'package:docman/docman.dart';

class RenameFileDropdown extends StatelessWidget {
  const RenameFileDropdown({
    super.key,
    required this.files,
    required this.value,
    required this.onChanged,
    this.label = 'Pilih file',
    this.enabled = true,
  });

  final List<DocumentFile> files;

  final DocumentFile? value;

  final ValueChanged<DocumentFile?> onChanged;

  final String label;

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (files.isEmpty) {
      return InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
        child: Text(
          'File empty',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.disabledColor,
          ),
        ),
      );
    }

    final currentValue =
        value != null && files.any((f) => f.uri == value!.uri)
            ? files.firstWhere((f) => f.uri == value!.uri)
            : null;

    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DocumentFile>(
          isExpanded: true,
          value: currentValue,
          items:
              files
                  .map(
                    (f) => DropdownMenuItem<DocumentFile>(
                      value: f,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.insert_drive_file_outlined,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              f.name ?? '(untitled)',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _MetaBadge(
                            size: _fmtSize(f.size),
                            modified: _fmtModified(f.lastModified),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
          onChanged: enabled ? onChanged : null,
        ),
      ),
    );
  }

  String _fmtSize(int? bytes) {
    if (bytes == null || bytes <= 0) return '-';
    const kb = 1024;
    const mb = 1024 * 1024;
    if (bytes >= mb) return '${(bytes / mb).toStringAsFixed(2)} MB';
    if (bytes >= kb) return '${(bytes / kb).toStringAsFixed(1)} KB';
    return '$bytes B';
  }

  String _fmtModified(int? epochMs) {
    if (epochMs == null || epochMs <= 0) return '';
    final dt = DateTime.fromMillisecondsSinceEpoch(epochMs);
    two(int n) => n.toString().padLeft(2, '0');
    return '${two(dt.day)}/${two(dt.month)}/${dt.year} ${two(dt.hour)}:${two(dt.minute)}';
  }
}

class _MetaBadge extends StatelessWidget {
  const _MetaBadge({required this.size, required this.modified});

  final String size;
  final String modified;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall;
    final text = [size, if (modified.isNotEmpty) modified].join(' • ');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: style),
    );
  }
}
