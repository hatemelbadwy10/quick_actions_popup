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



  // Estimate popup dimensions
  const double itemHeight = 48.0;
  const double popupPadding = 24.0;
  const double popupWidth = 200.0;
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
  double x = triggerOffset.dx;
  double y = triggerOffset.dy;

  // Horizontal positioning
  // Try to align popup to the right of trigger first
  if (x + popupSize.width > screenSize.width - padding.right) {
    // If popup goes off right edge, align to left of trigger
    x = triggerOffset.dx + triggerSize.width - popupSize.width;

    // If still off screen, clamp to screen edge
    if (x < padding.left) {
      x = padding.left;
    }
  }

  // Vertical positioning with priority to stay near trigger
  // First, try positioning below the trigger
  double belowY = triggerOffset.dy + triggerSize.height + 8.0; // 8px gap

  // Check if popup fits below
  if (belowY + popupSize.height <= screenSize.height - padding.bottom) {
    y = belowY;
  } else {
    // Try positioning above the trigger
    double aboveY = triggerOffset.dy - popupSize.height - 8.0; // 8px gap

    if (aboveY >= padding.top) {
      y = aboveY;
    } else {
      // If neither above nor below works, find the best vertical position
      // that shows the most content while staying near the trigger

      double spaceAbove = triggerOffset.dy - padding.top;
      double spaceBelow = screenSize.height - padding.bottom - (triggerOffset.dy + triggerSize.height);

      if (spaceBelow >= spaceAbove) {
        // More space below, position as low as possible while staying on screen
        y = screenSize.height - padding.bottom - popupSize.height;
      } else {
        // More space above, position at the top
        y = padding.top;
      }

      // Ensure we don't go off screen
      y = y.clamp(padding.top, screenSize.height - padding.bottom - popupSize.height);
    }
  }

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