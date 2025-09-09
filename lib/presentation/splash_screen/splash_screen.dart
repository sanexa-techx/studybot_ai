import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/animated_logo_widget.dart';
import './widgets/background_gradient_widget.dart';
import './widgets/loading_indicator_widget.dart';
import './widgets/retry_connection_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showRetryOption = false;
  bool _isInitializing = true;
  String _currentLoadingText = 'Initializing AI Assistant...';

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      setState(() {
        _showRetryOption = false;
        _isInitializing = true;
      });

      // Check network connectivity
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        _showConnectionError();
        return;
      }

      // Clear any preloaded data on app start
      await _clearPreloadedData();

      // Load user preferences
      await _loadUserPreferences();

      // Initialize services without preloaded data
      await _initializeServices();

      // Navigate based on authentication state
      await _navigateToNextScreen();
    } catch (e) {
      _showConnectionError();
    }
  }

  Future<void> _clearPreloadedData() async {
    setState(() {
      _currentLoadingText = 'Clearing cached data...';
    });

    await Future.delayed(const Duration(milliseconds: 500));

    final prefs = await SharedPreferences.getInstance();

    // Clear preloaded data but keep user authentication state
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    final userEmail = prefs.getString('user_email');
    final userName = prefs.getString('user_name');
    final rememberMe = prefs.getBool('remember_me') ?? false;
    final savedEmail = prefs.getString('saved_email');

    // Remove all preloaded data
    await prefs.remove('chat_history');
    await prefs.remove('user_context');
    await prefs.remove('offline_message_queue');

    // Restore essential user data if logged in
    if (isLoggedIn) {
      await prefs.setBool('is_logged_in', true);
      if (userEmail != null) await prefs.setString('user_email', userEmail);
      if (userName != null) await prefs.setString('user_name', userName);
    }

    if (rememberMe && savedEmail != null) {
      await prefs.setBool('remember_me', true);
      await prefs.setString('saved_email', savedEmail);
    }
  }

  Future<void> _loadUserPreferences() async {
    setState(() {
      _currentLoadingText = 'Loading preferences...';
    });

    await Future.delayed(const Duration(milliseconds: 600));

    final prefs = await SharedPreferences.getInstance();

    // Load theme preference
    final isDarkMode = prefs.getBool('dark_mode') ?? false;

    // Load notification settings
    final notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;

    // Apply loaded preferences
    if (isDarkMode) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    }
  }

  Future<void> _initializeServices() async {
    setState(() {
      _currentLoadingText = 'Initializing services...';
    });

    await Future.delayed(const Duration(milliseconds: 700));

    final prefs = await SharedPreferences.getInstance();

    // Initialize empty structures (no preloaded data)
    await prefs.setStringList('chat_history', []);
    await prefs.setStringList('offline_message_queue', []);

    // Set up connectivity listener for queue processing
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (!results.contains(ConnectivityResult.none)) {
        _processOfflineQueue();
      }
    });
  }

  Future<void> _processOfflineQueue() async {
    final prefs = await SharedPreferences.getInstance();
    final offlineQueue = prefs.getStringList('offline_message_queue') ?? [];

    if (offlineQueue.isNotEmpty) {
      // Process queued messages when connection is restored
      for (String message in offlineQueue) {
        // Send queued message to AI service
        // This would be implemented with actual API calls
      }

      // Clear processed queue
      await prefs.remove('offline_message_queue');
    }
  }

  Future<void> _navigateToNextScreen() async {
    setState(() {
      _currentLoadingText = 'Almost ready!';
    });

    await Future.delayed(const Duration(milliseconds: 800));

    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    final isFirstLaunch = prefs.getBool('first_launch') ?? true;

    if (mounted) {
      if (!isLoggedIn) {
        // Navigate to login for users who aren't logged in
        Navigator.pushReplacementNamed(context, '/login-screen');
      } else if (isFirstLaunch) {
        // Navigate to onboarding for first-time users
        Navigator.pushReplacementNamed(context, '/onboarding-flow');
      } else {
        // Navigate to chat dashboard for returning users
        Navigator.pushReplacementNamed(context, '/chat-dashboard');
      }
    }
  }

  void _showConnectionError() {
    if (mounted) {
      setState(() {
        _showRetryOption = true;
        _isInitializing = false;
      });
    }
  }

  void _retryInitialization() {
    _initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Background gradient
            const BackgroundGradientWidget(),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated logo
                  const AnimatedLogoWidget(),

                  SizedBox(height: 8.h),

                  // App title
                  Text(
                    'StudyBot AI',
                    style: GoogleFonts.inter(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),

                  SizedBox(height: 1.h),

                  // Subtitle
                  Text(
                    'Your AI Learning Companion',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.textSecondary,
                      letterSpacing: 0.2,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // Loading indicator or retry option
                  _isInitializing
                      ? LoadingIndicatorWidget(
                          loadingText: _currentLoadingText,
                        )
                      : _showRetryOption
                          ? RetryConnectionWidget(
                              onRetry: _retryInitialization,
                              errorMessage:
                                  'Unable to connect to services. Please check your internet connection and try again.',
                            )
                          : const SizedBox.shrink(),
                ],
              ),
            ),

            // Version info at bottom
            Positioned(
              bottom: 4.h,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Version 1.0.0',
                  style: GoogleFonts.inter(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.textSecondary.withValues(alpha: 0.6),
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
