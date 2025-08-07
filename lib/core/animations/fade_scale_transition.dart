import 'package:flutter/material.dart';

Widget fadeScaleTransition(Animation<double> anim, Widget child) {
  return FadeTransition(
    opacity: anim,
    child: ScaleTransition(
      scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
      child: child,
    ),
  );
}
