import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class LearningProgressWidget extends StatelessWidget {
  final Map<String, dynamic> studentData;

  const LearningProgressWidget({
    Key? key,
    required this.studentData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoriteSubjects = studentData['favoriteSubjects'] as List<String>;

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
            'Learning Progress',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),

          SizedBox(height: 2.h),

          // Progress Indicators
          ...favoriteSubjects.map((subject) => _buildProgressItem(subject)),

          SizedBox(height: 2.h),

          // Weekly Goal
          _buildWeeklyGoal(),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String subject) {
    // Generate random progress for demo
    final progress = (subject.hashCode % 80 + 20) / 100.0;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subject,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppTheme.borderSubtle,
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyGoal() {
    final currentSessions = studentData['totalSessions'] % 10;
    final weeklyGoal = 10;
    final progress = currentSessions / weeklyGoal;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.success.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.flag_outlined,
                color: AppTheme.success,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Weekly Goal',
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.success,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            '$currentSessions / $weeklyGoal study sessions',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 1.h),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppTheme.success.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.success),
          ),
        ],
      ),
    );
  }
}
