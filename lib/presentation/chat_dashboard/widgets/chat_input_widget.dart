import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChatInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onVoiceInput;
  final bool isLoading;

  const ChatInputWidget({
    Key? key,
    required this.controller,
    required this.onSend,
    required this.onVoiceInput,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(6.w),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: widget.controller,
                        enabled: !widget.isLoading,
                        maxLines: 4,
                        minLines: 1,
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                        decoration: InputDecoration(
                          hintText: 'Ask me anything about your studies...',
                          hintStyle: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.6),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 2.h,
                          ),
                        ),
                        textInputAction: TextInputAction.newline,
                        onSubmitted: (_) {
                          if (_hasText && !widget.isLoading) {
                            widget.onSend();
                          }
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.isLoading ? null : widget.onVoiceInput,
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        child: CustomIconWidget(
                          iconName: 'mic',
                          color: widget.isLoading
                              ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.4)
                              : AppTheme.lightTheme.colorScheme.primary,
                          size: 5.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 2.w),
            GestureDetector(
              onTap: (_hasText && !widget.isLoading) ? widget.onSend : null,
              child: Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: (_hasText && !widget.isLoading)
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(6.w),
                ),
                child: widget.isLoading
                    ? SizedBox(
                        width: 5.w,
                        height: 5.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : CustomIconWidget(
                        iconName: 'send',
                        color: (_hasText && !widget.isLoading)
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.6),
                        size: 5.w,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
