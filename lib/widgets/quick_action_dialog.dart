import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/configs_model.dart';
import '../models/quick_action_option.dart';
import 'option_card.dart';

class QuickActionsDialog extends StatelessWidget {
  final Widget? triggerWidget;
  final Offset triggerOffset;
  final Size triggerSize;
  final List<QuickActionOption> options;
  final VoidCallback? onTriggerTap;
  final QuickActionsConfig config;
  final bool dismissOnOptionTap;
  final Alignment? popupAlignment;

  const QuickActionsDialog({super.key,
    this.triggerWidget,
    required this.triggerOffset,
    required this.triggerSize,
    required this.options,
    this.onTriggerTap,
    required this.config,
    required this.dismissOnOptionTap,
    this.popupAlignment,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    // Calculate popup position
    double topPosition = triggerOffset.dy;
    double? leftPosition;
    double? rightPosition;

    if (popupAlignment != null) {
      // Use custom alignment if provided
      if (popupAlignment == Alignment.centerLeft || popupAlignment == Alignment.topLeft) {
        leftPosition = 12.0;
      } else if (popupAlignment == Alignment.centerRight || popupAlignment == Alignment.topRight) {
        rightPosition = 12.0;
      }
    } else {
      // Auto-align based on locale
      if (isRTL) {
        rightPosition = 12.0;
      } else {
        leftPosition = 12.0;
      }
    }

    return Stack(
      children: [
        // Backdrop with blur effect
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: config.blurSigma ?? 2.0,
              sigmaY: config.blurSigma ?? 2.0,
            ),
            child: Container(
              color: config.backdropColor ?? Colors.black.withOpacity(0.5),
            ),
          ),
        ),

        // Positioned popup content
        Positioned(
          top: topPosition,
          left: leftPosition,
          right: rightPosition,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Trigger widget (clickable) - only show if available
              if (triggerWidget != null)
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    if (onTriggerTap != null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        onTriggerTap!();
                      });
                    }
                  },
                  child: triggerWidget!,
                ),

              if (triggerWidget != null) const SizedBox(height: 8),

              // Options card
              if (options.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: OptionsCard(
                    options: options,
                    config: config,
                    dismissOnOptionTap: dismissOnOptionTap,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}