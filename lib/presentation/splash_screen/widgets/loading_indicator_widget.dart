import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class LoadingIndicatorWidget extends StatefulWidget {
  final String loadingText;
  const LoadingIndicatorWidget({
    Key? key,
    this.loadingText = 'Initializing AI Assistant...',
  }) : super(key: key);

  @override
  State<LoadingIndicatorWidget> createState() => _LoadingIndicatorWidgetState();
}

class _LoadingIndicatorWidgetState extends State<LoadingIndicatorWidget>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _textController;
  late Animation<double> _progressAnimation;
  late Animation<double> _textFadeAnimation;

  final List<String> _loadingSteps = [
    'Connecting to AI services...',
    'Loading your preferences...',
    'Preparing chat interface...',
    'Almost ready!',
  ];

  int _currentStepIndex = 0;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    ));

    _startLoadingSequence();
  }

  void _startLoadingSequence() async {
    _textController.forward();
    _progressController.forward();

    // Cycle through loading steps
    for (int i = 0; i < _loadingSteps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) {
        setState(() {
          _currentStepIndex = i;
        });
      }
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Progress indicator
        Container(
          width: 60.w,
          height: 0.5.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: AppTheme.borderSubtle,
          ),
          child: AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _progressAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primary,
                        AppTheme.secondary,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 3.h),
        // Loading text
        FadeTransition(
          opacity: _textFadeAnimation,
          child: Text(
            _currentStepIndex < _loadingSteps.length
                ? _loadingSteps[_currentStepIndex]
                : widget.loadingText,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondary,
              letterSpacing: 0.2,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}