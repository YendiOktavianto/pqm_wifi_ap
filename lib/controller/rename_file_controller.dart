import 'package:flutter/foundation.dart';
import 'package:docman/docman.dart';

import '../services/rename_file_service.dart';
import '../models/rename_result.dart';

class RenameFileController extends ChangeNotifier {
  RenameFileController({List<String>? filterExtensions})
    : _filterExtensions = filterExtensions;

  final RenameFileService _svc = RenameFileService();
  final List<String>? _filterExtensions;

  bool _loading = false;
  String? _error;
  String? _directoryUri;
  List<DocumentFile> _files = const [];
  DocumentFile? _selected;

  // --- Getters untuk UI ---
  bool get loading => _loading;

  String? get error => _error;

  String? get directoryUri => _directoryUri;

  List<DocumentFile> get files => _files;

  DocumentFile? get selected => _selected;

  Future<void> init() async {
    _setLoading(true);
    _error = null;
    try {
      final dir = await _svc.ensureDocumentsAccess();
      _directoryUri = dir.uri;
      await refreshFiles();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshFiles() async {
    _error = null;
    try {
      _files = await _svc.listFiles(extensions: _filterExtensions);

      if (_selected != null && !_files.any((f) => f.uri == _selected!.uri)) {
        _selected = null;
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void select(DocumentFile? file) {
    _selected = file;
    notifyListeners();
  }

  Future<RenameResult> rename(
    String newName, {
    bool keepExtension = true,
  }) async {
    final target = _selected;
    if (target == null) {
      return RenameResult.error('Pilih file terlebih dahulu.');
    }

    _setLoading(true);
    try {
      final result = await _svc.rename(
        file: target,
        newName: newName,
        keepExtension: keepExtension,
      );

      if (result.ok) {
        await refreshFiles();

        if (result.file != null) {
          _selected = _files.firstWhere(
            (f) => f.uri == result.file!.uri,
            orElse: () => result.file!,
          );
        }
      }

      return result;
    } catch (e) {
      return RenameResult.error('Gagal mengganti nama: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> pickAnotherFolder() async {
    _setLoading(true);
    try {
      await _svc.changeFolder();
      final dir = await _svc.ensureDocumentsAccess();
      _directoryUri = dir.uri;
      await refreshFiles();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }
}
