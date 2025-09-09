import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MessageBubbleWidget extends StatelessWidget {
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final VoidCallback? onLongPress;

  const MessageBubbleWidget({
    Key? key,
    required this.message,
    required this.isUser,
    required this.timestamp,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                borderRadius: BorderRadius.circular(4.w),
              ),
              child: CustomIconWidget(
                iconName: 'smart_toy',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 4.w,
              ),
            ),
            SizedBox(width: 2.w),
          ],
          Flexible(
            child: GestureDetector(
              onLongPress: !isUser ? onLongPress : null,
              child: Container(
                constraints: BoxConstraints(maxWidth: 75.w),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: isUser
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.w),
                    topRight: Radius.circular(4.w),
                    bottomLeft: Radius.circular(isUser ? 4.w : 1.w),
                    bottomRight: Radius.circular(isUser ? 1.w : 4.w),
                  ),
                  border: !isUser
                      ? Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.2),
                          width: 1,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.shadowLight,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: isUser
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                            : AppTheme.lightTheme.colorScheme.onSurface,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      _formatTime(timestamp),
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: isUser
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                                .withValues(alpha: 0.7)
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isUser) ...[
            SizedBox(width: 2.w),
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondary,
                borderRadius: BorderRadius.circular(4.w),
              ),
              child: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.onSecondary,
                size: 4.w,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
}
