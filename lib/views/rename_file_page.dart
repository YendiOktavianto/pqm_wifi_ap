import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/rename_file_controller.dart';
import '../widgets/rename_file_dropdown.dart';

class RenameFilePage extends StatefulWidget {
  const RenameFilePage({super.key});

  @override
  State<RenameFilePage> createState() => _RenameFilePageState();
}

class _RenameFilePageState extends State<RenameFilePage> {
  String? _selectedFile;
  final TextEditingController _newNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          Provider.of<RenameFileController>(context, listen: false).loadFiles(),
    );
  }

  void _renameFile(BuildContext context) async {
    final controller = Provider.of<RenameFileController>(
      context,
      listen: false,
    );
    final newName = _newNameController.text.trim();

    if (_selectedFile == null || newName.isEmpty) return;

    final result = await controller.renameFile(_selectedFile!, newName);

    if (!mounted) return;
    if (result) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('File berhasil di-rename')));
      _newNameController.clear();
      setState(() => _selectedFile = null);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengganti nama file')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RenameFileController(),
      child: Consumer<RenameFileController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Rename File'),
              backgroundColor: Colors.black,
            ),
            backgroundColor: Colors.black,
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  RenameFileDropdown(
                    files: controller.fileList,
                    selectedFile: _selectedFile,
                    onChanged: (val) {
                      setState(() {
                        _selectedFile = val;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _newNameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: "Nama file baru",
                      labelStyle: TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        controller.isLoading
                            ? null
                            : () => _renameFile(context),
                    child:
                        controller.isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Rename'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
