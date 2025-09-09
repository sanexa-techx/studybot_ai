import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/navigation_controls_widget.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/page_indicator_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({Key? key}) : super(key: key);

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Instant Homework Help",
      "description":
          "Get immediate assistance with your assignments, math problems, and study questions. Our AI tutor is available 24/7 to help you understand complex concepts.",
      "imageUrl":
          "https://images.unsplash.com/photo-1434030216411-0b793f4b4173?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8c3R1ZHl8ZW58MHx8MHx8fDA%3D",
    },
    {
      "title": "Personalized Study Guidance",
      "description":
          "Receive customized learning paths and study strategies tailored to your academic goals. Track your progress and improve your understanding step by step.",
      "imageUrl":
          "https://images.pexels.com/photos/159711/books-bookstore-book-reading-159711.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
    },
    {
      "title": "Learn Anytime, Anywhere",
      "description":
          "Access your AI study companion on-the-go. Whether you're at home, in the library, or commuting, get instant answers and explanations whenever you need them.",
      "imageUrl":
          "https://cdn.pixabay.com/photo/2016/11/29/06/15/mobile-phone-1867510_1280.jpg",
    },
  ];

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      HapticFeedback.lightImpact();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    HapticFeedback.lightImpact();
    Navigator.pushReplacementNamed(context, '/chat-dashboard');
  }

  void _getStarted() {
    HapticFeedback.mediumImpact();
    Navigator.pushReplacementNamed(context, '/chat-dashboard');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Page Content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                  HapticFeedback.selectionClick();
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  final data = _onboardingData[index];
                  return OnboardingPageWidget(
                    title: data["title"] as String,
                    description: data["description"] as String,
                    imageUrl: data["imageUrl"] as String,
                    isLastPage: index == _onboardingData.length - 1,
                    onGetStarted: _getStarted,
                  );
                },
              ),
            ),

            // Page Indicators
            Container(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: PageIndicatorWidget(
                currentPage: _currentPage,
                totalPages: _onboardingData.length,
              ),
            ),

            // Navigation Controls
            NavigationControlsWidget(
              currentPage: _currentPage,
              totalPages: _onboardingData.length,
              onNext: _nextPage,
              onSkip: _skipOnboarding,
              isLastPage: _currentPage == _onboardingData.length - 1,
            ),

            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
