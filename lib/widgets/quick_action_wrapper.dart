import 'package:flutter/material.dart';
import 'package:popup_quick_actions/popup_quick_actions.dart';

import '../models/configs_model.dart';
import '../models/quick_action_option.dart';
class QuickActionsWrapper extends StatelessWidget {
  final Widget child;
  final List<QuickActionOption> options;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final QuickActionsConfig? config;
  final bool dismissOnOptionTap;
  final bool barrierDismissible;
  final Alignment? popupAlignment;
  final bool showTriggerInPopup;

  const QuickActionsWrapper({
    super.key,
    required this.child,
    required this.options,
    this.onTap,
    this.onLongPress,
    this.config,
    this.dismissOnOptionTap = true,
    this.barrierDismissible = true,
    this.popupAlignment,
    this.showTriggerInPopup = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () {
        if (onLongPress != null) {
          onLongPress!();
        }

        // Show quick actions popup
        context.showQuickActions(
          triggerWidget: showTriggerInPopup ? child : null,
          options: options,
          onTriggerTap: onTap,
          config: config,
          dismissOnOptionTap: dismissOnOptionTap,
          barrierDismissible: barrierDismissible,
          popupAlignment: popupAlignment,
        );
      },
      child: child,
    );
  }
}
