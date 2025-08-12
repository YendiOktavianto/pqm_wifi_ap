import 'package:docman/docman.dart';

String extractExtension(String name) {
  final dot = name.lastIndexOf('.');
  if (dot <= 0 || dot == name.length - 1) return '';
  return name.substring(dot);
}

bool hasAnyExtension(String name) => name.contains('.') && !name.endsWith('.');

String sanitizeFileName(String name) {
  var n = name.trim();
  n = n.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
  if (n.length > 120) n = n.substring(0, 120);
  return n;
}

Future<DocumentFile?> findByName(DocumentFile dir, String name) async {
  final items = await dir.listDocuments();
  final target = name.toLowerCase();
  for (final it in items) {
    final itName = (it.name ?? '').toLowerCase();
    if (itName == target) return it;
  }
  return null;
}
