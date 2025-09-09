import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';

class RetryConnectionWidget extends StatelessWidget {
  final VoidCallback onRetry;
  final String errorMessage;

  const RetryConnectionWidget({
    Key? key,
    required this.onRetry,
    this.errorMessage =
        'Connection timeout. Please check your internet connection.',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(4.w),
        border: Border.all(
          color: AppTheme.error.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Error icon
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.error.withValues(alpha: 0.1),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'wifi_off',
                color: AppTheme.error,
                size: 6.w,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          // Error message
          Text(
            errorMessage,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          // Retry button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onRetry,
              icon: CustomIconWidget(
                iconName: 'refresh',
                color: AppTheme.surface,
                size: 4.w,
              ),
              label: Text(
                'Try Again',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.surface,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: AppTheme.surface,
                padding: EdgeInsets.symmetric(vertical: 3.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.w),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}