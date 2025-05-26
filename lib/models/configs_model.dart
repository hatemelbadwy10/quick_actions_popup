import 'package:flutter/material.dart';

/// Configuration class for customizing the popup appearance
class QuickActionsConfig {
  final double? cardWidth;
  final double? iconSize;
  final double? fontSize;
  final double? optionSpacing;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? backdropColor;
  final double? blurSigma;
  final TextStyle? textStyle;
  final MainAxisAlignment? optionsAlignment;
  final CrossAxisAlignment? optionsCrossAlignment;

  const QuickActionsConfig({
    this.cardWidth,
    this.iconSize,
    this.fontSize,
    this.optionSpacing,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.backdropColor,
    this.blurSigma,
    this.textStyle,
    this.optionsAlignment,
    this.optionsCrossAlignment,
  });
}