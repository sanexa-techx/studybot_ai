import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BackgroundGradientWidget extends StatelessWidget {
  const BackgroundGradientWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.3, 0.7, 1.0],
          colors: [
            AppTheme.primary.withValues(alpha: 0.1),
            AppTheme.background,
            AppTheme.background,
            AppTheme.secondary.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -10.h,
            right: -15.w,
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primary.withValues(alpha: 0.03),
              ),
            ),
          ),
          Positioned(
            bottom: -15.h,
            left: -20.w,
            child: Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.secondary.withValues(alpha: 0.02),
              ),
            ),
          ),
          // Floating educational icons
          Positioned(
            top: 15.h,
            left: 10.w,
            child: _buildFloatingIcon('school', 0.02),
          ),
          Positioned(
            top: 25.h,
            right: 15.w,
            child: _buildFloatingIcon('lightbulb', 0.015),
          ),
          Positioned(
            bottom: 20.h,
            left: 20.w,
            child: _buildFloatingIcon('menu_book', 0.018),
          ),
          Positioned(
            bottom: 30.h,
            right: 8.w,
            child: _buildFloatingIcon('psychology', 0.025),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingIcon(String iconName, double opacity) {
    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.primary.withValues(alpha: opacity),
      ),
      child: CustomIconWidget(
        iconName: iconName,
        color: AppTheme.primary.withValues(alpha: 0.1),
        size: 4.w,
      ),
    );
  }
}
