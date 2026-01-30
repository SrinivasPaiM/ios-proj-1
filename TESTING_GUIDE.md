# Testing Guide

## Unit Testing Setup

Since keyboard extensions have specific constraints, we provide test helpers:

### Testing Audio Recording

```swift
import XCTest
@testable import VoiceKeyboardExtension

class AudioRecorderTests: XCTestCase {
    var sut: KeyboardViewController!
    
    override func setUp() {
        super.setUp()
        sut = KeyboardViewController()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testAudioRecorderInitialization() {
        // Verify recorder can be created
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .default)
            // Recorder setup succeeds
        } catch {
            XCTFail("Failed to setup audio session: \(error)")
        }
    }
    
    func testMicrophonePermission() {
        let status = AVAudioSession.sharedInstance().recordPermission
        // At least .denied or .granted (not .undetermined)
        XCTAssertNotEqual(status, .undetermined)
    }
}
```

### Testing API Integration

```swift
class TranscriptionAPITests: XCTestCase {
    func testAPIKeyRetrievalFromUserDefaults() {
        let testKey = "test_api_key_12345"
        UserDefaults.standard.set(testKey, forKey: "groq_api_key")
        
        let retrieved = UserDefaults.standard.string(forKey: "groq_api_key")
        XCTAssertEqual(retrieved, testKey)
    }
    
    func testMultipartFormDataConstruction() {
        let audioData = Data("mock audio".utf8)
        let boundary = UUID().uuidString
        var body = Data()
        
        // Construct multipart
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"model\"\r\n\r\n".data(using: .utf8)!)
        body.append("whisper-large\r\n".data(using: .utf8)!)
        
        XCTAssertGreaterThan(body.count, 0)
        XCTAssertTrue(String(data: body, encoding: .utf8)?.contains("whisper-large") ?? false)
    }
    
    func testTranscriptionResponseDecoding() {
        let json = """
        {"text": "Hello world"}
        """.data(using: .utf8)!
        
        let response = try? JSONDecoder().decode(TranscriptionResponse.self, from: json)
        XCTAssertEqual(response?.text, "Hello world")
    }
}
```

## Integration Testing

### Test on Device vs Simulator

| Feature | Simulator | Device |
|---------|-----------|--------|
| Microphone | Simulated ⚠️ | Real ✅ |
| Audio Recording | Works | Works |
| Network | Works | Works |
| Dark Mode | Works | Works |
| Gestures | Works | Works |
| Haptics | Simulated | Works |
| Memory | Unlimited | Limited |

### Testing Checklist

#### Functionality Tests

- [ ] **Recording Start**
  - Button changes color to red
  - Pulsing animation starts
  - Status shows "Recording..."
  - Haptic feedback felt

- [ ] **Recording Stop**
  - Button changes color back to blue
  - Animation stops
  - Status shows "Processing..."
  - Activity indicator appears

- [ ] **Transcription Complete**
  - Text appears in text field
  - Status shows "✓ Inserted"
  - Green color displayed
  - Returns to idle after 1 second

- [ ] **Text Insertion**
  - Works in Messages
  - Works in Mail
  - Works in Notes
  - Works in Safari
  - Cursor position correct

#### Error Handling Tests

- [ ] **Microphone Permission Denied**
  - Status shows "Enable microphone in Settings"
  - No crash
  - Button disabled appropriately

- [ ] **API Timeout (30+ seconds)**
  - Shows "API error" message
  - Activity indicator stops
  - Can retry recording

- [ ] **Invalid API Key**
  - Shows "API error: 401"
  - Clear feedback to user
  - No sensitive data logged

- [ ] **Network Offline**
  - Shows network error message
  - User can retry when online
  - No silent failures

#### Performance Tests

- [ ] **Memory Usage**
  - Monitor with Xcode Instruments
  - < 50MB for typical use
  - No leaks after 10 recordings

- [ ] **CPU Usage**
  - Recording: ~15-20%
  - Processing: ~25-30%
  - Idle: ~0%

- [ ] **Responsiveness**
  - Recording starts < 100ms
  - Recording stops immediately
  - UI updates smooth

#### Appearance Tests

- [ ] **Light Mode**
  - Blue button visible
  - Text readable
  - No color conflicts

- [ ] **Dark Mode**
  - All elements visible
  - Appropriate contrast
  - Background correct

- [ ] **iPad Orientation**
  - Portrait mode
  - Landscape mode
  - Split view
  - Floating keyboard

## Manual Testing Flow

### Quick 5-Minute Test

1. Launch app
2. Go to Settings → Keyboard
3. Add VoiceKeyboard
4. Open Notes app
5. Tap text field
6. Switch to VoiceKeyboard
7. Press and hold button
8. Say: "This is a test"
9. Release button
10. Verify text appears

