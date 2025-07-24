import 'package:flutter/material.dart';

PageRouteBuilder createSlideRoute(Widget page, {required Offset beginOffset}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const end = Offset.zero;
      const curve = Curves.ease;

      final tween = Tween(
        begin: beginOffset,
        end: end,
      ).chain(CurveTween(curve: curve));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}
