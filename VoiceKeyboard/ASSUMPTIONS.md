# Assumptions and Design Decisions

## Audio Configuration

### Format & Codec
- **Chosen Format**: MPEG-4 AAC (`.m4a`)
- **Rationale**: Supported by Groq API, compressed without loss of speech clarity, efficient for transmission
- **Alternative**: FLAC (lossless but larger file size)

### Sample Rate
- **Chosen**: 16,000 Hz
- **Rationale**: Optimal for Whisper API speech recognition, balances quality and file size
- **Trade-offs**: 
  - Lower (8000 Hz) would reduce file size but worsen accuracy
  - Higher (44100 Hz) would improve quality but increase file size significantly

### Audio Quality
- **Encoding Quality**: High
- **Channels**: Mono (1 channel)
- **Rationale**: Voice is typically mono; no need for stereo data

### Maximum Recording Duration
- **Assumption**: No hard limit enforced
- **Practical Limit**: ~5 minutes before memory pressure on extended devices
- **Consideration**: Keyboard extensions have restricted memory (~50-120 MB)

## Network Configuration

### API Endpoint
- **Service**: Groq Cloud
- **Model**: `whisper-large`
- **Rationale**: 
  - Groq offers free tier with generous limits
  - Whisper-large provides excellent accuracy
  - Groq optimized for low-latency inference

### Request Timeout
- **Value**: URLSession default (~30 seconds)
- **Rationale**: Sufficient for most audio clips (typically < 60 seconds at 16kHz)
- **Edge Case**: Large files may timeout on slow connections

### Error Recovery
- **Strategy**: No automatic retry (user can re-record)
- **Rationale**: 
  - Prevents duplicate transcriptions
  - User has immediate feedback to retry
  - Avoids confusing multiple attempts

## Keyboard Specifications

### Height Constraint
- **Chosen**: 110 points
- **Rationale**: 
  - Minimal but usable size
  - Leaves screen real estate for text
  - Follows Apple HIG guidelines (minimum interaction target 44pt)
- **Device Scaling**: Height is in points (auto-scales to screen)

### Button Sizing
- **Interaction Area**: 50 points height
- **Rationale**: Exceeds minimum 44pt touch target guideline

### UI Layout
- **Design**: Single button + status label
- **Rationale**: 
  - Minimal cognitive load
  - Focuses user on core task
  - Leaves room for future enhancements without redesign

## Supported iOS Versions

### Minimum: iOS 13.0
- **Reason**: 
  - AVAudioRecorder support with modern APIs
  - UIInputViewController stability
  - SwiftUI available for main app (iOS 13+)
- **Compatibility**: 
  - iPhone 6s and later
  - iPad Air 2 and later

### Maximum: iOS 18.0+
- **Future-Proof**: Code uses modern concurrency-compatible patterns
- **Deprecations Handled**: Falls back gracefully for older APIs

## Permissions & Security

### Microphone Permission
- **Handling**: 
  - RequestRecordPermission called on first load
  - Status checked before each recording attempt
  - User directed to Settings if denied
- **UI Pattern**: Non-blocking dialog (not interrupting UI)

### Full Keyboard Access
- **Requirement**: Needed for text insertion in all apps
- **Rationale**: Without it, keyboard can only insert in current text field
- **Implementation**: System handles this - we just request it in Info.plist

### API Key Storage (Development)
- **Current**: UserDefaults
- **Problem**: Visible to app inspection, not secure
- **Recommended**: Keychain (see README for implementation pattern)

## Text Insertion Strategy

### Cursor Position
- **Assumption**: UITextDocumentProxy maintains cursor position
- **Edge Cases**:
  - Multiple text selections: Inserts at first position
  - No active text field: Keyboard disabled
- **Limitation**: No visual preview of where text will go

### Special Characters
- **Assumption**: Groq returns properly formatted text
- **Limitation**: No automatic punctuation or capitalization
- **Future**: Could add post-processing for common corrections

## Visual Feedback Design

### Recording State Indicators
1. **Visual**: Red button + "Recording..." text + pulsing animation
2. **Haptic**: Medium impact on start
3. **Audio**: None (could interfere with recording)

### Processing State Indicators
1. **Visual**: Activity spinner + "Processing..." text
2. **Haptic**: Selection feedback on completion
3. **Timeout**: No explicit UI if transcription takes > 30 seconds

### Completion Feedback
1. **Visual**: Green checkmark + "✓ Inserted" + 1 second auto-dismiss
2. **Haptic**: Selection feedback
3. **Auto-Reset**: Returns to idle after 1 second

## Error Messages

### Principle
- **User-Friendly**: Non-technical language
- **Actionable**: Include what to do next
- **Brief**: 1-2 lines only

### Examples
- "Enable microphone in Settings" → Clear call to action
- "API error: 401" → Indicates authentication issue
- "Network connection failed" → Temporary issue, user can retry

## Memory Management

### Audio File Cleanup
- **Strategy**: Delete temp files immediately after transcription
- **Timing**: In defer block of handleTranscriptionResponse
- **Rationale**: 
  - Prevents storage accumulation
  - Frees memory quickly
  - Handles both success and error cases

### Recorder Lifecycle
- **Creation**: On recording start
- **Cleanup**: On recording stop (implicit via autorelease)
- **Assumption**: AVAudioRecorder manages underlying resources

## Testing Assumptions

### Devices
- **iPhone**: Minimum iPhone 6s
- **iPad**: Minimum iPad Air 2
- **Simulator**: Works but mic input simulated
- **Network**: Tests assume WiFi/LTE connectivity

### App Testing
- **Supported**: Messages, Mail, Notes, Safari, 3rd-party apps
- **Not Tested**: Accessibility features (VoiceOver, etc.)
- **Edge Case**: Apps with custom text inputs may not work

## Future Considerations

### Scaling to Production
1. **API Key Rotation**: Implement secure refresh mechanism
2. **Rate Limiting**: Add queue for multiple rapid requests
3. **Offline Support**: Queue transcriptions, sync when online
4. **Analytics**: Track usage patterns (privacy-respecting)
5. **Localization**: Support multiple languages via dropdown

### Performance Optimization
1. **Audio Compression**: Pre-compress before sending (trade speed/quality)
2. **Caching**: Cache frequently requested transcriptions
3. **Memory Pooling**: Reuse AVAudioRecorder if possible

---

**Document Version**: 1.0
**Last Updated**: January 30, 2026
