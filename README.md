# StudyBot AI - Your Personal Learning Assistant

A Flutter application powered by OpenAI that helps students with homework, explains concepts, provides study tips, and supports educational journeys with AI-powered conversations.

## Features

- **AI-Powered Chat**: Intelligent conversations with StudyBot AI using OpenAI's GPT models
- **Educational Focus**: Specialized for academic subjects, homework help, and study strategies
- **Voice Input**: Voice-to-text functionality for hands-free interaction
- **Chat History**: Save and review previous conversations
- **Settings Panel**: Customize your learning experience
- **Responsive Design**: Optimized for mobile and web platforms

## OpenAI Integration

This app integrates with OpenAI's API to provide intelligent educational assistance. When properly configured, it uses real AI responses. It also includes fallback responses when the API is unavailable.

### Configuration

To enable OpenAI features, you need to configure your API key:

1. **Get an OpenAI API Key**:
   - Visit [OpenAI API Keys](https://platform.openai.com/api-keys)
   - Sign up or log in to your OpenAI account
   - Create a new API key
   - Copy the API key for use in the next step

2. **Configure Environment Variables**:
   The app uses environment variables for secure API key storage. Use the `--dart-define` flag when running or building:

   ```bash
   # For development
   flutter run --dart-define=OPENAI_API_KEY=your_actual_api_key_here
   
   # For release build
   flutter build apk --dart-define=OPENAI_API_KEY=your_actual_api_key_here
   ```

3. **Alternative Configuration (env.json)**:
   You can also update the `env.json` file with your API key:
   ```json
   {
     "OPENAI_API_KEY": "your_actual_api_key_here"
   }
   ```

### AI Models Used

- **Primary Model**: GPT-4o-mini for optimal balance of performance and cost
- **Educational Context**: Specialized system prompts for academic assistance
- **Fallback**: Local responses when API is unavailable

## Getting Started

### Prerequisites

- Flutter SDK 3.10 or higher
- Dart 3.0 or higher
- OpenAI API key (optional but recommended)

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd studybot_ai
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Configure OpenAI API key (see Configuration section above)

4. Run the application:
   ```bash
   flutter run --dart-define=OPENAI_API_KEY=your_api_key
   ```

### Building for Production

```bash
# Android
flutter build apk --dart-define=OPENAI_API_KEY=your_api_key

# iOS
flutter build ios --dart-define=OPENAI_API_KEY=your_api_key

# Web
flutter build web --dart-define=OPENAI_API_KEY=your_api_key
```

## Project Structure

```
lib/
├── core/
│   └── app_export.dart          # Core exports and constants
├── presentation/
│   ├── chat_dashboard/          # Main chat interface
│   ├── chat_history/            # Conversation history
│   ├── settings_panel/          # App settings
│   ├── splash_screen/           # App startup screen
│   └── voice_input_interface/   # Voice input functionality
├── services/
│   └── openai_service.dart      # OpenAI API integration
├── theme/
│   └── app_theme.dart           # App theming and styles
├── widgets/                     # Reusable UI components
└── main.dart                    # Application entry point
```

## Key Features

### AI-Powered Education
- **Subject Help**: Math, Science, History, English, and more
- **Step-by-Step Guidance**: Breaks down complex problems
- **Study Strategies**: Personalized learning tips
- **Homework Assistance**: Guided problem-solving

### User Experience
- **Voice Input**: Speak your questions naturally
- **Real-time Typing**: See AI responses as they're generated
- **Message History**: Review past conversations
- **Mobile-Optimized**: Designed for smartphone usage

### Technical Features
- **OpenAI Integration**: Real AI-powered responses
- **Error Handling**: Graceful fallbacks when API is unavailable
- **Environment Security**: API keys stored securely
- **Cross-Platform**: Works on Android, iOS, and Web

## API Usage and Costs

This app uses OpenAI's API, which has usage-based pricing:

- **GPT-4o-mini**: Cost-effective model for most educational queries
- **Token Limits**: Responses limited to ~500 tokens for mobile optimization
- **Rate Limiting**: Built-in error handling for API limits

Monitor your usage on the [OpenAI Dashboard](https://platform.openai.com/usage).

## Fallback Mode

When OpenAI is not configured or unavailable, the app operates in fallback mode:

- Pre-written educational responses for common topics
- Study tips and general guidance
- Full UI functionality maintained
- Seamless transition between AI and fallback responses

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, feature requests, or bug reports, please open an issue on the repository.

## Acknowledgments

- OpenAI for providing the AI capabilities
- Flutter team for the amazing framework
- Contributors and beta testers

---

**Note**: This application requires an active internet connection and OpenAI API access for full functionality. Ensure your API key has sufficient credits and proper permissions.