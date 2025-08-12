import 'package:docman/docman.dart';

class RenameResult {
  final bool ok;
  final String? message;
  final String? conflictingName;
  final DocumentFile? file;

  const RenameResult._(
    this.ok, {
    this.message,
    this.conflictingName,
    this.file,
  });

  factory RenameResult.success(DocumentFile file) =>
      RenameResult._(true, file: file);

  factory RenameResult.partial(DocumentFile file, String msg) =>
      RenameResult._(true, file: file, message: msg);

  factory RenameResult.conflict(String name) =>
      RenameResult._(false, conflictingName: name);

  factory RenameResult.error(String msg) => RenameResult._(false, message: msg);
}
