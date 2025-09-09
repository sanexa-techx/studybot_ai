import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OnboardingPageWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final bool isLastPage;
  final VoidCallback? onGetStarted;

  const OnboardingPageWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.isLastPage = false,
    this.onGetStarted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.h,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        children: [
          SizedBox(height: 8.h),
          // Illustration
          Expanded(
            flex: 3,
            child: Container(
              width: 80.w,
              constraints: BoxConstraints(maxHeight: 40.h),
              child: CustomImageWidget(
                imageUrl: imageUrl,
                width: 80.w,
                height: 35.h,
                fit: BoxFit.contain,
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // Content
          Expanded(
            flex: 2,
            child: Column(
              children: [
                // Title
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 2.h),

                // Description
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Text(
                    description,
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textSecondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                SizedBox(height: 4.h),

                // Get Started Button (only on last page)
                if (isLastPage) ...[
                  SizedBox(
                    width: 80.w,
                    height: 6.h,
                    child: ElevatedButton(
                      onPressed: onGetStarted,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: AppTheme.surface,
                        elevation: 2,
                        shadowColor: AppTheme.shadowLight,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Get Started',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.surface,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
