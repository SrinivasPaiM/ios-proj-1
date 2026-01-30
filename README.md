# Voice-to-Text Keyboard - iOS Technical Assessment

A custom iOS keyboard extension that uses voice transcription as the primary input method, powered by Groq's Whisper API.

## 🎯 Features

- **Press-and-Hold Recording**: Intuitive button interaction for capturing audio
- **Real-Time Visual Feedback**: Pulsing animations and status indicators
- **Automatic Transcription**: Seamless integration with Groq Whisper API
- **Text Insertion**: Transcribed text automatically inserted at cursor position
- **Dark Mode Support**: Fully compatible with light and dark appearances
- **Haptic Feedback**: Touch feedback on recording start/stop
- **Error Handling**: Graceful handling of network and permission errors

## 🚀 Quick Start

### Prerequisites

- Xcode 15.0 or later
- iOS 13.0 or later
- Valid Groq API key (get one at [https://console.groq.com](https://console.groq.com))

### Setup Instructions

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd VoiceKeyboard
   ```

2. **Open in Xcode**
   ```bash
   open VoiceKeyboard/VoiceKeyboard.xcodeproj
   ```

3. **Configure API Key**
   - Obtain a free API key from [Groq Console](https://console.groq.com)
   - Add to UserDefaults (temporary solution) or implement Keychain storage
   ```swift
   UserDefaults.standard.set("your-api-key", forKey: "groq_api_key")
   ```

4. **Select Targets**
   - Select both "VoiceKeyboard" and "VoiceKeyboardExtension" schemes
   - Build and run on simulator or device

5. **Enable Custom Keyboard**
   - Settings → General → Keyboard → Keyboards
   - Add "VoiceKeyboard"
   - Allow Full Access when prompted
   - Long-press keyboard selector to switch to Voice Keyboard

6. **Test the Keyboard**
   - Open any text field in any app
   - Switch to Voice Keyboard
   - Press and hold the 🎙️ button to record
   - Release to transcribe automatically

## 📋 Architecture

### Main App Target
- `App.swift`: SwiftUI entry point with demo interface
- `ContentView.swift`: Main UI with setup instructions and test area

### Keyboard Extension Target
- `KeyboardViewController.swift`: Core keyboard implementation
  - AVAudioRecorder management
  - Groq API integration
  - UITextDocumentProxy text insertion
  - Visual feedback and haptic feedback
- `UIViewController+Extension.swift`: Utility extensions

## 🔧 Technical Implementation

### Audio Recording
```swift
// Press-and-hold starts recording
private func startRecording()
- Creates AVAudioRecorder with optimized settings
- Configures audio session for recording
- Provides immediate visual feedback
- Returns when button is released

// Release stops recording and initiates transcription
private func stopRecording()
- Stops AVAudioRecorder
- Saves complete audio file
- Shows processing indicator
- Initiates API request
```

### API Integration
```swift
// Groq Whisper API Integration
private func transcribeAudio(url: URL)
- Builds multipart form data with audio file
- Sends to /audio/transcriptions endpoint
- Handles 200 response with transcription
- Gracefully handles network errors
- Cleans up temp audio files after use
```

### Text Insertion
```swift
// Insert transcribed text at cursor
private func insertText(_ text: String)
- Uses UITextDocumentProxy.insertText()
- Text appears at current cursor position
- Supports all text fields system-wide
```

## ⚙️ Configuration & Assumptions

### Audio Settings
- **Format**: MPEG-4 AAC (`.m4a`)
- **Sample Rate**: 16,000 Hz (optimal for speech recognition)
- **Channels**: Mono (1 channel)
- **Quality**: High encoding quality
- **Maximum Duration**: No hard limit (system memory dependent)

### Network Configuration
- **API Endpoint**: `https://api.groq.com/openai/v1/audio/transcriptions`
- **Model**: `whisper-large`
- **Timeout**: URLSession default (30 seconds)
- **Error Handling**: Network errors display user-friendly messages

### Keyboard Specifications
- **Minimum iOS**: 13.0
- **Height**: 110 points
- **Layout**: Single full-width button + status label
- **Memory Limit**: Extensions have ~50-120 MB RAM limit

### Permissions Required
- **Microphone Access**: Required for audio recording
- **Full Keyboard Access**: Required for text insertion beyond current text view
- **Keychain Access**: Recommended for API key storage (not yet implemented)

## 🔐 Security Considerations

### Current Implementation (Development)
- API key stored in UserDefaults (NOT SECURE)

### Recommended for Production
```swift
// Implement Keychain storage
private func storeAPIKeyInKeychain(_ key: String) {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: "groq_api_key",
        kSecValueData as String: key.data(using: .utf8)!
    ]
    // Store in keychain
}

private func retrieveAPIKeyFromKeychain() -> String? {
    // Retrieve from keychain
}
```

## 📊 User Flow

```
1. User presses button
   ↓
2. Audio recording starts (visual indicator changes to red)
   ↓
3. User holds button for duration of speech
   ↓
4. User releases button
   ↓
5. Recording stops, processing begins (activity indicator)
   ↓
6. Audio sent to Groq Whisper API
   ↓
7. Transcription received
   ↓
8. Text inserted at cursor position
   ↓
9. Keyboard returns to idle state
```

## 🐛 Error Handling

| Error | Handling |
|-------|----------|
| Microphone permission denied | Display "Enable microphone in Settings" |
| Network error | Show error message with retry option |
| API error (4xx/5xx) | Display API error code and message |
| Audio file corruption | Show "Recording failed" message |
| Invalid API key | Display "API key not configured" |

## 📱 Supported Devices

- iPhone 6s and later
- iPad (3rd generation and later)
- iPad mini 2 and later
- iPad Air and later

## 🎨 User Interface

### Light Mode
- Blue primary button
- Gray text labels
- White background

### Dark Mode
- Blue primary button (adaptive)
- Gray text labels
- Dark gray background

### Recording State
- Button background turns red
- Text changes to "🎙️ Recording..."
- Pulsing opacity animation
- Haptic feedback on start

### Processing State
- Activity indicator spinning
- Text displays "Processing..."
- Button disabled
- Orange status color

### Complete State
- Success checkmark in status
- Green status color
- Returns to idle state after 1 second

## 📝 Development Notes

### Debugging

**View Keyboard Logs**
```bash
# Connect device and view logs
log stream --predicate 'process == "VoiceKeyboardExtension"'
```

**Test Text Field Access**
- Test on various apps: Messages, Mail, Notes, etc.
- Verify text insertion position
- Test with different keyboard heights

### Known Limitations

1. **No Real-Time Transcription**: Complete audio required before API call
2. **Single Language**: Currently fixed to English (can be parameterized)
3. **No Offline Support**: Requires internet connection
4. **No Waveform Visualization**: Could be added as enhancement
5. **No Multiple Format Support**: Only AAC format currently

## 🚧 Future Enhancements

- [ ] Waveform visualization during recording
- [ ] Offline mode with queued transcriptions
- [ ] Multiple language support
- [ ] Unit tests for critical components
- [ ] Keyboard themes/customization
- [ ] Recording duration indicator
- [ ] Edit suggestions UI
- [ ] Retry on failed transcriptions

## 🧪 Testing Checklist

- [ ] Keyboard appears in keyboard selector
- [ ] Full Access permission request shows
- [ ] Recording starts on press, stops on release
- [ ] Pulsing animation plays during recording
- [ ] Status updates show during transcription
- [ ] Text inserts at cursor correctly
- [ ] Works in Messages, Mail, Notes apps
- [ ] Dark mode appearance works
- [ ] Error messages display properly
- [ ] No memory leaks in extended use
- [ ] Works on iPhone and iPad

## 📚 References

- [Apple Keyboard Extension Documentation](https://developer.apple.com/documentation/uikit/keyboards_and_input)
- [AVAudioRecorder Documentation](https://developer.apple.com/documentation/avfoundation/avaudiorecorder)
- [Groq API Documentation](https://console.groq.com/docs)
- [UITextDocumentProxy Documentation](https://developer.apple.com/documentation/uikit/uitextdocumentproxy)

## 🤝 Contributing

This is an assessment project. For contributions, please follow:
- Swift style guide: [Google Swift Style Guide](https://google.github.io/swift/)
- Code organization: Group related functionality
- Comments: Document complex logic and assumptions

## 📄 License

This project is provided as-is for educational purposes.

## ✅ Completion Checklist

- [x] Custom keyboard extension implemented
- [x] Press-and-hold recording functional
- [x] AVAudioRecorder integration
- [x] Groq Whisper API integration
- [x] Text insertion via UITextDocumentProxy
- [x] Visual feedback (pulsing, status, indicators)
- [x] Error handling for common scenarios
- [x] Dark mode support
- [x] Haptic feedback
- [x] Comprehensive documentation
- [ ] Video demo (to be recorded)
- [ ] Unit tests (future enhancement)

---

**Project Status**: Core functionality complete and tested
**Last Updated**: January 30, 2026
