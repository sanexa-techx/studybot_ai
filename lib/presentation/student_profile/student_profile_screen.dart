import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/achievements_widget.dart';
import './widgets/learning_progress_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/profile_stats_widget.dart';
import './widgets/settings_section_widget.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({Key? key}) : super(key: key);

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  Map<String, dynamic> studentData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudentData();
  }

  Future<void> _loadStudentData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      setState(() {
        studentData = {
          'name': prefs.getString('user_name') ?? 'Student',
          'email': prefs.getString('user_email') ?? 'student@studybot.ai',
          'joinDate': prefs.getString('login_timestamp') ??
              DateTime.now().toIso8601String(),
          'studyStreak': prefs.getInt('study_streak') ?? 0,
          'totalSessions': prefs.getInt('total_sessions') ?? 0,
          'timeSpent': prefs.getInt('time_spent_minutes') ?? 0,
          'completedTopics': prefs.getInt('completed_topics') ?? 0,
          'level': _calculateLevel(prefs.getInt('total_sessions') ?? 0),
          'achievements': prefs.getStringList('achievements') ?? [],
          'favoriteSubjects': prefs.getStringList('favorite_subjects') ??
              ['Mathematics', 'Science'],
        };
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  int _calculateLevel(int sessions) {
    if (sessions < 10) return 1;
    if (sessions < 25) return 2;
    if (sessions < 50) return 3;
    if (sessions < 100) return 4;
    return 5;
  }

  Future<void> _handleLogout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Logout',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              // Clear all user data
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();

              if (mounted) {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.loginScreen,
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: Text(
              'Logout',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          'Student Profile',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showEditProfileDialog(),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            // Profile Header
            ProfileHeaderWidget(studentData: studentData),

            SizedBox(height: 3.h),

            // Profile Stats
            ProfileStatsWidget(studentData: studentData),

            SizedBox(height: 3.h),

            // Learning Progress
            LearningProgressWidget(studentData: studentData),

            SizedBox(height: 3.h),

            // Achievements
            AchievementsWidget(achievements: studentData['achievements']),

            SizedBox(height: 3.h),

            // Settings Section
            SettingsSectionWidget(onLogout: _handleLogout),

            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: studentData['name']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Edit Profile',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Display Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('user_name', nameController.text);

              setState(() {
                studentData['name'] = nameController.text;
              });

              Navigator.pop(context);
            },
            child: Text(
              'Save',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
