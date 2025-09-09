import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class LoginFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isObscured;
  final bool isLoading;
  final bool rememberMe;
  final VoidCallback onObscureToggle;
  final ValueChanged<bool?> onRememberMeChanged;
  final VoidCallback onLogin;

  const LoginFormWidget({
    Key? key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isObscured,
    required this.isLoading,
    required this.rememberMe,
    required this.onObscureToggle,
    required this.onRememberMeChanged,
    required this.onLogin,
  }) : super(key: key);

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          // Email Field
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email address',
              prefixIcon: Icon(
                Icons.email_outlined,
                color: AppTheme.textSecondary,
                size: 5.w,
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Password Field
          TextFormField(
            controller: passwordController,
            obscureText: isObscured,
            validator: _validatePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: Icon(
                Icons.lock_outline,
                color: AppTheme.textSecondary,
                size: 5.w,
              ),
              suffixIcon: IconButton(
                onPressed: onObscureToggle,
                icon: Icon(
                  isObscured ? Icons.visibility : Icons.visibility_off,
                  color: AppTheme.textSecondary,
                  size: 5.w,
                ),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Remember Me Checkbox
          Row(
            children: [
              Checkbox(
                value: rememberMe,
                onChanged: onRememberMeChanged,
              ),
              Text(
                'Remember me',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Login Button
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton(
              onPressed: isLoading ? null : onLogin,
              child: isLoading
                  ? SizedBox(
                      width: 5.w,
                      height: 5.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Sign In',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
