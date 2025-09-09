import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/about_section_widget.dart';
import './widgets/accessibility_settings_widget.dart';
import './widgets/appearance_settings_widget.dart';
import './widgets/chat_preferences_widget.dart';
import './widgets/data_management_widget.dart';
import './widgets/notification_settings_widget.dart';
import './widgets/privacy_controls_widget.dart';
import './widgets/voice_input_settings_widget.dart';

class SettingsPanel extends StatefulWidget {
  const SettingsPanel({super.key});

  @override
  State<SettingsPanel> createState() => _SettingsPanelState();
}

class _SettingsPanelState extends State<SettingsPanel> {
  // Notification Settings
  bool _studyReminders = true;
  bool _dailyTips = true;
  bool _responseAlerts = false;
  TimeOfDay _quietHoursStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietHoursEnd = const TimeOfDay(hour: 7, minute: 0);

  // Chat Preferences
  String _responseLength = 'Medium';
  List<String> _subjectFocusAreas = ['Mathematics', 'Science'];
  String _conversationTone = 'Casual';

  // Appearance Settings
  bool _isDarkMode = false;
  bool _syncWithSystem = true;

  // Voice Input Settings
  String _selectedLanguage = 'English (US)';
  String _accentRecognition = 'Standard';
  double _speechAccuracy = 0.5;

  // Data Management
  String _storageUsed = '45.2 MB';

  // Privacy Controls
  bool _conversationEncryption = true;
  bool _dataSharing = false;

  // Accessibility Settings
  bool _screenReaderSupport = false;
  bool _highContrastMode = false;
  double _textScaling = 1.0;

