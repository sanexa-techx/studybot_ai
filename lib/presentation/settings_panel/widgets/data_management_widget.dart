import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DataManagementWidget extends StatelessWidget {
  final String storageUsed;
  final VoidCallback onClearChatHistory;
  final VoidCallback onExportConversations;
  final VoidCallback onManageOfflineCache;

  const DataManagementWidget({
    super.key,
    required this.storageUsed,
    required this.onClearChatHistory,
    required this.onExportConversations,
    required this.onManageOfflineCache,
  });

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
              'Data Management',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
          _buildStorageUsageSection(),
          _buildDivider(),
          _buildActionTile(
            title: 'Export Conversations',
            subtitle: 'Save your chat history as a file',
            icon: 'download',
            onTap: onExportConversations,
          ),
          _buildDivider(),
          _buildActionTile(
            title: 'Manage Offline Cache',
            subtitle: 'Clear cached data for offline use',
            icon: 'storage',
            onTap: onManageOfflineCache,
          ),
          _buildDivider(),
          _buildActionTile(
            title: 'Clear Chat History',
            subtitle: 'Permanently delete all conversations',
            icon: 'delete_outline',
            onTap: () => _showClearDataDialog(context),
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildStorageUsageSection() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Storage Used',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              Text(
                storageUsed,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          LinearProgressIndicator(
            value: _calculateStoragePercentage(),
            backgroundColor:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              _getStorageColor(),
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'Chat history and cached data',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required String icon,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: isDestructive
                    ? AppTheme.error.withValues(alpha: 0.1)
                    : AppTheme.lightTheme.colorScheme.primaryContainer
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: isDestructive
                    ? AppTheme.error
                    : AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isDestructive
                          ? AppTheme.error
                          : AppTheme.lightTheme.colorScheme.onSurface,
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
            CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Clear All Data',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        content: Text(
          'This will permanently delete all your chat history and cannot be undone. Are you sure you want to continue?',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onClearChatHistory();
            },
            child: Text(
              'Clear All',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateStoragePercentage() {
    // Parse storage used (e.g., "45.2 MB" -> 45.2)
    final numericValue = double.tryParse(storageUsed.split(' ')[0]) ?? 0;
    // Assume 100 MB is the maximum for calculation
    return (numericValue / 100).clamp(0.0, 1.0);
  }

  Color _getStorageColor() {
    final percentage = _calculateStoragePercentage();
    if (percentage < 0.5) {
      return AppTheme.success;
    } else if (percentage < 0.8) {
      return AppTheme.warning;
    } else {
      return AppTheme.error;
    }
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
