# VoiceKeyboard - iOS Keyboard Extension with Voice Transcription

A production-grade iOS keyboard extension that transcribes voice to text using Groq's Whisper API.

## ⚡ Quick Links

- **[README.md](README.md)** - Complete setup and usage guide
- **[TECHNICAL_BLOG.md](TECHNICAL_BLOG.md)** - Deep technical write-up
- **[ASSUMPTIONS.md](ASSUMPTIONS.md)** - Design decisions and assumptions
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Development guidelines

## 🎯 What This Does

Press and hold a button → Record voice → Release → Automatic transcription → Text appears

## 📋 Features

- ✅ Press-and-hold audio recording
- ✅ Real-time visual feedback (pulsing, status updates)
- ✅ Groq Whisper API integration
- ✅ Automatic text insertion
- ✅ Dark mode support
- ✅ Haptic feedback
- ✅ Comprehensive error handling
- ✅ Works in any text field (Messages, Mail, Notes, etc.)

## 🚀 Getting Started

```bash
# Clone the repo
git clone https://github.com/yourname/VoiceKeyboard.git
cd VoiceKeyboard

# Open in Xcode
open VoiceKeyboard/VoiceKeyboard.xcodeproj
```

### Setup Steps (5 minutes)

1. Get a free API key from [Groq Console](https://console.groq.com)
2. Configure bundle identifiers (Team ID)
3. Add API key to UserDefaults (or implement Keychain)
4. Build and run
5. Enable keyboard in Settings → General → Keyboard → Keyboards

**See [README.md](README.md) for detailed setup.**

## 📁 Project Structure

```
VoiceKeyboard/
├── VoiceKeyboard/                      # Main app
│   ├── App.swift                       # SwiftUI entry point
│   └── ContentView.swift               # Demo UI
├── VoiceKeyboardExtension/             # Keyboard extension
│   ├── KeyboardViewController.swift     # Core implementation
│   └── UIViewController+Extension.swift # Helpers
├── README.md                           # Setup guide
├── TECHNICAL_BLOG.md                   # Architecture deep-dive
├── ASSUMPTIONS.md                      # Design decisions
├── CONTRIBUTING.md                     # Development guidelines
└── INFO_PLIST_REFERENCE.md            # Configuration reference
```

## 🔑 Core Implementation

### Recording (Press-and-Hold)

```swift
@objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
    switch gesture.state {
    case .began:
        startRecording()     // Red button, pulsing
    case .ended, .cancelled:
        stopRecording()      // Stop, send to API
    default:
        break
    }
}
```

### Transcription (API Call)

```swift
private func transcribeAudio(url: URL) {
    // Build multipart form data
    // POST to https://api.groq.com/openai/v1/audio/transcriptions
    // Handle response → insert text
}
```

### Text Insertion

```swift
private func insertText(_ text: String) {
    textDocumentProxy.insertText(text)  // System handles cursor position
}
```

## 📊 Technical Specs

| Component | Detail |
|-----------|--------|
| **Min iOS** | 13.0 |
| **Audio Format** | MPEG-4 AAC (16kHz, mono) |
| **API** | Groq Whisper |
| **Keyboard Height** | 110pt |
| **Memory Target** | < 50MB |
| **Network** | URLSession with multipart |

**See [ASSUMPTIONS.md](ASSUMPTIONS.md) for detailed specs.**

## ⚙️ Configuration

### API Key (Development)

```swift
// Temporary solution (NOT SECURE)
UserDefaults.standard.set("your-api-key", forKey: "groq_api_key")
```

### For Production

Implement Keychain storage (see [README.md](README.md) for pattern)

## 🧪 Testing

```
✓ iPhone simulator
✓ iPad simulator  
✓ Dark mode
✓ Messages, Mail, Notes apps
✓ Memory profiling
✗ Real microphone (simulator limitation)
```

## 📚 Documentation

- **[README.md](README.md)** - 50+ section guide with workflow diagrams, error handling table, device compatibility
- **[TECHNICAL_BLOG.md](TECHNICAL_BLOG.md)** - 6000+ word deep-dive into architecture, audio processing, API integration
- **[ASSUMPTIONS.md](ASSUMPTIONS.md)** - Detailed design decisions for every subsystem
- **[INFO_PLIST_REFERENCE.md](INFO_PLIST_REFERENCE.md)** - Complete plist configuration

## 🎨 UI/UX Flow

```
IDLE                RECORDING            PROCESSING           COMPLETE
(Blue button)    → (Red pulsing)      → (Activity spinner) → (Green checkmark)
"Press to Record"   "Recording..."      "Processing..."     "✓ Inserted"
```

## 🐛 Known Limitations

1. No real-time transcription (batched)
2. Requires microphone permission
3. Requires full keyboard access
4. Single language (extensible)
5. No offline mode (extensible)

## 🚧 Future Enhancements

- [ ] Waveform visualization
- [ ] Multiple language support
- [ ] Offline transcription queuing
- [ ] Keyboard themes
- [ ] Unit test suite
- [ ] App Clips integration

## 🔒 Security

| Component | Status | Notes |
|-----------|--------|-------|
| API Key | ⚠️ Temp | Use Keychain in production |
| Audio | ✅ Deleted | Cleaned immediately after transcription |
| Network | ✅ HTTPS | All API calls encrypted |
| Permissions | ✅ Explicit | User grants in Settings |

## 📖 Read the Blog

For deep technical details, see [TECHNICAL_BLOG.md](TECHNICAL_BLOG.md) covering:
- Keyboard extension architecture
- Audio processing decisions (16kHz, mono, AAC)
- Multipart form data construction
- State machine design
- Performance optimization
- Error handling patterns
- Production considerations

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for:
- Development setup
- Code style guidelines
- PR process
- Testing requirements

## 📄 License

Educational/Assessment project

## 📧 Support

- Open an issue on GitHub
- Check [README.md](README.md) troubleshooting section
- Review [TECHNICAL_BLOG.md](TECHNICAL_BLOG.md) for architecture questions

---

**Status**: ✅ Core functionality complete  
**Last Updated**: January 30, 2026  
**Time to Build**: ~4 hours for core features  
**Time to Deploy**: ~15 minutes (after setup)

**Ready to build?** See [README.md](README.md) for step-by-step setup instructions.
