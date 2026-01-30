# VoiceKeyboard Info.plist Configuration

Below are the required and recommended keys for the keyboard extension Info.plist:

## Required Keys

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<!-- Bundle Configuration -->
	<key>CFBundleDevelopmentRegion</key>
	<string>en</string>
	
	<key>CFBundleExecutable</key>
	<string>VoiceKeyboardExtension</string>
	
	<key>CFBundleIdentifier</key>
	<string>com.yourcompany.voicekeyboard.extension</string>
	
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	
	<key>CFBundleName</key>
	<string>VoiceKeyboard</string>
	
	<key>CFBundlePackageType</key>
	<string>XPC!</string>
	
	<key>CFBundleShortVersionString</key>
	<string>1.0</string>
	
	<key>CFBundleVersion</key>
	<string>1</string>
	
	<!-- Keyboard Configuration -->
	<key>NSExtension</key>
	<dict>
		<key>NSExtensionAttributes</key>
		<dict>
			<!-- Keyboard-specific attributes -->
			<key>IsASCIICapable</key>
			<true/>
			
			<key>PrincipalClass</key>
			<string>$(PRODUCT_MODULE_NAME).KeyboardViewController</string>
		</dict>
		<key>NSExtensionPointIdentifier</key>
		<string>com.apple.keyboard-service</string>
	</dict>
	
	<!-- Permissions -->
	<key>NSMicrophoneUsageDescription</key>
	<string>This keyboard needs microphone access to record and transcribe your voice to text</string>
	
	<key>NSLocalNetworkUsageDescription</key>
	<string>This keyboard uses the internet to transcribe your voice using the Groq API</string>
	
	<key>NSBonjourServices</key>
	<array>
		<string>_services._dns-sd._udp</string>
	</array>
	
	<!-- App Groups (optional, for sharing data with main app) -->
	<key>NSUserActivityTypes</key>
	<array>
		<string>com.yourcompany.voicekeyboard.activity</string>
	</array>
	
	<!-- Disable network privacy -->
	<key>NSAllowsLocalNetworking</key>
	<true/>
	
	<!-- System Keys -->
	<key>NSHighResolutionCapable</key>
	<true/>
	
	<key>UIDeviceFamily</key>
	<array>
		<integer>1</integer>
		<integer>2</integer>
	</array>
	
	<key>UISupportedInterfaceOrientations</key>
	<array>
		<string>UIInterfaceOrientationPortrait</string>
		<string>UIInterfaceOrientationLandscapeLeft</string>
		<string>UIInterfaceOrientationLandscapeRight</string>
	</array>
	
	<key>UISupportedInterfaceOrientations~ipad</key>
	<array>
		<string>UIInterfaceOrientationPortrait</string>
		<string>UIInterfaceOrientationPortraitUpsideDown</string>
		<string>UIInterfaceOrientationLandscapeLeft</string>
		<string>UIInterfaceOrientationLandscapeRight</string>
	</array>
	
	<key>NSRequiresIPhoneOSVersion</key>
	<string>13.0</string>
	
</dict>
</plist>
```

## Main App Info.plist

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDevelopmentRegion</key>
	<string>en</string>
	
	<key>CFBundleExecutable</key>
	<string>VoiceKeyboard</string>
	
	<key>CFBundleIdentifier</key>
	<string>com.yourcompany.voicekeyboard</string>
	
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	
	<key>CFBundleName</key>
	<string>VoiceKeyboard</string>
	
	<key>CFBundlePackageType</key>
	<string>APPL</string>
	
	<key>CFBundleShortVersionString</key>
	<string>1.0</string>
	
	<key>CFBundleVersion</key>
	<string>1</string>
	
	<!-- Appearance -->
	<key>UIAppFonts</key>
	<array/>
	
	<!-- Permissions -->
	<key>NSMicrophoneUsageDescription</key>
	<string>This app needs microphone access to demonstrate the voice keyboard</string>
	
	<key>UILaunchStoryboardName</key>
	<string>LaunchScreen</string>
	
	<!-- Supported Orientations -->
	<key>UISupportedInterfaceOrientations</key>
	<array>
		<string>UIInterfaceOrientationPortrait</string>
		<string>UIInterfaceOrientationLandscapeLeft</string>
		<string>UIInterfaceOrientationLandscapeRight</string>
	</array>
	
	<key>UISupportedInterfaceOrientations~ipad</key>
	<array>
		<string>UIInterfaceOrientationPortrait</string>
		<string>UIInterfaceOrientationPortraitUpsideDown</string>
		<string>UIInterfaceOrientationLandscapeLeft</string>
		<string>UIInterfaceOrientationLandscapeRight</string>
	</array>
	
	<key>NSRequiresIPhoneOSVersion</key>
	<string>13.0</string>
	
</dict>
</plist>
```

## Important Notes

1. **Bundle Identifiers**: Replace `com.yourcompany` with your actual Team ID and domain
2. **Microphone Permission**: Required for audio recording
3. **Local Network**: Enable if using local API endpoints
4. **App Groups**: Use if sharing data between main app and extension (requires team membership)
5. **PrincipalClass**: Points to the KeyboardViewController entry point

---

**Last Updated**: January 30, 2026
