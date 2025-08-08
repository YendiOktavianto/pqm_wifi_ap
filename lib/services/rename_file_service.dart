import 'dart:io';
import 'package:path_provider/path_provider.dart';

class RenameFileService {
  Future<List<String>> getFiles() async {
    final dir = await getApplicationDocumentsDirectory();
    final files =
        Directory(dir.path)
            .listSync()
            .whereType<File>()
            .map((file) => file.path.split(Platform.pathSeparator).last)
            .toList();
    return files;
  }

  Future<bool> renameFile(String oldName, String newName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final oldPath = '${dir.path}${Platform.pathSeparator}$oldName';
      final newPath = '${dir.path}${Platform.pathSeparator}$newName';
      final oldFile = File(oldPath);

      if (await oldFile.exists()) {
        await oldFile.rename(newPath);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
