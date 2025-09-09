import 'dart:convert';
import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_html/html.dart' as html;

import '../../core/app_export.dart';
import './widgets/chat_session_card.dart';
import './widgets/empty_state_widget.dart';
import './widgets/export_dialog_widget.dart';
import './widgets/search_bar_widget.dart';

class ChatHistory extends StatefulWidget {
  const ChatHistory({Key? key}) : super(key: key);

  @override
  State<ChatHistory> createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory>
    with TickerProviderStateMixin {
  final List<Map<String, dynamic>> _allSessions = [
    {
      "id": 1,
      "date": DateTime.now().subtract(const Duration(hours: 2)),
      "firstMessage": "Can you help me understand calculus derivatives?",
      "tags": ["Mathematics", "Calculus", "Homework"],
      "messageCount": 15,
      "isPinned": true,
      "messages": [
        {
          "role": "user",
          "content": "Can you help me understand calculus derivatives?"
        },
        {
          "role": "assistant",
          "content":
              "I'd be happy to help you understand derivatives! A derivative represents the rate of change of a function at any given point..."
        },
      ]
    },
    {
      "id": 2,
      "date": DateTime.now().subtract(const Duration(days: 1)),
      "firstMessage": "What are the main causes of World War I?",
      "tags": ["History", "World War I", "Essay"],
      "messageCount": 8,
      "isPinned": false,
      "messages": [
        {"role": "user", "content": "What are the main causes of World War I?"},
        {
          "role": "assistant",
          "content":
              "World War I had several interconnected causes, often remembered by the acronym MAIN: Militarism, Alliances, Imperialism, and Nationalism..."
        },
      ]
    },
    {
      "id": 3,
      "date": DateTime.now().subtract(const Duration(days: 2)),
      "firstMessage": "Explain photosynthesis process in plants",
      "tags": ["Biology", "Science", "Plants"],
      "messageCount": 12,
      "isPinned": false,
      "messages": [
        {"role": "user", "content": "Explain photosynthesis process in plants"},
        {
          "role": "assistant",
          "content":
              "Photosynthesis is the process by which plants convert light energy into chemical energy. It occurs in two main stages..."
        },
      ]
    },
    {
      "id": 4,
      "date": DateTime.now().subtract(const Duration(days: 3)),
      "firstMessage": "How do I solve quadratic equations?",
      "tags": ["Mathematics", "Algebra", "Equations"],
      "messageCount": 20,
      "isPinned": false,
      "messages": [
        {"role": "user", "content": "How do I solve quadratic equations?"},
        {
          "role": "assistant",
          "content":
              "There are several methods to solve quadratic equations. Let me show you the most common ones..."
        },
      ]
    },
    {
      "id": 5,
      "date": DateTime.now().subtract(const Duration(days: 5)),
      "firstMessage": "What is the structure of an atom?",
      "tags": ["Chemistry", "Physics", "Atoms"],
      "messageCount": 10,
      "isPinned": false,
      "messages": [
        {"role": "user", "content": "What is the structure of an atom?"},
        {
          "role": "assistant",
          "content":
              "An atom consists of three main particles: protons, neutrons, and electrons..."
        },
      ]
    },
    {
      "id": 6,
      "date": DateTime.now().subtract(const Duration(days: 7)),
      "firstMessage": "Explain Shakespeare's writing style",
      "tags": ["Literature", "Shakespeare", "English"],
      "messageCount": 18,
      "isPinned": false,
      "messages": [
        {"role": "user", "content": "Explain Shakespeare's writing style"},
        {
          "role": "assistant",
          "content":
              "Shakespeare's writing style is characterized by several distinctive features..."
        },
      ]
    },
  ];

  List<Map<String, dynamic>> _filteredSessions = [];
  String _searchQuery = '';
  String _selectedFilter = 'All Time';
  bool _isLoading = false;
  final Set<int> _selectedSessions = {};
  bool _isMultiSelectMode = false;

  @override
  void initState() {
    super.initState();
    _filteredSessions = List.from(_allSessions);
    _sortSessions();
  }

  void _sortSessions() {
    _filteredSessions.sort((a, b) {
      // Pinned sessions first
      if ((a['isPinned'] as bool? ?? false) &&
          !(b['isPinned'] as bool? ?? false)) {
        return -1;
      } else if (!(a['isPinned'] as bool? ?? false) &&
          (b['isPinned'] as bool? ?? false)) {
        return 1;
      }
      // Then by date (newest first)
      return (b['date'] as DateTime).compareTo(a['date'] as DateTime);
    });
  }

  void _filterSessions() {
    setState(() {
      _filteredSessions = _allSessions.where((session) {
        // Search filter
        if (_searchQuery.isNotEmpty) {
          final searchLower = _searchQuery.toLowerCase();
          final firstMessage =
              (session['firstMessage'] as String).toLowerCase();
          final tags =
              (session['tags'] as List).cast<String>().join(' ').toLowerCase();

          if (!firstMessage.contains(searchLower) &&
              !tags.contains(searchLower)) {
            return false;
          }
        }

        // Date filter
        final sessionDate = session['date'] as DateTime;
        final now = DateTime.now();

        switch (_selectedFilter) {
          case 'This Week':
            return now.difference(sessionDate).inDays <= 7;
          case 'This Month':
            return now.difference(sessionDate).inDays <= 30;
          default:
            return true;
        }
      }).toList();

      _sortSessions();
    });
  }

  void _onSearchChanged(String query) {
    _searchQuery = query;
    _filterSessions();
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    _filterSessions();
  }

  void _togglePin(int sessionId) {
    setState(() {
      final sessionIndex = _allSessions.indexWhere((s) => s['id'] == sessionId);
      if (sessionIndex != -1) {
        _allSessions[sessionIndex]['isPinned'] =
            !(_allSessions[sessionIndex]['isPinned'] as bool? ?? false);
      }
    });
    _filterSessions();

    final session = _allSessions.firstWhere((s) => s['id'] == sessionId);
    final isPinned = session['isPinned'] as bool;

    Fluttertoast.showToast(
      msg: isPinned ? 'Conversation pinned' : 'Conversation unpinned',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _deleteSession(int sessionId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Conversation',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this conversation? This action cannot be undone.',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _allSessions.removeWhere((s) => s['id'] == sessionId);
              });
              _filterSessions();
              Navigator.of(context).pop();

              Fluttertoast.showToast(
                msg: 'Conversation deleted',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text(
              'Delete',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.surface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openSession(Map<String, dynamic> session) {
    Navigator.pushNamed(context, '/chat-dashboard', arguments: session);
  }

  void _startNewChat() {
    Navigator.pushNamed(context, '/chat-dashboard');
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => ExportDialogWidget(
        onExport: _exportChatHistory,
      ),
    );
  }

  Future<void> _exportChatHistory(String format, String dateRange) async {
    setState(() => _isLoading = true);

    try {
      // Filter sessions based on date range
      List<Map<String, dynamic>> sessionsToExport = _allSessions;

      if (dateRange != 'All Time') {
        final now = DateTime.now();
        sessionsToExport = _allSessions.where((session) {
          final sessionDate = session['date'] as DateTime;
          switch (dateRange) {
            case 'This Week':
              return now.difference(sessionDate).inDays <= 7;
            case 'This Month':
              return now.difference(sessionDate).inDays <= 30;
            default:
              return true;
          }
        }).toList();
      }

      String content = '';
      String filename = 'chat_history_${DateTime.now().millisecondsSinceEpoch}';

      switch (format) {
        case 'PDF':
          content = _generatePDFContent(sessionsToExport);
          filename += '.pdf';
          break;
        case 'CSV':
          content = _generateCSVContent(sessionsToExport);
          filename += '.csv';
          break;
        case 'TXT':
          content = _generateTXTContent(sessionsToExport);
          filename += '.txt';
          break;
      }

      await _downloadFile(content, filename);

      Fluttertoast.showToast(
        msg: 'Chat history exported successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Export failed. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _downloadFile(String content, String filename) async {
    if (kIsWeb) {
      final bytes = utf8.encode(content);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", filename)
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      await file.writeAsString(content);
    }
  }

  String _generatePDFContent(List<Map<String, dynamic>> sessions) {
    final buffer = StringBuffer();
    buffer.writeln('StudyBot AI - Chat History Export');
    buffer.writeln('Generated on: ${DateTime.now().toString()}');
    buffer.writeln('=' * 50);
    buffer.writeln();

    for (final session in sessions) {
      buffer.writeln('Session Date: ${session['date']}');
      buffer.writeln('Message Count: ${session['messageCount']}');
      buffer.writeln('Tags: ${(session['tags'] as List).join(', ')}');
      buffer.writeln('First Message: ${session['firstMessage']}');
      buffer.writeln('-' * 30);
      buffer.writeln();
    }

    return buffer.toString();
  }

  String _generateCSVContent(List<Map<String, dynamic>> sessions) {
    final buffer = StringBuffer();
    buffer.writeln('Date,First Message,Tags,Message Count,Pinned');

    for (final session in sessions) {
      final date = session['date'].toString();
      final firstMessage = '"${session['firstMessage']}"';
      final tags = '"${(session['tags'] as List).join(', ')}"';
      final messageCount = session['messageCount'];
      final isPinned = session['isPinned'] ?? false;

      buffer.writeln('$date,$firstMessage,$tags,$messageCount,$isPinned');
    }

    return buffer.toString();
  }

  String _generateTXTContent(List<Map<String, dynamic>> sessions) {
    final buffer = StringBuffer();
    buffer.writeln('StudyBot AI - Chat History');
    buffer.writeln('Exported: ${DateTime.now()}');
    buffer.writeln();

    for (final session in sessions) {
      buffer.writeln('Date: ${session['date']}');
      buffer.writeln('Messages: ${session['messageCount']}');
      buffer.writeln('Tags: ${(session['tags'] as List).join(', ')}');
      buffer.writeln('Conversation: ${session['firstMessage']}');
      buffer.writeln();
      buffer.writeln('---');
      buffer.writeln();
    }

    return buffer.toString();
  }

  Future<void> _refreshSessions() async {
    setState(() => _isLoading = true);

    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isLoading = false);

    Fluttertoast.showToast(
      msg: 'Chat history refreshed',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _toggleMultiSelect(int? sessionId) {
    setState(() {
      if (sessionId == null) {
        _isMultiSelectMode = false;
        _selectedSessions.clear();
      } else {
        _isMultiSelectMode = true;
        if (_selectedSessions.contains(sessionId)) {
          _selectedSessions.remove(sessionId);
          if (_selectedSessions.isEmpty) {
            _isMultiSelectMode = false;
          }
        } else {
          _selectedSessions.add(sessionId);
        }
      }
    });
  }

  void _deleteSelectedSessions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete ${_selectedSessions.length} Conversations',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to delete the selected conversations? This action cannot be undone.',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _allSessions
                    .removeWhere((s) => _selectedSessions.contains(s['id']));
                _selectedSessions.clear();
                _isMultiSelectMode = false;
              });
              _filterSessions();
              Navigator.of(context).pop();

              Fluttertoast.showToast(
                msg: 'Selected conversations deleted',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text(
              'Delete',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.surface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          _isMultiSelectMode
              ? '${_selectedSessions.length} Selected'
              : 'Chat History',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        leading: _isMultiSelectMode
            ? IconButton(
                onPressed: () => _toggleMultiSelect(null),
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.textPrimary,
                  size: 24,
                ),
              )
            : null,
        actions: _isMultiSelectMode
            ? [
                IconButton(
                  onPressed: _deleteSelectedSessions,
                  icon: CustomIconWidget(
                    iconName: 'delete',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 24,
                  ),
                ),
              ]
            : [
                IconButton(
                  onPressed: _showExportDialog,
                  icon: CustomIconWidget(
                    iconName: 'file_download',
                    color: AppTheme.textPrimary,
                    size: 24,
                  ),
                ),
              ],
      ),
      body: _filteredSessions.isEmpty &&
              _searchQuery.isEmpty &&
              _selectedFilter == 'All Time'
          ? EmptyStateWidget(onStartChat: _startNewChat)
          : Column(
              children: [
                SearchBarWidget(
                  onSearchChanged: _onSearchChanged,
                  selectedFilter: _selectedFilter,
                  onFilterChanged: _onFilterChanged,
                ),
                Expanded(
                  child: _filteredSessions.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'search_off',
                                color: AppTheme.textSecondary,
                                size: 15.w,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'No conversations found',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'Try adjusting your search or filters',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _refreshSessions,
                          color: AppTheme.lightTheme.colorScheme.primary,
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: _filteredSessions.length,
                            itemBuilder: (context, index) {
                              final session = _filteredSessions[index];
                              final sessionId = session['id'] as int;
                              final isSelected =
                                  _selectedSessions.contains(sessionId);

                              return GestureDetector(
                                onLongPress: () =>
                                    _toggleMultiSelect(sessionId),
                                child: Container(
                                  decoration: isSelected
                                      ? BoxDecoration(
                                          color: AppTheme.lightTheme.colorScheme
                                              .primaryContainer
                                              .withValues(alpha: 0.3),
                                        )
                                      : null,
                                  child: Stack(
                                    children: [
                                      ChatSessionCard(
                                        session: session,
                                        onTap: _isMultiSelectMode
                                            ? () =>
                                                _toggleMultiSelect(sessionId)
                                            : () => _openSession(session),
                                        onPin: () => _togglePin(sessionId),
                                        onDelete: () =>
                                            _deleteSession(sessionId),
                                      ),
                                      if (isSelected)
                                        Positioned(
                                          top: 2.h,
                                          right: 6.w,
                                          child: Container(
                                            width: 6.w,
                                            height: 6.w,
                                            decoration: BoxDecoration(
                                              color: AppTheme.lightTheme
                                                  .colorScheme.primary,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: CustomIconWidget(
                                                iconName: 'check',
                                                color: AppTheme.lightTheme
                                                    .colorScheme.surface,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
      floatingActionButton: _isMultiSelectMode
          ? null
          : FloatingActionButton(
              onPressed: _startNewChat,
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              child: CustomIconWidget(
                iconName: 'add_comment',
                color: AppTheme.lightTheme.colorScheme.surface,
                size: 24,
              ),
            ),
    );
  }
}