  // App Info
  String _appVersion = '1.2.3';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 1.h),

            // Notification Settings
            NotificationSettingsWidget(
              studyReminders: _studyReminders,
              dailyTips: _dailyTips,
              responseAlerts: _responseAlerts,
              quietHoursStart: _quietHoursStart,
              quietHoursEnd: _quietHoursEnd,
              onStudyRemindersChanged: (value) {
                setState(() => _studyReminders = value);
                _showToast('Study reminders ${value ? 'enabled' : 'disabled'}');
              },
              onDailyTipsChanged: (value) {
                setState(() => _dailyTips = value);
                _showToast('Daily tips ${value ? 'enabled' : 'disabled'}');
              },
              onResponseAlertsChanged: (value) {
                setState(() => _responseAlerts = value);
                _showToast('Response alerts ${value ? 'enabled' : 'disabled'}');
              },
              onQuietHoursStartChanged: (time) {
                setState(() => _quietHoursStart = time);
                _showToast('Quiet hours start time updated');
              },
              onQuietHoursEndChanged: (time) {
                setState(() => _quietHoursEnd = time);
                _showToast('Quiet hours end time updated');
              },
            ),

            // Chat Preferences
            ChatPreferencesWidget(
              responseLength: _responseLength,
              subjectFocusAreas: _subjectFocusAreas,
              conversationTone: _conversationTone,
              onResponseLengthChanged: (value) {
                setState(() => _responseLength = value);
                _showToast('Response length set to $value');
              },
              onSubjectFocusAreasChanged: (areas) {
                setState(() => _subjectFocusAreas = areas);
                _showToast('Subject focus areas updated');
              },
              onConversationToneChanged: (tone) {
                setState(() => _conversationTone = tone);
                _showToast('Conversation tone set to $tone');
              },
            ),

            // Appearance Settings
            AppearanceSettingsWidget(
              isDarkMode: _isDarkMode,
              syncWithSystem: _syncWithSystem,
              onDarkModeChanged: (value) {
                setState(() => _isDarkMode = value);
                _showToast('Dark mode ${value ? 'enabled' : 'disabled'}');
              },
              onSyncWithSystemChanged: (value) {
                setState(() => _syncWithSystem = value);
                _showToast('System sync ${value ? 'enabled' : 'disabled'}');
              },
            ),

            // Voice Input Settings
            VoiceInputSettingsWidget(
              selectedLanguage: _selectedLanguage,
              accentRecognition: _accentRecognition,
              speechAccuracy: _speechAccuracy,
              onLanguageChanged: (language) {
                setState(() => _selectedLanguage = language);
                _showToast('Language changed to $language');
              },
              onAccentRecognitionChanged: (accent) {
                setState(() => _accentRecognition = accent);
                _showToast('Accent recognition set to $accent');
              },
              onSpeechAccuracyChanged: (accuracy) {
                setState(() => _speechAccuracy = accuracy);
              },
            ),

            // Data Management
            DataManagementWidget(
              storageUsed: _storageUsed,
              onClearChatHistory: _clearChatHistory,
              onExportConversations: _exportConversations,
              onManageOfflineCache: _manageOfflineCache,
            ),

            // Privacy Controls
            PrivacyControlsWidget(
              conversationEncryption: _conversationEncryption,
              dataSharing: _dataSharing,
              onConversationEncryptionChanged: (value) {
                setState(() => _conversationEncryption = value);
                _showToast(
                    'Conversation encryption ${value ? 'enabled' : 'disabled'}');
              },
              onDataSharingChanged: (value) {
                setState(() => _dataSharing = value);
                _showToast('Data sharing ${value ? 'enabled' : 'disabled'}');
              },
              onViewPrivacyPolicy: _viewPrivacyPolicy,
            ),

            // Accessibility Settings
            AccessibilitySettingsWidget(
              screenReaderSupport: _screenReaderSupport,
              highContrastMode: _highContrastMode,
              textScaling: _textScaling,
              onScreenReaderSupportChanged: (value) {
                setState(() => _screenReaderSupport = value);
                _showToast(
                    'Screen reader support ${value ? 'enabled' : 'disabled'}');
              },
              onHighContrastModeChanged: (value) {
                setState(() => _highContrastMode = value);
                _showToast(
                    'High contrast mode ${value ? 'enabled' : 'disabled'}');
              },
              onTextScalingChanged: (scaling) {
                setState(() => _textScaling = scaling);
              },
            ),

            // About Section
            AboutSectionWidget(
              appVersion: _appVersion,
              onViewPrivacyPolicy: _viewPrivacyPolicy,
              onViewTermsOfService: _viewTermsOfService,
              onContactSupport: _contactSupport,
            ),

            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  void _clearChatHistory() {
    // Simulate clearing chat history
    setState(() => _storageUsed = '2.1 MB');
    _showToast('Chat history cleared successfully');
  }

  void _exportConversations() {
    // Simulate exporting conversations
    _showToast('Conversations exported to Downloads');
  }

  void _manageOfflineCache() {
    // Simulate managing offline cache
    _showToast('Offline cache cleared');
  }

  void _viewPrivacyPolicy() {
    // Navigate to privacy policy or show dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Privacy Policy',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            'StudyBot AI Privacy Policy\n\nWe are committed to protecting your privacy and ensuring the security of your personal information. This policy outlines how we collect, use, and protect your data when using our educational AI chatbot.\n\nData Collection:\n• Chat conversations for improving AI responses\n• Usage analytics for app optimization\n• Device information for technical support\n\nData Protection:\n• All conversations are encrypted on your device\n• No personal information is shared with third parties\n• Data is stored securely with industry-standard encryption\n\nYour Rights:\n• Request data deletion at any time\n• Export your conversation history\n• Opt-out of data collection for analytics\n\nContact us at privacy@studybotai.com for any questions.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _viewTermsOfService() {
    // Navigate to terms of service or show dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Terms of Service',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            'StudyBot AI Terms of Service\n\nBy using StudyBot AI, you agree to the following terms:\n\n1. Educational Use Only\nThis app is designed for educational purposes. Use it responsibly and in accordance with your institution\'s academic integrity policies.\n\n2. Content Accuracy\nWhile we strive for accuracy, AI responses should be verified with authoritative sources. We are not responsible for any academic consequences from relying solely on AI responses.\n\n3. Prohibited Uses\n• Cheating on exams or assignments\n• Generating content for academic dishonesty\n• Sharing inappropriate or harmful content\n\n4. Account Responsibility\nYou are responsible for maintaining the security of your account and all activities under your account.\n\n5. Service Availability\nWe aim for 99.9% uptime but cannot guarantee uninterrupted service.\n\nLast updated: September 9, 2025',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _contactSupport() {
    // Show contact support options
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Contact Support',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'email',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'Email Support',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                'support@studybotai.com',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showToast('Opening email client...');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'chat',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'Live Chat',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                'Available 24/7',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showToast('Starting live chat...');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'help',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'FAQ & Help Center',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                'Find answers to common questions',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showToast('Opening help center...');
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.inverseSurface,
      textColor: AppTheme.lightTheme.colorScheme.onInverseSurface,
      fontSize: 14.sp,
    );
  }
}
