import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NavigationControlsWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final bool isLastPage;

  const NavigationControlsWidget({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
    required this.onSkip,
    this.isLastPage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Skip Button
          if (!isLastPage)
            TextButton(
              onPressed: onSkip,
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.textSecondary,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              ),
              child: Text(
                'Skip',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else
            const SizedBox.shrink(),

          // Next Button
          if (!isLastPage)
            Container(
              width: 12.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowLight,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: onNext,
                icon: CustomIconWidget(
                  iconName: 'arrow_forward',
                  color: AppTheme.surface,
                  size: 24,
                ),
              ),
            )
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}
