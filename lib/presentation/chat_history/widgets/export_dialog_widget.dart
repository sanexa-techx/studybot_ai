import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExportDialogWidget extends StatefulWidget {
  final Function(String format, String dateRange) onExport;

  const ExportDialogWidget({
    Key? key,
    required this.onExport,
  }) : super(key: key);

  @override
  State<ExportDialogWidget> createState() => _ExportDialogWidgetState();
}

class _ExportDialogWidgetState extends State<ExportDialogWidget> {
  String _selectedFormat = 'PDF';
  String _selectedDateRange = 'All Time';

  final List<String> _formats = ['PDF', 'TXT', 'CSV'];
  final List<String> _dateRanges = ['All Time', 'This Month', 'This Week'];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'file_download',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Export Chat History',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Text(
              'Export Format',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              children: _formats.map((format) {
                final isSelected = _selectedFormat == format;
                return ChoiceChip(
                  label: Text(
                    format,
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.surface
                          : AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedFormat = format);
                    }
                  },
                  backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                  selectedColor: AppTheme.lightTheme.colorScheme.primary,
                  side: BorderSide(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.borderSubtle,
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 2.h),
            Text(
              'Date Range',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              children: _dateRanges.map((range) {
                final isSelected = _selectedDateRange == range;
                return ChoiceChip(
                  label: Text(
                    range,
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.surface
                          : AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedDateRange = range);
                    }
                  },
                  backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                  selectedColor: AppTheme.lightTheme.colorScheme.primary,
                  side: BorderSide(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.borderSubtle,
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                ElevatedButton(
                  onPressed: () {
                    widget.onExport(_selectedFormat, _selectedDateRange);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Export',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.surface,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
