import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class AchievementsWidget extends StatelessWidget {
  final List<String> achievements;

  const AchievementsWidget({
    Key? key,
    required this.achievements,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultAchievements = [
      {'title': 'First Chat', 'icon': Icons.chat, 'unlocked': true},
      {
        'title': 'Study Streak',
        'icon': Icons.local_fire_department,
        'unlocked': true
      },
      {'title': 'Quick Learner', 'icon': Icons.flash_on, 'unlocked': false},
      {'title': 'Topic Master', 'icon': Icons.school, 'unlocked': false},
      {'title': 'Night Owl', 'icon': Icons.nightlight_round, 'unlocked': false},
      {'title': 'Early Bird', 'icon': Icons.wb_sunny, 'unlocked': false},
    ];

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Achievements',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '2/6',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.warning,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Achievement Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 1,
            ),
            itemCount: defaultAchievements.length,
            itemBuilder: (context, index) {
              final achievement = defaultAchievements[index];
              return _buildAchievementItem(achievement);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(Map<String, dynamic> achievement) {
    final isUnlocked = achievement['unlocked'] as bool;

    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: isUnlocked
            ? AppTheme.warning.withValues(alpha: 0.1)
            : AppTheme.borderSubtle.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnlocked
              ? AppTheme.warning.withValues(alpha: 0.3)
              : AppTheme.borderSubtle.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            achievement['icon'] as IconData,
            size: 8.w,
            color: isUnlocked ? AppTheme.warning : AppTheme.textSecondary,
          ),
          SizedBox(height: 1.h),
          Text(
            achievement['title'] as String,
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: isUnlocked ? AppTheme.warning : AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
