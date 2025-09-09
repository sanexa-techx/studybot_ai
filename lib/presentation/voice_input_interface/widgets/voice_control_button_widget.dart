import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceControlButtonWidget extends StatefulWidget {
  final bool isRecording;
  final VoidCallback onTap;
  final String buttonText;

  const VoiceControlButtonWidget({
    Key? key,
    required this.isRecording,
    required this.onTap,
    required this.buttonText,
  }) : super(key: key);

  @override
  State<VoiceControlButtonWidget> createState() =>
      _VoiceControlButtonWidgetState();
}

class _VoiceControlButtonWidgetState extends State<VoiceControlButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(VoiceControlButtonWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording != oldWidget.isRecording) {
      if (widget.isRecording) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isRecording ? _pulseAnimation.value : 1.0,
            child: Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isRecording ? AppTheme.error : AppTheme.primary,
                boxShadow: [
                  BoxShadow(
                    color: widget.isRecording
                        ? AppTheme.error.withValues(alpha: 0.3)
                        : AppTheme.primary.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: widget.isRecording
                    ? CustomIconWidget(
                        iconName: 'stop',
                        color: AppTheme.lightTheme.colorScheme.surface,
                        size: 8.w,
                      )
                    : CustomIconWidget(
                        iconName: 'mic',
                        color: AppTheme.lightTheme.colorScheme.surface,
                        size: 8.w,
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
