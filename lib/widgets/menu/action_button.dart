import 'package:flutter/material.dart';
import '../../core/animations/slide_route.dart';

class ActionButton extends StatelessWidget {
  final String title;
  final Color color;
  final Widget? page;
  final Offset beginOffset;

  const ActionButton({
    required this.title,
    required this.color,
    required this.page,
    required this.beginOffset,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (page != null) {
          Navigator.pushReplacement(
            context,
            createSlideRoute(page!, beginOffset: beginOffset),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }
}
