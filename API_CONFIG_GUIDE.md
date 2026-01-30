# API Configuration Guide

## Getting Your Groq API Key

### Step 1: Create a Groq Account

1. Visit [console.groq.com](https://console.groq.com)
2. Click "Sign Up" or "Sign In with GitHub"
3. Complete the registration process
4. Verify your email address

### Step 2: Generate API Key

1. Navigate to [API Keys](https://console.groq.com/keys)
2. Click "Create API Key"
3. Copy the key immediately (it won't be shown again)
4. Store securely

### Step 3: Add to Your Project

#### Development (Temporary - NOT SECURE)

Add to your keyboard extension's `KeyboardViewController.swift`:

```swift
private func getAPIKey() -> String? {
    UserDefaults.standard.string(forKey: "groq_api_key")
}
```

Then set it from your main app:

```swift
// In ContentView.swift or AppDelegate
UserDefaults.standard.set("gsk_your_actual_key_here", forKey: "groq_api_key")
```

#### Production (Secure - Using Keychain)

Use this secure implementation:

```swift
import Security

class KeychainService {
    static let shared = KeychainService()
    
    private let service = "com.yourcompany.voicekeyboard"
    private let account = "groq_api_key"
    
    func storeAPIKey(_ key: String) -> Bool {
        guard let data = key.data(using: .utf8) else { return false }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        SecItemDelete(query as CFDictionary)
        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }
    
    func retrieveAPIKey() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let key = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return key
    }
}
```

Then use it:

```swift
private func getAPIKey() -> String? {
    KeychainService.shared.retrieveAPIKey()
}
```

## Testing Your API Key

### Test with curl

```bash
curl -X POST "https://api.groq.com/openai/v1/audio/transcriptions" \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -F "file=@/path/to/audio.m4a" \
  -F "model=whisper-large"
```

### Expected Response

```json
{
  "text": "Transcribed audio text goes here"
}
```

### Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| `401 Unauthorized` | Invalid API key | Check key format, ensure copied fully |
| `429 Too Many Requests` | Rate limited | Wait 60 seconds before retrying |
| `400 Bad Request` | Wrong audio format | Verify audio is valid, check format |
| `500 Server Error` | Groq outage | Check [status.groq.com](https://status.groq.com) |

## API Limits

### Free Tier (Default)

- **Rate Limit**: 30 requests/minute
- **Audio Length**: Up to 25 MB
- **Response Time**: ~2-5 seconds per request
- **Model**: `whisper-large` available

### Pricing

The free tier is generous. If you need more:
- Check [Groq Pricing](https://groq.com/pricing) for paid plans
- Current rates very competitive vs. OpenAI

## Security Best Practices

### DO ✅

- Store API key in Keychain (production)
- Use HTTPS for all requests (already in code)
- Validate API responses before use
- Handle errors gracefully
- Rotate keys periodically (in production)
- Use `.secretKeyString` or similar for development only

### DON'T ❌

- Commit API key to git
- Store in plaintext UserDefaults
- Log API key to console
- Expose in build artifacts
- Hardcode in source code
- Share in email/Slack

## Monitoring Usage

### Check Your Usage

1. Go to [console.groq.com/usage](https://console.groq.com/usage)
2. View:
   - Requests this month
   - Token usage
   - Cost breakdown
   - Current rate limit status

### Set Up Alerts

1. Go to [Settings](https://console.groq.com/settings)
2. Configure email alerts for:
   - Rate limit exceeded
   - Quota approaching
   - Suspicious activity

## Multiple Environments

For production deployments:

```swift
enum Environment {
    case development
    case staging
    case production
    
    var apiKey: String? {
        switch self {
        case .development:
            return UserDefaults.standard.string(forKey: "groq_api_key")
        case .staging, .production:
            return KeychainService.shared.retrieveAPIKey()
        }
    }
}
```

## Groq API Reference

### Endpoint

```
POST https://api.groq.com/openai/v1/audio/transcriptions
```

### Parameters

- `file` (required): Audio file (multipart form data)
- `model` (required): `whisper-large`
- `language` (optional): ISO-639-1 code (e.g., "en", "es", "fr")
- `prompt` (optional): Initial text for context
- `response_format` (optional): `json`, `text`, `srt`, `verbose_json`

### Example Request

```swift
var request = URLRequest(url: URL(string: "https://api.groq.com/openai/v1/audio/transcriptions")!)
request.httpMethod = "POST"
request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
request.httpBody = buildMultipartBody(audioData: audioData, boundary: boundary)

URLSession.shared.dataTask(with: request) { data, response, error in
    // Handle response
}.resume()
```

## Troubleshooting

### API Key Not Working

1. Verify key is copied completely (no spaces)
2. Check key hasn't been revoked in console
3. Ensure Authorization header format: `Bearer KEY`
4. Try with curl first to isolate issue

### Audio Not Being Transcribed

1. Verify audio file is valid (try with curl)
2. Check audio format (should be MPEG-4 AAC)
3. Ensure audio contains speech (not silence)
4. Check audio duration (should be < 1 hour)

### Slow Transcription

1. Check network speed (test with speedtest.net)
2. Groq serves from multiple regions (should be fast)
3. Large audio files naturally take longer
4. Consider pre-compressing audio

---

**Need Help?**
- [Groq Discord Community](https://discord.gg/groq)
- [Groq Documentation](https://console.groq.com/docs)
- Open an issue on GitHub

**Last Updated**: January 30, 2026
