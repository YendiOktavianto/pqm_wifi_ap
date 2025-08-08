import 'package:flutter/material.dart';
import '../services/rename_file_service.dart';

class RenameFileController extends ChangeNotifier {
  final RenameFileService _service = RenameFileService();

  List<String> _fileList = [];

  List<String> get fileList => _fileList;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> loadFiles() async {
    _isLoading = true;
    notifyListeners();
    _fileList = await _service.getFiles();
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> renameFile(String oldName, String newName) async {
    final success = await _service.renameFile(oldName, newName);
    if (success) {
      await loadFiles(); // refresh file list
    }
    return success;
  }
}
