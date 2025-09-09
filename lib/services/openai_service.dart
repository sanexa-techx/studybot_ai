import 'package:dio/dio.dart';
import 'dart:convert';

/// OpenAI Service - Singleton pattern for managing OpenAI API interactions
class OpenAIService {
  static final OpenAIService _instance = OpenAIService._internal();
  late final Dio _dio;
  static const String apiKey = String.fromEnvironment('OPENAI_API_KEY');

  // Factory constructor to return the singleton instance
  factory OpenAIService() {
    return _instance;
  }

  // Private constructor for singleton pattern
  OpenAIService._internal() {
    _initializeService();
  }

  void _initializeService() {
    // Load API key from environment variables
    if (apiKey.isEmpty) {
      throw Exception('OPENAI_API_KEY must be provided via --dart-define');
    }

    // Configure Dio with base URL and headers
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.openai.com/v1',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
  }

  Dio get dio => _dio;

  /// Validates that the service is properly configured
  bool get isConfigured => apiKey.isNotEmpty;
}

/// OpenAI Client - Main class for interacting with OpenAI API
class OpenAIClient {
  final Dio dio;

  OpenAIClient(this.dio);

  /// Standard chat completion with GPT models
  Future<Completion> createChatCompletion({
    required List<Message> messages,
    String model = 'gpt-4o-mini', // Using available model as default
    Map<String, dynamic>? options,
  }) async {
    try {
      final requestData = <String, dynamic>{
        'model': model,
        'messages': messages
            .map((m) => {
                  'role': m.role,
                  'content': m.content,
                })
            .toList(),
      };

      // Add options if provided
      if (options != null) {
        requestData.addAll(options);
      }

      final response = await dio.post('/chat/completions', data: requestData);

      final text = response.data['choices'][0]['message']['content'];
      return Completion(text: text);
    } on DioException catch (e) {
      throw OpenAIException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data?['error']?['message'] ??
            e.message ??
            'Unknown error',
      );
    }
  }

  /// Streams a text response for real-time chat
  Stream<StreamCompletion> streamChatCompletion({
    required List<Message> messages,
    String model = 'gpt-4o-mini',
    Map<String, dynamic>? options,
  }) async* {
    try {
      final requestData = <String, dynamic>{
        'model': model,
        'messages': messages
            .map((m) => {
                  'role': m.role,
                  'content': m.content,
                })
            .toList(),
        'stream': true,
      };

      if (options != null) {
        requestData.addAll(options);
      }

      final response = await dio.post(
        '/chat/completions',
        data: requestData,
        options: Options(responseType: ResponseType.stream),
      );

      final stream = response.data.stream;
      await for (var line
          in LineSplitter().bind(utf8.decoder.bind(stream.stream))) {
        if (line.startsWith('data: ')) {
          final data = line.substring(6);
          if (data == '[DONE]') break;

          try {
            final json = jsonDecode(data) as Map<String, dynamic>;
            final delta = json['choices'][0]['delta'] as Map<String, dynamic>;
            final content = delta['content'] ?? '';
            final finishReason = json['choices'][0]['finish_reason'];
            final systemFingerprint = json['system_fingerprint'];

            yield StreamCompletion(
              content: content,
              finishReason: finishReason,
              systemFingerprint: systemFingerprint,
            );

            if (finishReason != null) break;
          } catch (e) {
            // Skip malformed JSON lines
            continue;
          }
        }
      }
    } on DioException catch (e) {
      throw OpenAIException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data?['error']?['message'] ??
            e.message ??
            'Unknown error',
      );
    }
  }

  /// User-friendly wrapper for streaming that yields content strings
  Stream<String> streamContentOnly({
    required List<Message> messages,
    String model = 'gpt-4o-mini',
    Map<String, dynamic>? options,
  }) async* {
    await for (final chunk in streamChatCompletion(
      messages: messages,
      model: model,
      options: options,
    )) {
      if (chunk.content.isNotEmpty) {
        yield chunk.content;
      }
    }
  }

  /// Get educational response with proper context for StudyBot
  Future<Completion> getEducationalResponse({
    required String userMessage,
    String model = 'gpt-4o-mini',
  }) async {
    final messages = [
      Message(
        role: 'system',
        content:
            '''You are StudyBot AI, a helpful educational assistant designed specifically for students. Your role is to:

1. Help with academic subjects (Math, Science, History, English, etc.)
2. Explain complex concepts in simple, easy-to-understand terms
3. Provide study tips and learning strategies
4. Guide students through homework problems step-by-step
5. Offer encouragement and motivation for learning

Guidelines:
- Keep responses concise and mobile-friendly (usually 2-4 paragraphs)
- Use emojis sparingly but effectively to make content engaging
- Break down complex problems into manageable steps
- Ask clarifying questions when needed
- Always be encouraging and supportive
- Focus on helping students learn rather than just giving answers

Remember, you're talking to students, so keep your language accessible and friendly.''',
      ),
      Message(
        role: 'user',
        content: userMessage,
      ),
    ];

    return await createChatCompletion(
      messages: messages,
      model: model,
      options: {
        'max_tokens': 500,
        'temperature': 0.7,
      },
    );
  }
}

/// Message class for OpenAI API
class Message {
  final String role;
  final dynamic content;

  Message({required this.role, required this.content});
}

/// Completion response class
class Completion {
  final String text;

  Completion({required this.text});
}

/// Stream completion class for real-time responses
class StreamCompletion {
  final String content;
  final String? finishReason;
  final String? systemFingerprint;

  StreamCompletion({
    required this.content,
    this.finishReason,
    this.systemFingerprint,
  });
}

/// OpenAI exception class for error handling
class OpenAIException implements Exception {
  final int statusCode;
  final String message;

  OpenAIException({required this.statusCode, required this.message});

  @override
  String toString() => 'OpenAI API Error ($statusCode): $message';
}
