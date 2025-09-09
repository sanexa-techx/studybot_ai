import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/permission_error_widget.dart';
import './widgets/transcription_display_widget.dart';
import './widgets/voice_control_button_widget.dart';
import './widgets/waveform_visualizer_widget.dart';

class VoiceInputInterface extends StatefulWidget {
  const VoiceInputInterface({Key? key}) : super(key: key);

  @override
  State<VoiceInputInterface> createState() => _VoiceInputInterfaceState();
}

class _VoiceInputInterfaceState extends State<VoiceInputInterface>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  bool _isTranscribing = false;
  bool _hasPermission = false;
  String _transcriptionText = '';
  String _errorMessage = '';
  double _currentAmplitude = 0.0;
  Timer? _amplitudeTimer;
  String? _recordingPath;

  // Mock transcription data for demonstration
  final List<String> _mockTranscriptions = [
    "What is the formula for calculating the area of a circle?",
    "Can you explain photosynthesis in simple terms?",
    "How do I solve quadratic equations?",
    "What are the main causes of World War II?",
    "Explain the difference between mitosis and meiosis",
    "How does machine learning work?",
    "What is the Pythagorean theorem?",
    "Can you help me with calculus derivatives?",
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkPermissions();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _slideController.forward();
  }

  Future<void> _checkPermissions() async {
    try {
      if (kIsWeb) {
        setState(() {
          _hasPermission = true;
        });
        return;
      }

      final status = await Permission.microphone.status;
      if (status.isGranted) {
        setState(() {
          _hasPermission = true;
        });
      } else {
        final result = await Permission.microphone.request();
        setState(() {
          _hasPermission = result.isGranted;
          if (!result.isGranted) {
            _errorMessage =
                'Microphone permission is required for voice input. Please enable it in your device settings.';
          }
        });
      }
    } catch (e) {
      setState(() {
        _hasPermission = false;
        _errorMessage =
            'Unable to access microphone. Please check your device settings.';
      });
    }
  }

  Future<void> _startRecording() async {
    if (!_hasPermission) {
      await _checkPermissions();
      return;
    }

    try {
      setState(() {
        _isRecording = true;
        _transcriptionText = '';
        _errorMessage = '';
      });

      if (await _audioRecorder.hasPermission()) {
        String path;
        if (kIsWeb) {
          path = 'recording.wav';
          await _audioRecorder.start(
            const RecordConfig(encoder: AudioEncoder.wav),
            path: path,
          );
        } else {
          final directory = await getTemporaryDirectory();
          path =
              '${directory.path}/voice_recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
          await _audioRecorder.start(
            const RecordConfig(encoder: AudioEncoder.aacLc),
            path: path,
          );
        }

        _recordingPath = path;
        _startAmplitudeMonitoring();
        _startMockTranscription();
      } else {
        throw Exception('Microphone permission denied');
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
        _errorMessage = 'Failed to start recording. Please try again.';
      });
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      _stopAmplitudeMonitoring();

      setState(() {
        _isRecording = false;
        _isTranscribing = false;
      });

      if (path != null) {
        _recordingPath = path;
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
        _isTranscribing = false;
        _errorMessage = 'Failed to stop recording. Please try again.';
      });
    }
  }

  void _startAmplitudeMonitoring() {
    _amplitudeTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_isRecording) {
        setState(() {
          _currentAmplitude = 0.3 + (math.Random().nextDouble() * 0.7);
        });
      }
    });
  }

  void _stopAmplitudeMonitoring() {
    _amplitudeTimer?.cancel();
    _amplitudeTimer = null;
    setState(() {
      _currentAmplitude = 0.0;
    });
  }

  void _startMockTranscription() {
    setState(() {
      _isTranscribing = true;
    });

    Timer(const Duration(seconds: 2), () {
      if (_isRecording) {
        final randomTranscription = _mockTranscriptions[
            math.Random().nextInt(_mockTranscriptions.length)];

        _simulateTypingEffect(randomTranscription);
      }
    });
  }

  void _simulateTypingEffect(String fullText) {
    int currentIndex = 0;
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (currentIndex < fullText.length && _isRecording) {
        setState(() {
          _transcriptionText = fullText.substring(0, currentIndex + 1);
        });
        currentIndex++;
      } else {
        timer.cancel();
        setState(() {
          _isTranscribing = false;
        });
      }
    });
  }

  void _toggleRecording() {
    if (_isRecording) {
      _stopRecording();
    } else {
      _startRecording();
    }
  }

  void _sendTranscription() {
    if (_transcriptionText.isNotEmpty) {
      Navigator.pop(context, _transcriptionText);
    }
  }

  void _cancelVoiceInput() {
    if (_isRecording) {
      _stopRecording();
    }
    Navigator.pop(context);
  }

  void _retryPermission() {
    _checkPermissions();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _amplitudeTimer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _cancelVoiceInput,
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.shadowLight,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: CustomIconWidget(
                            iconName: 'arrow_back',
                            color: AppTheme.textPrimary,
                            size: 6.w,
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          'Voice Input',
                          style: AppTheme.lightTheme.textTheme.titleLarge
                              ?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: !_hasPermission && _errorMessage.isNotEmpty
                      ? Center(
                          child: PermissionErrorWidget(
                            errorMessage: _errorMessage,
                            onRetry: _retryPermission,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),

                            // Waveform Visualizer
                            WaveformVisualizerWidget(
                              isRecording: _isRecording,
                              amplitude: _currentAmplitude,
                            ),

                            SizedBox(height: 6.h),

                            // Voice Control Button
                            VoiceControlButtonWidget(
                              isRecording: _isRecording,
                              onTap: _toggleRecording,
                              buttonText: _isRecording
                                  ? 'Stop Recording'
                                  : 'Tap to Speak',
                            ),

                            SizedBox(height: 2.h),

                            // Button Label
                            Text(
                              _isRecording ? 'Recording...' : 'Tap to Speak',
                              style: AppTheme.lightTheme.textTheme.bodyLarge
                                  ?.copyWith(
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const Spacer(),

                            // Transcription Display
                            TranscriptionDisplayWidget(
                              transcriptionText: _transcriptionText,
                              isTranscribing: _isTranscribing,
                            ),

                            SizedBox(height: 4.h),

                            // Action Buttons
                            ActionButtonsWidget(
                              onCancel: _cancelVoiceInput,
                              onSend: _sendTranscription,
                              canSend: _transcriptionText.isNotEmpty &&
                                  !_isRecording,
                            ),

                            SizedBox(height: 4.h),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
