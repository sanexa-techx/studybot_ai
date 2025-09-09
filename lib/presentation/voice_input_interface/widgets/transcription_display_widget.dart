import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TranscriptionDisplayWidget extends StatelessWidget {
  final String transcriptionText;
  final bool isTranscribing;

  const TranscriptionDisplayWidget({
    Key? key,
    required this.transcriptionText,
    required this.isTranscribing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85.w,
      constraints: BoxConstraints(
        minHeight: 12.h,
        maxHeight: 20.h,
      ),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'text_fields',
                color: AppTheme.textSecondary,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Transcription',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              if (isTranscribing)
                SizedBox(
                  width: 4.w,
                  height: 4.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                  ),
                ),
            ],
          ),
          SizedBox(height: 2.h),
          Flexible(
            child: SingleChildScrollView(
              child: transcriptionText.isEmpty
                  ? Text(
                      isTranscribing
                          ? 'Listening...'
                          : 'Tap the microphone to start speaking',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary.withValues(alpha: 0.7),
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  : Text(
                      transcriptionText,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textPrimary,
                        height: 1.4,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
