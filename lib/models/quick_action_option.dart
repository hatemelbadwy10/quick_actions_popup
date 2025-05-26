import 'package:flutter/material.dart';

/// Model class for defining each quick action option
class QuickActionOption {
  final String label;
  final IconData icon;
  final Color? iconColor;
  final Color? textColor;
  final VoidCallback onTap;

  const QuickActionOption({
    required this.label,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });
}