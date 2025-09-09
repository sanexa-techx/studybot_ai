import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class WaveformVisualizerWidget extends StatefulWidget {
  final bool isRecording;
  final double amplitude;

  const WaveformVisualizerWidget({
    Key? key,
    required this.isRecording,
    required this.amplitude,
  }) : super(key: key);

  @override
  State<WaveformVisualizerWidget> createState() =>
      _WaveformVisualizerWidgetState();
}

class _WaveformVisualizerWidgetState extends State<WaveformVisualizerWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(WaveformVisualizerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording != oldWidget.isRecording) {
      if (widget.isRecording) {
        _animationController.repeat(reverse: true);
      } else {
        _animationController.stop();
        _animationController.reset();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      height: 20.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return CustomPaint(
              size: Size(70.w, 15.h),
              painter: WaveformPainter(
                amplitude: widget.isRecording ? widget.amplitude : 0.0,
                animationValue: _animation.value,
                isRecording: widget.isRecording,
              ),
            );
          },
        ),
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final double amplitude;
  final double animationValue;
  final bool isRecording;

  WaveformPainter({
    required this.amplitude,
    required this.animationValue,
    required this.isRecording,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isRecording
          ? AppTheme.primary.withValues(alpha: 0.8)
          : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final centerY = size.height / 2;
    final barWidth = 4.0;
    final barSpacing = 8.0;
    final totalBars = (size.width / (barWidth + barSpacing)).floor();

    for (int i = 0; i < totalBars; i++) {
      final x = i * (barWidth + barSpacing) + barWidth / 2;

      double barHeight;
      if (isRecording) {
        final normalizedIndex = i / totalBars;
        final wave = math.sin(
            (normalizedIndex * 4 * math.pi) + (animationValue * 2 * math.pi));
        barHeight =
            (amplitude * 0.5 + 0.2) * (size.height * 0.4) * (0.5 + 0.5 * wave);
      } else {
        barHeight = size.height * 0.1;
      }

      final startY = centerY - barHeight / 2;
      final endY = centerY + barHeight / 2;

      canvas.drawLine(
        Offset(x, startY),
        Offset(x, endY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
