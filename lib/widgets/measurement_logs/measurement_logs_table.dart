import 'package:flutter/material.dart';

class MeasurementLogsTable extends StatelessWidget {
  final double scale;
  final List<String> headers;
  final List<List<String>> rows;

  const MeasurementLogsTable({
    super.key,
    required this.scale,
    required this.headers,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    final containerBorder = Border.all(color: const Color(0xFF2E2E2E));
    final cellBorder = Border.all(color: const Color(0xFF3A3A3A), width: 1);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF181818),
        borderRadius: BorderRadius.circular(16 * scale),
        border: containerBorder,
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 10 * scale,
              horizontal: 12 * scale,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF232323),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16 * scale),
                topRight: Radius.circular(16 * scale),
              ),
            ),
            child: Row(
              children: [
                for (int i = 0; i < headers.length; i++)
                  Expanded(
                    flex: _flexFor(i, headers.length),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 6 * scale,
                        horizontal: 8 * scale,
                      ),
                      decoration: BoxDecoration(border: cellBorder),
                      child: Text(
                        headers[i].toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12 * scale,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Rows
          Expanded(
            child:
                rows.isEmpty
                    ? Center(
                      child: Text(
                        'No table data.',
                        style: TextStyle(
                          color: const Color(0xFFBDBDBD),
                          fontSize: 14 * scale,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    )
                    : ListView.separated(
                      padding: EdgeInsets.symmetric(
                        vertical: 6 * scale,
                        horizontal: 12 * scale,
                      ),
                      itemCount: rows.length,
                      separatorBuilder: (_, __) => SizedBox(height: 6 * scale),
                      itemBuilder: (_, idx) {
                        final r = rows[idx];
                        return Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF222222),
                            borderRadius: BorderRadius.circular(10 * scale),
                          ),
                          child: Row(
                            children: [
                              for (
                                int i = 0;
                                i < headers.length && i < r.length;
                                i++
                              )
                                Expanded(
                                  flex: _flexFor(i, headers.length),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12 * scale,
                                      horizontal: 10 * scale,
                                    ),
                                    decoration: BoxDecoration(
                                      border: cellBorder,
                                    ),
                                    child: _cellText(i, r[i], scale),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  int _flexFor(int i, int total) {
    if (total == 5) {
      switch (i) {
        case 0:
          return 4;
        case 4:
          return 3;
        default:
          return 2;
      }
    }
    return 2;
  }

  Widget _cellText(int colIndex, String text, double scale) {
    if (colIndex == 4) {
      final up = text.toUpperCase();
      final isPass = up.contains('PASS');
      final isFail = up.contains('FAIL');
      final color =
          isPass
              ? const Color(0xFF43A047)
              : isFail
              ? const Color(0xFFE53935)
              : Colors.white;
      return Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 13 * scale,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto',
        ),
      );
    }
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 13 * scale,
        fontWeight: FontWeight.w500,
        fontFamily: 'Roboto',
      ),
    );
  }
}
