import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionButtonsWidget extends StatelessWidget {
  final Function(String) onQuickAction;

  const QuickActionButtonsWidget({
    Key? key,
    required this.onQuickAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final quickActions = [
      {'text': 'Help with Math', 'icon': 'calculate'},
      {'text': 'Explain Concept', 'icon': 'lightbulb'},
      {'text': 'Study Tips', 'icon': 'tips_and_updates'},
    ];

    return Container(
      height: 6.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: quickActions.length,
        separatorBuilder: (context, index) => SizedBox(width: 2.w),
        itemBuilder: (context, index) {
          final action = quickActions[index];
          return GestureDetector(
            onTap: () => onQuickAction(action['text'] as String),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(6.w),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: action['icon'] as String,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    action['text'] as String,
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
