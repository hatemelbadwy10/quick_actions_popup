import 'package:flutter/material.dart';
import 'package:popup_quick_actions/widgets/quick_action_dialog.dart';
import 'models/configs_model.dart';
import 'models/quick_action_option.dart';

/// Main function to show the iOS-style quick actions popup
void showIOSQuickActions({
  required BuildContext context,
  Widget? triggerWidget,
  required List<QuickActionOption> options,
  VoidCallback? onTriggerTap,
  QuickActionsConfig? config,
  bool dismissOnOptionTap = true,
  bool barrierDismissible = true,
  Alignment? popupAlignment,
}) {
  final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
  if (renderBox == null) return;

  final Offset triggerOffset = renderBox.localToGlobal(Offset.zero);
  final Size triggerSize = renderBox.size;

  // Get screen dimensions
  final MediaQueryData mediaQuery = MediaQuery.of(context);
  final Size screenSize = mediaQuery.size;
  final EdgeInsets padding = mediaQuery.padding;

  // Use trigger width for popup width (this is the key change!)
  final double popupWidth = triggerSize.width;

  // Estimate popup height based on options
  const double itemHeight = 48.0;
  const double popupPadding = 24.0;
  final double popupHeight = (options.length * itemHeight) + popupPadding;

  // Calculate the best position for the popup
  Offset adjustedOffset = _calculateOptimalPosition(
    triggerOffset: triggerOffset,
    triggerSize: triggerSize,
    popupSize: Size(popupWidth, popupHeight),
    screenSize: screenSize,
    padding: padding,
  );

  final effectiveConfig = config ?? const QuickActionsConfig();

  showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: Colors.transparent,
    builder: (dialogContext) {
      return QuickActionsDialog(
        triggerWidget: triggerWidget,
        triggerOffset: adjustedOffset,
        triggerSize: triggerSize,
        options: options,
        onTriggerTap: onTriggerTap,
        config: effectiveConfig,
        dismissOnOptionTap: dismissOnOptionTap,
        popupAlignment: popupAlignment,
      );
    },
  );
}

Offset _calculateOptimalPosition({
  required Offset triggerOffset,
  required Size triggerSize,
  required Size popupSize,
  required Size screenSize,
  required EdgeInsets padding,
}) {
  // Calculate available space
  final double availableHeight = screenSize.height - padding.top - padding.bottom;

  // Ensure popup height fits within available space
  final double clampedPopupHeight = popupSize.height.clamp(0.0, availableHeight);

  // Horizontal positioning: Always align with trigger's left edge
  // This makes the popup have the same width and position as the trigger
  double x = triggerOffset.dx;

  // Vertical positioning logic
  double y = triggerOffset.dy;
  const double gap = 8.0;

  // Calculate spaces available above and below trigger
  final double spaceAbove = triggerOffset.dy - padding.top;
  final double spaceBelow = screenSize.height - padding.bottom - (triggerOffset.dy + triggerSize.height);

  // Try positioning below first (preferred)
  final double belowY = triggerOffset.dy + triggerSize.height + gap;
  if (spaceBelow >= clampedPopupHeight + gap) {
    y = belowY;
  }
  // Try positioning above
  else if (spaceAbove >= clampedPopupHeight + gap) {
    y = triggerOffset.dy - clampedPopupHeight - gap;
  }
  // If neither fits perfectly, choose the side with more space
  else {
    if (spaceBelow >= spaceAbove) {
      // Position below, but clamp to screen
      y = (screenSize.height - padding.bottom - clampedPopupHeight).clamp(
          belowY,
          screenSize.height - padding.bottom - clampedPopupHeight
      );
    } else {
      // Position above, but clamp to screen
      y = (triggerOffset.dy - clampedPopupHeight - gap).clamp(
          padding.top,
          triggerOffset.dy - gap
      );
    }
  }

  // Final safety clamp for vertical position only
  y = y.clamp(padding.top, screenSize.height - padding.bottom - clampedPopupHeight);

  return Offset(x, y);
}

// Extension method for easier usage
extension QuickActionsExtension on BuildContext {
  void showQuickActions({
    Widget? triggerWidget,
    required List<QuickActionOption> options,
    VoidCallback? onTriggerTap,
    QuickActionsConfig? config,
    bool dismissOnOptionTap = true,
    bool barrierDismissible = true,
    Alignment? popupAlignment,
    bool autoCaptureTrigger = true,
  }) {
    showIOSQuickActions(
      context: this,
      triggerWidget: triggerWidget,
      options: options,
      onTriggerTap: onTriggerTap,
      config: config,
      dismissOnOptionTap: dismissOnOptionTap,
      barrierDismissible: barrierDismissible,
      popupAlignment: popupAlignment,
    );
  }
}