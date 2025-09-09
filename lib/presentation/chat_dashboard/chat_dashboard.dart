import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../services/openai_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/chat_input_widget.dart';
import './widgets/message_bubble_widget.dart';
import './widgets/quick_action_buttons_widget.dart';
import './widgets/typing_indicator_widget.dart';

class ChatDashboard extends StatefulWidget {
  const ChatDashboard({Key? key}) : super(key: key);

  @override
  State<ChatDashboard> createState() => _ChatDashboardState();
}

class _ChatDashboardState extends State<ChatDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  final OpenAIService _aiService = OpenAIService();

  List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;
  bool _isOnline = true;
  String _userName = 'Student';
  bool _isLoading = false;
  bool _isOpenAIConfigured = false;
  late OpenAIService _openAIClient;

  @override
  void initState() {
    super.initState();
    _openAIClient = _aiService;
    _isOpenAIConfigured = true; // Set based on your configuration logic
    _initializeChat();
    _loadUserData();
    _setupConnectivityListener();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'Student';
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeChat() {
    _tabController = TabController(length: 3, vsync: this);
    _messages = [
      {
        "id": 1,
        "message":
            "Hello! I'm StudyBot AI, your personal learning assistant. I'm here to help you with homework, explain concepts, provide study tips, and support your educational journey. What would you like to learn about today?",
        "isUser": false,
        "timestamp": DateTime.now().subtract(const Duration(minutes: 2)),
      },
    ];
  }

  void _setupConnectivityListener() {
    Connectivity().onConnectivityChanged.listen((connectivityResult) {
      setState(() {
        _isOnline = connectivityResult != ConnectivityResult.none;
      });
    });
  }

  void _showConfigurationError() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'OpenAI Configuration Required',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'OpenAI API key is not configured. The app will work with fallback responses for now. To enable full AI features, please configure the OPENAI_API_KEY environment variable.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Continue with Fallback'),
          ),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty || _isLoading) return;

    final userMessage = {
      "id": _messages.length + 1,
      "message": message.trim(),
      "isUser": true,
      "timestamp": DateTime.now(),
    };

    setState(() {
      _messages.insert(0, userMessage);
      _isLoading = true;
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    String aiResponse;

    try {
      if (_isOpenAIConfigured) {
        // Use real OpenAI API
        final response = await _openAIClient.getEducationalResponse(
          userMessage: message.trim(),
        );
        aiResponse = response.text;
      } else {
        // Fallback to mock responses
        await Future.delayed(const Duration(milliseconds: 1500));
        aiResponse = _getEducationalResponse(message.trim());
      }

      final aiMessage = {
        "id": _messages.length + 1,
        "message": aiResponse,
        "isUser": false,
        "timestamp": DateTime.now(),
      };

      setState(() {
        _messages.insert(0, aiMessage);
        _isTyping = false;
        _isLoading = false;
      });
    } catch (e) {
      print('Error getting AI response: $e');

      // Fallback to mock response on API error
      String fallbackResponse = _getEducationalResponse(message.trim());

      final aiMessage = {
        "id": _messages.length + 1,
        "message": fallbackResponse,
        "isUser": false,
        "timestamp": DateTime.now(),
      };

      setState(() {
        _messages.insert(0, aiMessage);
        _isTyping = false;
        _isLoading = false;
      });

      // Show error toast
      Fluttertoast.showToast(
        msg: "AI temporarily unavailable, using fallback response",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }

    _scrollToBottom();
  }

  String _getEducationalResponse(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('math') ||
        lowerMessage.contains('calculate') ||
        lowerMessage.contains('equation')) {
      return "I'd be happy to help with math! For specific problems, break them down step by step:\n\n1. Identify what you're solving for\n2. List the given information\n3. Choose the appropriate formula or method\n4. Work through the solution systematically\n\nWhat specific math topic or problem would you like help with?";
    } else if (lowerMessage.contains('study tips') ||
        lowerMessage.contains('how to study')) {
      return "Here are some effective study strategies:\n\n📚 **Active Learning**: Summarize concepts in your own words\n⏰ **Pomodoro Technique**: 25-minute focused study sessions\n📝 **Practice Testing**: Quiz yourself regularly\n🎯 **Spaced Repetition**: Review material at increasing intervals\n💡 **Teach Others**: Explain concepts to solidify understanding\n\nWhich subject are you studying? I can provide more specific tips!";
    } else if (lowerMessage.contains('explain') ||
        lowerMessage.contains('concept')) {
      return "I'd love to help explain concepts! To give you the best explanation, please tell me:\n\n• What specific topic or concept you'd like explained\n• Your current level (middle school, high school, college)\n• Any particular part that's confusing you\n\nI'll break it down into simple, easy-to-understand steps with examples!";
    } else if (lowerMessage.contains('homework') ||
        lowerMessage.contains('assignment')) {
      return "I'm here to help guide you through your homework! Here's how we can work together:\n\n✅ **Understanding**: I'll help clarify confusing concepts\n🔍 **Problem-solving**: We'll work through problems step-by-step\n💡 **Study strategies**: I'll suggest effective approaches\n📖 **Resources**: I can recommend additional learning materials\n\nWhat subject is your homework in? Share the specific question or topic you're working on!";
    } else {
      return "Thanks for your question! I'm StudyBot AI, and I'm here to help with:\n\n📚 **Academic subjects** (Math, Science, History, English, etc.)\n💡 **Concept explanations** in simple terms\n📝 **Study strategies** and learning techniques\n🎯 **Homework guidance** and problem-solving\n📖 **Research assistance** and study planning\n\nWhat would you like to explore today? Feel free to ask about any subject or study challenge you're facing!";
    }
  }

  void _handleQuickAction(String action) {
    _sendMessage(action);
  }

  void _handleVoiceInput() {
    Navigator.pushNamed(context, '/voice-input-interface');
  }

  void _showMessageOptions(String message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 1.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2.w),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'copy',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text(
                'Copy Message',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              onTap: () {
                Clipboard.setData(ClipboardData(text: message));
                Navigator.pop(context);
                Fluttertoast.showToast(
                  msg: "Message copied to clipboard",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text(
                'Share Message',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              onTap: () {
                Navigator.pop(context);
                Fluttertoast.showToast(
                  msg: "Share functionality coming soon",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'bookmark_add',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text(
                'Save to Notes',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              onTap: () {
                Navigator.pop(context);
                Fluttertoast.showToast(
                  msg: "Message saved to notes",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _startNewChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Start New Chat',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'This will clear your current conversation. Are you sure?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _messages.clear();
                _messages.add({
                  "id": 1,
                  "message":
                      "Hello! I'm StudyBot AI, your personal learning assistant. I'm here to help you with homework, explain concepts, provide study tips, and support your educational journey. What would you like to learn about today?",
                  "isUser": false,
                  "timestamp": DateTime.now(),
                });
              });
              Navigator.pop(context);
            },
            child: Text('Start New'),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshMessages() async {
    await Future.delayed(const Duration(seconds: 1));
    // In a real app, this would load older messages from the server
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'StudyBot AI',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              _isOnline ? 'Online' : 'Offline',
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                color: _isOnline ? AppTheme.success : AppTheme.error,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.studentProfile),
            icon: Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primary, AppTheme.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Text(
                  _userName.isNotEmpty ? _userName[0].toUpperCase() : 'S',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.chatHistory),
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Chat Tab
          Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshMessages,
                  child: ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    itemCount: _messages.length + (_isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (_isTyping && index == 0) {
                        return const TypingIndicatorWidget();
                      }

                      final messageIndex = _isTyping ? index - 1 : index;
                      final message = _messages[messageIndex];

                      return MessageBubbleWidget(
                        message: message['message'] as String,
                        isUser: message['isUser'] as bool,
                        timestamp: message['timestamp'] as DateTime,
                        onLongPress: !(message['isUser'] as bool)
                            ? () => _showMessageOptions(
                                message['message'] as String)
                            : null,
                      );
                    },
                  ),
                ),
              ),
              QuickActionButtonsWidget(
                onQuickAction: _handleQuickAction,
              ),
              ChatInputWidget(
                controller: _messageController,
                onSend: () => _sendMessage(_messageController.text),
                onVoiceInput: _handleVoiceInput,
                isLoading: _isLoading,
              ),
            ],
          ),
          // History Tab
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'history',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 15.w,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Chat History',
                  style: AppTheme.lightTheme.textTheme.headlineSmall,
                ),
                SizedBox(height: 1.h),
                Text(
                  'Your conversation history will appear here',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 3.h),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/chat-history'),
                  child: Text('View Full History'),
                ),
              ],
            ),
          ),
          // Settings Tab
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'settings',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 15.w,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Settings',
                  style: AppTheme.lightTheme.textTheme.headlineSmall,
                ),
                SizedBox(height: 1.h),
                Text(
                  'Customize your StudyBot experience',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 3.h),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/settings-panel'),
                  child: Text('Open Settings'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}