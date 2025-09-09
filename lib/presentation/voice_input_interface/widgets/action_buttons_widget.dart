import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSend;
  final bool canSend;

  const ActionButtonsWidget({
    Key? key,
    required this.onCancel,
    required this.onSend,
    required this.canSend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onCancel,
              icon: CustomIconWidget(
                iconName: 'close',
                color: AppTheme.textSecondary,
                size: 5.w,
              ),
              label: Text(
                'Cancel',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 3.h),
                side: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: canSend ? onSend : null,
              icon: CustomIconWidget(
                iconName: 'send',
                color: canSend
                    ? AppTheme.lightTheme.colorScheme.surface
                    : AppTheme.textSecondary.withValues(alpha: 0.5),
                size: 5.w,
              ),
              label: Text(
                'Send',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: canSend
                      ? AppTheme.lightTheme.colorScheme.surface
                      : AppTheme.textSecondary.withValues(alpha: 0.5),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: canSend
                    ? AppTheme.primary
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                padding: EdgeInsets.symmetric(vertical: 3.h),
                elevation: canSend ? 2 : 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
