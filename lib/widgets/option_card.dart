import 'package:flutter/material.dart';

import '../models/configs_model.dart';
import '../models/quick_action_option.dart';

class OptionsCard extends StatelessWidget {
  final List<QuickActionOption> options;
  final QuickActionsConfig config;
  final bool dismissOnOptionTap;

  const OptionsCard({super.key,
    required this.options,
    required this.config,
    required this.dismissOnOptionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: config.cardWidth ?? 200,
      padding: config.padding ?? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: config.backgroundColor ?? Colors.white,
        borderRadius: config.borderRadius ?? BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: config.optionsAlignment ?? MainAxisAlignment.start,
        crossAxisAlignment: config.optionsCrossAlignment ?? CrossAxisAlignment.start,
        children: _buildOptionWidgets(context),
      ),
    );
  }

  List<Widget> _buildOptionWidgets(BuildContext context) {
    final List<Widget> widgets = [];

    for (int i = 0; i < options.length; i++) {
      final option = options[i];

      widgets.add(
        GestureDetector(
          onTap: () {
            if (dismissOnOptionTap) {
              Navigator.of(context).pop();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                option.onTap();
              });
            } else {
              option.onTap();
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Icon(
                  option.icon,
                  size: config.iconSize ?? 16,
                  color: option.iconColor ?? Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    option.label,
                    style: config.textStyle?.copyWith(
                      color: option.textColor ?? config.textStyle?.color,
                    ) ?? TextStyle(
                      fontSize: config.fontSize ?? 14,
                      color: option.textColor ?? Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Add spacing between options (except for the last one)
      if (i < options.length - 1) {
        widgets.add(SizedBox(height: config.optionSpacing ?? 8));
      }
    }

    return widgets;
  }
}
