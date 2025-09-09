import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChatSessionCard extends StatelessWidget {
  final Map<String, dynamic> session;
  final VoidCallback onTap;
  final VoidCallback onPin;
  final VoidCallback onDelete;

  const ChatSessionCard({
    Key? key,
    required this.session,
    required this.onTap,
    required this.onPin,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime sessionDate = session['date'] as DateTime;
    final String firstMessage = session['firstMessage'] as String;
    final List<String> tags = (session['tags'] as List).cast<String>();
    final int messageCount = session['messageCount'] as int;
    final bool isPinned = session['isPinned'] as bool? ?? false;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(session['id']),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onPin(),
              backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
              foregroundColor: AppTheme.lightTheme.colorScheme.surface,
              icon: isPinned ? Icons.push_pin : Icons.push_pin_outlined,
              label: isPinned ? 'Unpin' : 'Pin',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onDelete(),
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              foregroundColor: AppTheme.lightTheme.colorScheme.surface,
              icon: Icons.delete_outline,
              label: 'Delete',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Card(
          elevation: isPinned ? 4 : 2,
          shadowColor: AppTheme.shadowLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isPinned
                ? BorderSide(
                    color: AppTheme.lightTheme.colorScheme.primary, width: 1)
                : BorderSide.none,
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            if (isPinned) ...[
                              CustomIconWidget(
                                iconName: 'push_pin',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 16,
                              ),
                              SizedBox(width: 2.w),
                            ],
                            Expanded(
                              child: Text(
                                _formatDate(sessionDate),
                                style: AppTheme.lightTheme.textTheme.titleSmall
                                    ?.copyWith(
                                  color: isPinned
                                      ? AppTheme.lightTheme.colorScheme.primary
                                      : AppTheme.textPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color:
                              AppTheme.lightTheme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$messageCount messages',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    firstMessage,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (tags.isNotEmpty) ...[
                    SizedBox(height: 1.5.h),
                    Wrap(
                      spacing: 2.w,
                      runSpacing: 0.5.h,
                      children: tags
                          .take(3)
                          .map((tag) => Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: AppTheme.lightTheme.colorScheme
                                      .secondaryContainer,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  tag,
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.secondary,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return '${weekdays[date.weekday - 1]} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }
  }
}
