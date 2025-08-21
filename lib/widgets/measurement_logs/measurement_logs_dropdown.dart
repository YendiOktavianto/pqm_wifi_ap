import 'package:flutter/material.dart';

class MeasurementLogsDropdownClosed extends StatelessWidget {
  final double scale;
  final bool isLoading;
  final String? errorText;
  final String? selectedLabel;

  const MeasurementLogsDropdownClosed({
    super.key,
    required this.scale,
    required this.isLoading,
    required this.errorText,
    required this.selectedLabel,
  });

  @override
  Widget build(BuildContext context) {
    final border = Border.all(color: const Color(0xFF2E2E2E));
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(16 * scale),
        border: border,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16 * scale,
        vertical: 16 * scale,
      ),
      child: Row(
        children: [
          Expanded(
            child:
                (errorText != null)
                    ? Text(
                      errorText!,
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 16 * scale,
                      ),
                    )
                    : Text(
                      selectedLabel ?? 'Choose a log file',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16 * scale,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto',
                      ),
                    ),
          ),
          Container(
            width: 44 * scale,
            height: 44 * scale,
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1C),
              borderRadius: BorderRadius.circular(12 * scale),
              border: border,
            ),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white,
              size: 26 * scale,
            ),
          ),
        ],
      ),
    );
  }
}

class MeasurementLogsDropdownOverlay extends StatelessWidget {
  final double scale;
  final String title;
  final List<String> files;
  final VoidCallback onClose;
  final ValueChanged<String> onSelect;

  const MeasurementLogsDropdownOverlay({
    super.key,
    required this.scale,
    required this.title,
    required this.files,
    required this.onClose,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.35),
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24 * scale),
          padding: EdgeInsets.only(bottom: 10 * scale),
          decoration: BoxDecoration(
            color: const Color(0xFF222222),
            borderRadius: BorderRadius.circular(18 * scale),
            border: Border.all(color: const Color(0xFF2E2E2E)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header panel
              Padding(
                padding: EdgeInsets.fromLTRB(
                  16 * scale,
                  12 * scale,
                  8 * scale,
                  8 * scale,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18 * scale,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: onClose,
                      icon: Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 24 * scale,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 420 * scale),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(
                      horizontal: 12 * scale,
                      vertical: 8 * scale,
                    ),
                    itemBuilder: (context, i) {
                      final name = files[i];
                      return InkWell(
                        onTap: () => onSelect(name),
                        borderRadius: BorderRadius.circular(12 * scale),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14 * scale,
                            vertical: 14 * scale,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF303030),
                            borderRadius: BorderRadius.circular(12 * scale),
                          ),
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15 * scale,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => SizedBox(height: 10 * scale),
                    itemCount: files.length,
                  ),
                ),
              ),
              SizedBox(height: 6 * scale),
              TextButton(
                onPressed: onClose,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8 * scale),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: const Color(0xFFBDBDBD),
                      fontSize: 16 * scale,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
