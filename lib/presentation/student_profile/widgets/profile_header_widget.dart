import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> studentData;

  const ProfileHeaderWidget({
    Key? key,
    required this.studentData,
  }) : super(key: key);

  String _formatJoinDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date).inDays;

      if (difference < 1) return 'Joined today';
      if (difference < 7) return 'Joined $difference days ago';
      if (difference < 30)
        return 'Joined ${(difference / 7).round()} weeks ago';
      return 'Joined ${(difference / 30).round()} months ago';
    } catch (e) {
      return 'New member';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.w),
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
        children: [
          // Profile Avatar
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primary, AppTheme.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Text(
                (studentData['name'] as String).isNotEmpty
                    ? (studentData['name'] as String)[0].toUpperCase()
                    : 'S',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Student Name
          Text(
            studentData['name'],
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 0.5.h),

          // Email
          Text(
            studentData['email'],
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 1.h),

          // Join Date
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _formatJoinDate(studentData['joinDate']),
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.primary,
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Level Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.stars,
                color: AppTheme.warning,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Level ${studentData['level']}',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
