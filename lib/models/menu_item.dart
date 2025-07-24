import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final String iconPath;
  final Widget? page;
  final VoidCallback? onTap;

  MenuItem({
    required this.title,
    required this.iconPath,
    this.page,
    this.onTap,
  });
}