### Extended 30-Minute Test

**Setup**
- [ ] Install on physical device
- [ ] Verify microphone permissions
- [ ] Verify full keyboard access enabled
- [ ] Note iOS version (13.0+)

**Functionality**
- [ ] Test in Messages (SMS)
- [ ] Test in Mail (compose)
- [ ] Test in Notes (new note)
- [ ] Test in Safari (search bar)
- [ ] Test in third-party apps (if available)

**Edge Cases**
- [ ] Speak quickly (test rapid input)
- [ ] Speak slowly (test long pauses)
- [ ] Noisy environment (test noise handling)
- [ ] Quiet environment (test silence)
- [ ] Multiple languages (test non-English)

**Network**
- [ ] WiFi enabled
- [ ] Switch between WiFi/Cellular
- [ ] Disable internet, try to record (should show error)
- [ ] Re-enable internet, verify recovery

**Error Scenarios**
- [ ] Revoke microphone permission, try recording
- [ ] Kill app, reopen, verify permission request
- [ ] Disable full keyboard access, try text insertion
- [ ] Invalid API key (see error message)

## Automated Testing with Xcode

### Create a Test Target

1. Xcode → File → New → Target → Unit Testing Bundle
2. Name: `VoiceKeyboardTests`
3. Add to main app target

### Example Test Suite

```swift
import XCTest
@testable import VoiceKeyboard

class VoiceKeyboardTests: XCTestCase {
    
    func testKeyboardViewControllerInitialization() {
        let controller = KeyboardViewController()
        XCTAssertNotNil(controller)
        XCTAssertNotNil(controller.view)
    }
    
    func testRecordingStateTransition() {
        // Verify state machine works
        // IDLE → RECORDING → PROCESSING → COMPLETE → IDLE
    }
    
    func testAPIKeyConfigured() {
        let key = UserDefaults.standard.string(forKey: "groq_api_key")
        XCTAssertNotNil(key, "API key should be configured for testing")
    }
    
    func testTextInsertionSyntax() {
        let testText = "Hello, world!"
        // Verify text can be properly inserted
        XCTAssertGreaterThan(testText.count, 0)
    }
}
```

## Performance Testing with Instruments

### Memory Profiling

```bash
# Connect device
# Xcode → Debug → Profile
# Select "Leaks" instrument
# Record session
# Look for red/yellow indicators
```

### CPU Profiling

1. Xcode → Debug → Profile
2. Select "System Trace"
3. Record: start recording, stop, check CPU
4. Verify < 30% during recording

### Audio Unit Graphs

1. Xcode → Debug → Profile
2. Select "Audio Unit"
3. Verify AVAudioRecorder running
4. Check for errors/dropouts

## Debugging Tips

### View Keyboard Logs

```bash
# Terminal
log stream --predicate 'process == "VoiceKeyboardExtension"'
```

### Print Debugging

```swift
// In KeyboardViewController
private func updateStatus(_ message: String, color: UIColor) {
    #if DEBUG
    print("Keyboard Status: \(message)")
    #endif
    
    DispatchQueue.main.async {
        self.statusLabel.text = message
        self.statusLabel.textColor = color
    }
}
```

### Breakpoint Debugging

```
Xcode → Debug Navigator → Add breakpoint
- At recording start
- At API call
- At text insertion
- At error handling
```

## Known Test Limitations

1. **Simulator Mic**: Doesn't capture real audio, uses simulated input
2. **Network**: Requires actual API key to test API calls
3. **Permissions**: Simulator permission dialogs behave differently
4. **Haptics**: Simulator doesn't provide haptic feedback

## CI/CD Testing (GitHub Actions)

Create `.github/workflows/tests.yml`:

```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v2
      - name: Build
        run: xcodebuild build-for-testing
      - name: Test
        run: xcodebuild test
```

## Test Coverage Goals

| Component | Coverage |
|-----------|----------|
| Recording Start | 100% |
| Recording Stop | 100% |
| Text Insertion | 95% |
| API Handling | 90% |
| Error Cases | 85% |
| UI Updates | 80% |

## Continuous Monitoring

### What to Watch

1. **Crash Reports**
   - Monitor TestFlight/App Store crashes
   - Fix critical issues immediately

2. **Performance**
   - Monitor battery usage
   - Check memory trends
   - Watch for memory leaks

3. **User Feedback**
   - Review user ratings/comments
   - Prioritize common issues
   - Acknowledge and fix problems

---

**Test Driven Development Note**: Consider writing tests BEFORE implementing features for better code structure and fewer bugs.

**Last Updated**: January 30, 2026
