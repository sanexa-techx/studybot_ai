import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingsSectionWidget extends StatelessWidget {
  final VoidCallback onLogout;

  const SettingsSectionWidget({
    Key? key,
    required this.onLogout,
  }) : super(key: key);

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
            'Account Settings',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),

          SizedBox(height: 2.h),

          // Settings Items
          _buildSettingsItem(
            icon: Icons.settings_outlined,
            title: 'App Settings',
            subtitle: 'Preferences and notifications',
            onTap: () => Navigator.pushNamed(context, AppRoutes.settingsPanel),
          ),

          _buildSettingsItem(
            icon: Icons.history,
            title: 'Chat History',
            subtitle: 'View previous conversations',
            onTap: () => Navigator.pushNamed(context, AppRoutes.chatHistory),
          ),

          _buildSettingsItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'Get help and contact us',
            onTap: () => _showHelpDialog(context),
          ),

          _buildSettingsItem(
            icon: Icons.logout,
            title: 'Logout',
            subtitle: 'Sign out of your account',
            onTap: onLogout,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: isDestructive
              ? AppTheme.error.withValues(alpha: 0.1)
              : AppTheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 5.w,
          color: isDestructive ? AppTheme.error : AppTheme.primary,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: isDestructive ? AppTheme.error : AppTheme.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          color: AppTheme.textSecondary,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: AppTheme.textSecondary,
        size: 5.w,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0.5.h),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Help & Support',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need help with StudyBot AI?',
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: AppTheme.textSecondary,
              ),
            ),
            SizedBox(height: 2.h),
            _buildHelpOption(
                Icons.email, 'Email Support', 'support@studybot.ai'),
            _buildHelpOption(Icons.chat, 'Live Chat', 'Chat with our team'),
            _buildHelpOption(
                Icons.book, 'User Guide', 'View help documentation'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpOption(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primary, size: 5.w),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: AppTheme.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(
          fontSize: 11.sp,
          fontWeight: FontWeight.w400,
          color: AppTheme.textSecondary,
        ),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}
