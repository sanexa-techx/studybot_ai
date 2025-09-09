import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/forgot_password_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/social_login_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isObscured = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('remember_me') ?? false) {
      setState(() {
        _emailController.text = prefs.getString('saved_email') ?? '';
        _rememberMe = true;
      });
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Simulate login API call
      await Future.delayed(const Duration(seconds: 2));

      final prefs = await SharedPreferences.getInstance();

      // Save login state
      await prefs.setBool('is_logged_in', true);
      await prefs.setString('user_email', _emailController.text);
      await prefs.setString(
          'user_name', _extractNameFromEmail(_emailController.text));
      await prefs.setString(
          'login_timestamp', DateTime.now().toIso8601String());

      // Save credentials if remember me is checked
      if (_rememberMe) {
        await prefs.setBool('remember_me', true);
        await prefs.setString('saved_email', _emailController.text);
      } else {
        await prefs.remove('remember_me');
        await prefs.remove('saved_email');
      }

      // Clear any existing preloaded data
      await _clearPreloadedData();

      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.chatDashboard);
      }
    } catch (e) {
      _showErrorSnackBar('Login failed. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _clearPreloadedData() async {
    final prefs = await SharedPreferences.getInstance();
    // Clear preloaded chat history
    await prefs.remove('chat_history');
    // Clear preloaded user context
    await prefs.remove('user_context');
    // Clear offline queue
    await prefs.remove('offline_message_queue');
  }

  String _extractNameFromEmail(String email) {
    return email.split('@').first.replaceAll(RegExp(r'[^a-zA-Z]'), ' ').trim();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4.h),

              // Header
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.school_outlined,
                        size: 8.w,
                        color: AppTheme.primary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Welcome Back',
                      style: GoogleFonts.inter(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Sign in to continue your learning journey',
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 6.h),

              // Login Form
              LoginFormWidget(
                formKey: _formKey,
                emailController: _emailController,
                passwordController: _passwordController,
                isObscured: _isObscured,
                isLoading: _isLoading,
                rememberMe: _rememberMe,
                onObscureToggle: () =>
                    setState(() => _isObscured = !_isObscured),
                onRememberMeChanged: (value) =>
                    setState(() => _rememberMe = value ?? false),
                onLogin: _handleLogin,
              ),

              SizedBox(height: 3.h),

              // Forgot Password
              const ForgotPasswordWidget(),

              SizedBox(height: 4.h),

              // Social Login
              const SocialLoginWidget(),

              SizedBox(height: 4.h),

              // Sign Up Link
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.textSecondary,
                    ),
                    children: [
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to sign up screen
                            _showErrorSnackBar('Sign up feature coming soon!');
                          },
                          child: Text(
                            'Sign Up',
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
