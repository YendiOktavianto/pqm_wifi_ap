import 'package:flutter/material.dart';
import '../../core/animations/slide_route.dart';

class MenuButton extends StatelessWidget {
  final String title;
  final String iconPath;
  final Widget? page;
  final VoidCallback? onTap;
  final Offset? transitionOffset;

  const MenuButton({
    required this.title,
    required this.iconPath,
    this.page,
    this.onTap,
    this.transitionOffset,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        onPressed: () {
          if (onTap != null) {
            onTap!();
          } else if (page != null) {
            if (transitionOffset != null) {
              Navigator.push(
                context,
                createSlideRoute(
                  page!,
                  beginOffset: transitionOffset!,
                ),
              );
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (_) => page!));
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[900],
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            Image.asset(iconPath, width: 28, height: 28, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
