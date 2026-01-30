import UIKit
import AVFoundation

class KeyboardViewController: UIInputViewController {
    
    // MARK: - Properties
    private let recordButton = UIButton(type: .system)
    private let statusLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    private var audioRecorder: AVAudioRecorder?
    private var audioURL: URL?
    private var isRecording = false
    private var recordingStartTime: Date?
    
    // Long press gesture recognizer
    private var longPressGestureRecognizer: UILongPressGestureRecognizer?
    
    // Haptic feedback
    private let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    private let selectionFeedback = UISelectionFeedbackGenerator()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        requestMicrophonePermission()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateKeyboardAppearance()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Record Button
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.backgroundColor = .systemBlue
        recordButton.setTitle("🎙️ Press to Record", for: .normal)
        recordButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        recordButton.setTitleColor(.white, for: .normal)
        recordButton.layer.cornerRadius = 12
        recordButton.clipsToBounds = true
        
        // Status Label
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.text = "Ready"
        statusLabel.textAlignment = .center
        statusLabel.font = .systemFont(ofSize: 12, weight: .regular)
        statusLabel.textColor = .secondaryLabel
        
        // Activity Indicator
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(recordButton)
        view.addSubview(statusLabel)
        view.addSubview(activityIndicator)
        
        // Constraints
        NSLayoutConstraint.activate([
            // Record Button
            recordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            recordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            recordButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            recordButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Status Label
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            statusLabel.topAnchor.constraint(equalTo: recordButton.bottomAnchor, constant: 8),
            
            // Activity Indicator
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 8),
            
            // Keyboard Height
            view.heightAnchor.constraint(equalToConstant: 110)
        ])
        
        // Setup Long Press Gesture
        setupLongPressGesture()
    }
    
    private func setupLongPressGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPress.minimumPressDuration = 0.1
        longPressGestureRecognizer = longPress
        recordButton.addGestureRecognizer(longPress)
    }
    
    // MARK: - Long Press Handling
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            startRecording()
        case .ended, .cancelled, .failed:
            stopRecording()
        default:
            break
        }
    }
    
    // MARK: - Recording
    private func startRecording() {
        // Check microphone permission first
        let status = AVAudioSession.sharedInstance().recordPermission
        guard status == .granted else {
            updateStatus("Microphone permission denied", color: .systemRed)
            return
        }
        
        do {
            // Setup audio session
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .default, options: [])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
            // Create audio file URL
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileName = "recording_\(UUID().uuidString).m4a"
            audioURL = documentsPath.appendingPathComponent(fileName)
            
            // Setup audio recorder
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 16000.0,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            
            isRecording = true
            recordingStartTime = Date()
            updateRecordingUI()
            impactFeedback.impactOccurred()
            
            updateStatus("Recording...", color: .systemRed)
            
        } catch {
            updateStatus("Error: \(error.localizedDescription)", color: .systemRed)
        }
    }
    
    private func stopRecording() {
        guard isRecording, let audioRecorder = audioRecorder else { return }
        
        audioRecorder.stop()
        isRecording = false
        impactFeedback.impactOccurred()
        
        updateStatus("Processing...", color: .systemOrange)
        activityIndicator.startAnimating()
        recordButton.isEnabled = false
        
        // Send to Whisper API
        if let audioURL = audioURL {
            transcribeAudio(url: audioURL)
        }
    }
    
    private func updateRecordingUI() {
        recordButton.backgroundColor = .systemRed
        recordButton.setTitle("🎙️ Recording...", for: .normal)
        
        // Pulsing animation
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.duration = 1.0
        pulseAnimation.fromValue = 1.0
        pulseAnimation.toValue = 0.5
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .infinity
        recordButton.layer.add(pulseAnimation, forKey: "pulse")
    }
    
    private func updateIdleUI() {
        recordButton.backgroundColor = .systemBlue
        recordButton.setTitle("🎙️ Press to Record", for: .normal)
        recordButton.layer.removeAnimation(forKey: "pulse")
        recordButton.isEnabled = true
    }
    
    // MARK: - API Integration
    private func transcribeAudio(url: URL) {
        guard let apiKey = getAPIKey() else {
            updateStatus("API key not configured", color: .systemRed)
            activityIndicator.stopAnimating()
            updateIdleUI()
            return
        }
        
        do {
            let audioData = try Data(contentsOf: url)
            let boundary = UUID().uuidString
            
            var request = URLRequest(url: URL(string: "https://api.groq.com/openai/v1/audio/transcriptions")!)
            request.httpMethod = "POST"
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            // Build multipart body
            var body = Data()
            
            // Add model field
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"model\"\r\n\r\n".data(using: .utf8)!)
            body.append("whisper-large\r\n".data(using: .utf8)!)
            
            // Add file field
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"audio.m4a\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: audio/mp4\r\n\r\n".data(using: .utf8)!)
            body.append(audioData)
            body.append("\r\n".data(using: .utf8)!)
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)
            
            request.httpBody = body
            
            // Execute request
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                DispatchQueue.main.async {
                    self?.handleTranscriptionResponse(data: data, response: response, error: error, audioURL: url)
                }
            }.resume()
            
        } catch {
            updateStatus("File error: \(error.localizedDescription)", color: .systemRed)
            activityIndicator.stopAnimating()
            updateIdleUI()
        }
    }
    
    private func handleTranscriptionResponse(data: Data?, response: URLResponse?, error: Error?, audioURL: URL) {
        defer {
            // Cleanup audio file
            try? FileManager.default.removeItem(at: audioURL)
        }
        
        if let error = error {
            updateStatus("Error: \(error.localizedDescription)", color: .systemRed)
            activityIndicator.stopAnimating()
            updateIdleUI()
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            updateStatus("Invalid response", color: .systemRed)
            activityIndicator.stopAnimating()
            updateIdleUI()
            return
        }
        
        guard httpResponse.statusCode == 200, let data = data else {
            updateStatus("API error: \(httpResponse.statusCode)", color: .systemRed)
            activityIndicator.stopAnimating()
            updateIdleUI()
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(TranscriptionResponse.self, from: data)
            insertText(response.text)
            updateStatus("✓ Inserted", color: .systemGreen)
            selectionFeedback.selectionChanged()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.activityIndicator.stopAnimating()
                self.updateIdleUI()
                self.updateStatus("Ready", color: .secondaryLabel)
            }
        } catch {
            updateStatus("Parse error: \(error.localizedDescription)", color: .systemRed)
            activityIndicator.stopAnimating()
            updateIdleUI()
        }
    }
    
    // MARK: - Text Insertion
    private func insertText(_ text: String) {
        textDocumentProxy.insertText(text)
    }
    
    // MARK: - UI Updates
    private func updateStatus(_ message: String, color: UIColor) {
        DispatchQueue.main.async {
            self.statusLabel.text = message
            self.statusLabel.textColor = color
        }
    }
    
    // MARK: - Permissions
    private func requestMicrophonePermission() {
        AVAudioSession.sharedInstance().requestRecordPermission { [weak self] granted in
            DispatchQueue.main.async {
                if !granted {
                    self?.updateStatus("Enable microphone in Settings", color: .systemRed)
                }
            }
        }
    }
    
    // MARK: - API Key Management
    private func getAPIKey() -> String? {
        // For production, retrieve from Keychain
        // This is a placeholder - implement secure storage
        return UserDefaults.standard.string(forKey: "groq_api_key")
    }
    
    // MARK: - Appearance
    private func updateKeyboardAppearance() {
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        view.backgroundColor = isDarkMode ? .systemGray6 : .systemBackground
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateKeyboardAppearance()
    }
}

// MARK: - AVAudioRecorderDelegate
extension KeyboardViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            updateStatus("Recording failed", color: .systemRed)
            updateIdleUI()
        }
    }
}

// MARK: - Models
struct TranscriptionResponse: Codable {
    let text: String
}
