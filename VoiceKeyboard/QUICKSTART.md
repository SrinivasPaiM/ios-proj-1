# Quick Start (5-Minute Setup)

## Prerequisites

- Xcode 15.0+
- iOS 13.0+ simulator or device
- Free Groq API key (get at [console.groq.com](https://console.groq.com))

## Setup Steps

### 1. Clone & Open Project (1 min)

```bash
git clone <repository-url>
cd VoiceKeyboard
open VoiceKeyboard/VoiceKeyboard.xcodeproj
```

### 2. Get API Key (2 min)

1. Visit [console.groq.com](https://console.groq.com)
2. Sign up or sign in
3. Go to API Keys
4. Create new key → Copy it

### 3. Configure Project (1 min)

In Xcode, select the main app target:
- General tab
- Signing: Select your Team
- Bundle Identifier: Change `yourcompany` to your team

Same for keyboard extension target.

### 4. Add API Key (1 min)

Open [App.swift](VoiceKeyboard/VoiceKeyboard/App.swift), add:

```swift
import SwiftUI

@main
struct VoiceKeyboardApp: App {
    init() {
        // Add this line:
        UserDefaults.standard.set("your_groq_api_key_here", forKey: "groq_api_key")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

Replace `your_groq_api_key_here` with your actual key.

### 5. Run & Enable Keyboard (1 min)

1. Select any simulator (iPhone 15 Pro recommended)
2. Build and run (⌘R)
3. Simulator opens with demo app
4. Go to Settings app → General → Keyboard → Keyboards
5. Add "VoiceKeyboard"
6. Tap it and allow "Full Access"

### 6. Test It

1. Open any text field (Notes app works great)
2. Tap keyboard selector, switch to Voice Keyboard
3. Press and hold the button
4. Say something
5. Release → See transcribed text appear

## Common Setup Issues

### "Bundle Identifier Mismatches"

**Fix**: In Xcode, both targets need matching Team ID:
- Select project in navigator
- Info tab → Unique Identifier (should have your Team ID prefix)

### "Microphone Not Working"

**Fix**: Simulator doesn't have real microphone. On device:
- Settings → Privacy → Microphone → Find your app → Allow

### "Full Access Not Enabled"

**Fix**: The keyboard won't insert text without it:
- Settings → General → Keyboard → VoiceKeyboard → Toggle "Allow Full Access"

### "API Returns 401"

**Fix**: API key is wrong:
- Verify key copied exactly from Groq console
- No spaces, special characters
- Check key hasn't been revoked

## Next Steps

| Goal | Read |
|------|------|
| Understand architecture | [TECHNICAL_BLOG.md](TECHNICAL_BLOG.md) |
| Deep configuration | [ASSUMPTIONS.md](ASSUMPTIONS.md) |
| API setup details | [API_CONFIG_GUIDE.md](API_CONFIG_GUIDE.md) |
| Full setup guide | [README.md](README.md) |
| Deployment tips | [INFO_PLIST_REFERENCE.md](INFO_PLIST_REFERENCE.md) |

## Quick Architecture Overview

```
┌─────────────────────┐
│   Main App (iOS)    │  ← Demo interface & settings
│   SwiftUI           │
└──────────┬──────────┘
           │ includes
┌──────────▼──────────────────────┐
│   Keyboard Extension            │
├─────────────────────────────────┤
│ 1. Press-and-hold button        │
│ 2. Record audio (AVAudioRecorder)
│ 3. Send to Groq Whisper API    │
│ 4. Receive transcription        │
│ 5. Insert text (UITextDocumentProxy)
└─────────────────────────────────┘
```

## Feature Summary

- 🎙️ **Press-and-hold recording** - Single intuitive interaction
- 🔴 **Visual feedback** - Pulsing button, status label, activity spinner
- 🌐 **Cloud transcription** - Groq Whisper API (fast & free)
- ✏️ **Text insertion** - Works in any app's text field
- 🌙 **Dark mode** - Native iOS appearance
- 📱 **iPad support** - Works on all iPad models

## Time Estimates

| Task | Time |
|------|------|
| Setup | 5 min |
| First test | 1 min |
| Understanding code | 30 min |
| Reading blog | 15 min |
| Making modifications | 20+ min |

## What You Have Now

✅ Working iOS keyboard extension  
✅ Press-and-hold audio recording  
✅ Groq API integration  
✅ Text insertion in any app  
✅ Full source code  
✅ Comprehensive documentation  

## What's NOT Included Yet

❌ Waveform visualization (future)  
❌ Offline mode (future)  
❌ Unit tests (future)  
❌ Published App Store app (need Apple Developer account)  
❌ Keyboard themes (future)  

## Recommended Next Steps

### To Learn More
1. Read [TECHNICAL_BLOG.md](TECHNICAL_BLOG.md) (12 min read)
2. Understand Groq API via [API_CONFIG_GUIDE.md](API_CONFIG_GUIDE.md)
3. Explore code in Xcode with breakpoints

### To Extend It
1. Try [future enhancements](README.md#-future-enhancements)
2. Add waveform visualization
3. Implement Keychain storage (see [API_CONFIG_GUIDE.md](API_CONFIG_GUIDE.md))

### To Deploy
1. Get Apple Developer account ($99/year)
2. Configure proper bundle identifiers
3. Create provisioning profiles
4. Build and archive in Xcode
5. Upload to App Store Connect

## Support

- **Questions?** → Read [README.md](README.md)
- **Technical details?** → See [TECHNICAL_BLOG.md](TECHNICAL_BLOG.md)
- **Configuration?** → Check [API_CONFIG_GUIDE.md](API_CONFIG_GUIDE.md)
- **Issues?** → Open GitHub issue

---

**Status**: Ready to use ✅  
**Last Updated**: January 30, 2026  
**Next**: Go test the keyboard!
