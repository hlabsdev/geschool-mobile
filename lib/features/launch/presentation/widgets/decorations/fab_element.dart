import 'package:flutter/material.dart';

class FabElement {
  final String tooltip;
  final IconData icon;
  final Color backgroundColor;
  final Color forgroundColor;
  final void Function() onPressed;
  const FabElement({
    this.tooltip,
    this.icon,
    this.backgroundColor,
    this.forgroundColor,
    this.onPressed,
  });
}
