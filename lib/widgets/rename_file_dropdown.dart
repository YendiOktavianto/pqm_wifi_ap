import 'package:flutter/material.dart';

class RenameFileDropdown extends StatelessWidget {
  final List<String> files;
  final String? selectedFile;
  final void Function(String?)? onChanged;

  const RenameFileDropdown({
    super.key,
    required this.files,
    required this.selectedFile,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      isExpanded: true,
      value: selectedFile,
      hint: const Text("Pilih file"),
      items:
          files.map((file) {
            return DropdownMenuItem<String>(value: file, child: Text(file));
          }).toList(),
      onChanged: onChanged,
    );
  }
}
