import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ProfileStatsWidget extends StatelessWidget {
  final Map<String, dynamic> studentData;

  const ProfileStatsWidget({
    Key? key,
    required this.studentData,
  }) : super(key: key);

  String _formatTime(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours > 0) {
      return '${hours}h ${remainingMinutes}m';
    }
    return '${remainingMinutes}m';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Learning Statistics',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),

          SizedBox(height: 2.h),

          // Stats Grid
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.local_fire_department,
                  value: '${studentData['studyStreak']}',
                  label: 'Day Streak',
                  color: AppTheme.error,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.schedule,
                  value: _formatTime(studentData['timeSpent']),
                  label: 'Time Spent',
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.chat_bubble_outline,
                  value: '${studentData['totalSessions']}',
                  label: 'Chat Sessions',
                  color: AppTheme.secondary,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.check_circle_outline,
                  value: '${studentData['completedTopics']}',
                  label: 'Topics Done',
                  color: AppTheme.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 6.w,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
