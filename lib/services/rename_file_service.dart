import 'dart:async';

import 'package:docman/docman.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/rename_result.dart';
import '../utils/file_helper.dart';

class RenameFileService {
  RenameFileService._();

  static final RenameFileService _instance = RenameFileService._();
  factory RenameFileService() => _instance;
  static const _kDirUriKey = 'pqm_documents_tree_uri';

  DocumentFile? _documentsDir;

  Future<DocumentFile> ensureDocumentsAccess({bool forcePick = false}) async {
    if (!forcePick) {
      final saved = await _readSavedDirUri();
      if (saved != null) {
        final dir = await DocumentFile.fromUri(saved);
        if (dir != null && (await dir.exists) == true && dir.isDirectory == true) {
          _documentsDir = dir;
          return dir;
        }
      }
    }

    final DocumentFile? picked = await DocMan.pick.directory(
      initDir: 'content://com.android.externalstorage.documents/document/primary%3ADocuments',
    );
    if (picked == null) {
      throw Exception('Pemilihan folder dibatalkan.');
    }

    await _saveDirUri(picked.uri);
    _documentsDir = picked;
    return picked;
  }

  Future<DocumentFile> _getDir() async =>
      _documentsDir ?? await ensureDocumentsAccess();

  Future<List<DocumentFile>> listFiles({List<String>? extensions}) async {
    final dir = await _getDir();
    final List<DocumentFile> files = extensions == null
        ? await dir.listDocuments()
        : await dir.listDocuments(extensions: extensions);

    files.sort((a, b) => ((b.lastModified ?? 0) - (a.lastModified ?? 0)));
    return files;
  }

  Future<RenameResult> rename({
    required DocumentFile file,
    required String newName,
    bool keepExtension = true,
  }) async {
    final dir = await _getDir();

    final String currentName = file.name;
    final String ext = extractExtension(currentName);
    final String targetName = sanitizeFileName(
      keepExtension && !hasAnyExtension(newName) ? '$newName$ext' : newName,
    );

    final existing = await findByName(dir, targetName);
    if (existing != null) {
      return RenameResult.conflict(targetName);
    }

    try {
      final moved = await file.moveTo((await _getDir()).uri, name: targetName);
      if (moved != null) {
        return RenameResult.success(moved);
      }

      final copied = await file.copyTo(dir.uri, name: targetName);
      if (copied == null) {
        return RenameResult.error('Gagal menyalin berkas.');
      }

      final deleted = await file.delete();
      if (!deleted) {
        return RenameResult.partial(copied, 'Salin berhasil, namun gagal menghapus berkas lama.');
      }

      return RenameResult.success(copied);
    } catch (e) {
      return RenameResult.error('Gagal mengganti nama: $e');
    }
  }

  Future<void> changeFolder() async {
    await ensureDocumentsAccess(forcePick: true);
  }

  Future<String?> _readSavedDirUri() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kDirUriKey);
  }

  Future<void> _saveDirUri(String uri) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kDirUriKey, uri);
  }


}
