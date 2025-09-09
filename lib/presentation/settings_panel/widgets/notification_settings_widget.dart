import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class NotificationSettingsWidget extends StatefulWidget {
  final bool studyReminders;
  final bool dailyTips;
  final bool responseAlerts;
  final TimeOfDay quietHoursStart;
  final TimeOfDay quietHoursEnd;
  final Function(bool) onStudyRemindersChanged;
  final Function(bool) onDailyTipsChanged;
  final Function(bool) onResponseAlertsChanged;
  final Function(TimeOfDay) onQuietHoursStartChanged;
  final Function(TimeOfDay) onQuietHoursEndChanged;

  const NotificationSettingsWidget({
    super.key,
    required this.studyReminders,
    required this.dailyTips,
    required this.responseAlerts,
    required this.quietHoursStart,
    required this.quietHoursEnd,
    required this.onStudyRemindersChanged,
    required this.onDailyTipsChanged,
    required this.onResponseAlertsChanged,
    required this.onQuietHoursStartChanged,
    required this.onQuietHoursEndChanged,
  });

  @override
  State<NotificationSettingsWidget> createState() =>
      _NotificationSettingsWidgetState();
}

class _NotificationSettingsWidgetState
    extends State<NotificationSettingsWidget> {
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? widget.quietHoursStart : widget.quietHoursEnd,
    );

    if (picked != null) {
      if (isStartTime) {
        widget.onQuietHoursStartChanged(picked);
      } else {
        widget.onQuietHoursEndChanged(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Text(
              'Notifications',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
          _buildSwitchTile(
            title: 'Study Reminders',
            subtitle: 'Get reminded about your study sessions',
            value: widget.studyReminders,
            onChanged: widget.onStudyRemindersChanged,
          ),
          _buildDivider(),
          _buildSwitchTile(
            title: 'Daily Tips',
            subtitle: 'Receive helpful learning tips daily',
            value: widget.dailyTips,
            onChanged: widget.onDailyTipsChanged,
          ),
          _buildDivider(),
          _buildSwitchTile(
            title: 'Response Alerts',
            subtitle: 'Get notified when AI responds',
            value: widget.responseAlerts,
            onChanged: widget.onResponseAlertsChanged,
          ),
          _buildDivider(),
          _buildQuietHoursSection(),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  subtitle,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildQuietHoursSection() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quiet Hours',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'No notifications during these hours',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildTimeSelector(
                  label: 'Start',
                  time: widget.quietHoursStart,
                  onTap: () => _selectTime(context, true),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildTimeSelector(
                  label: 'End',
                  time: widget.quietHoursEnd,
                  onTap: () => _selectTime(context, false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector({
    required String label,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primaryContainer
              .withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              time.format(context),
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
      indent: 4.w,
      endIndent: 4.w,
    );
  }
}
