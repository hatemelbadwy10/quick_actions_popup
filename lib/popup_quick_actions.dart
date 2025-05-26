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
  // Get the position of the trigger widget
  final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
  if (renderBox == null) return;

  final Offset triggerOffset = renderBox.localToGlobal(Offset.zero);
  final Size triggerSize = renderBox.size;

  // Default configuration
  final effectiveConfig = config ?? const QuickActionsConfig();

  showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: Colors.transparent,
    builder: (dialogContext) {
      return QuickActionsDialog(
        triggerWidget: triggerWidget,
        triggerOffset: triggerOffset,
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