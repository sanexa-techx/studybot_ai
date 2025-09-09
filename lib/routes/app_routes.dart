import 'package:flutter/material.dart';
import '../presentation/chat_history/chat_history.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/voice_input_interface/voice_input_interface.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/settings_panel/settings_panel.dart';
import '../presentation/chat_dashboard/chat_dashboard.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/student_profile/student_profile_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String chatHistory = '/chat-history';
  static const String splash = '/splash-screen';
  static const String voiceInputInterface = '/voice-input-interface';
  static const String onboardingFlow = '/onboarding-flow';
  static const String settingsPanel = '/settings-panel';
  static const String chatDashboard = '/chat-dashboard';
  static const String loginScreen = '/login-screen';
  static const String studentProfile = '/student-profile';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    chatHistory: (context) => const ChatHistory(),
    splash: (context) => const SplashScreen(),
    voiceInputInterface: (context) => const VoiceInputInterface(),
    onboardingFlow: (context) => const OnboardingFlow(),
    settingsPanel: (context) => const SettingsPanel(),
    chatDashboard: (context) => const ChatDashboard(),
    loginScreen: (context) => const LoginScreen(),
    studentProfile: (context) => const StudentProfileScreen(),
    // TODO: Add your other routes here
  };
}
