import SwiftUI

struct ContentView: View {
    @State private var textContent: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Voice Keyboard Demo")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Setup Instructions")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Label("1. Go to Settings > General > Keyboard > Keyboards", systemImage: "1.circle")
                        Label("2. Add \"VoiceKeyboard\"", systemImage: "2.circle")
                        Label("3. Allow Full Access when prompted", systemImage: "3.circle")
                        Label("4. Use keyboard in any text field below", systemImage: "4.circle")
                    }
                    .font(.subheadline)
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
                
                Text("Test the Keyboard")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextEditor(text: $textContent)
                    .border(Color.gray)
                    .frame(height: 200)
                    .padding(.horizontal)
                
                Text("Tap the text field above and switch to the Voice Keyboard to test recording.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                NavigationLink(destination: SettingsView()) {
                    HStack {
                        Image(systemName: "gear")
                        Text("Keyboard Settings")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()
            }
            .navigationTitle("Voice Keyboard")
        }
    }
}

struct SettingsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("About This App")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.secondary)
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Features").font(.subheadline).fontWeight(.bold)
                    BulletPoint("Press-and-hold recording button")
                    BulletPoint("Real-time visual feedback")
                    BulletPoint("Groq Whisper API integration")
                    BulletPoint("Automatic text insertion")
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Settings")
    }
}

struct BulletPoint: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .fontWeight(.bold)
            Text(text)
                .font(.subheadline)
        }
    }
}

#Preview {
    ContentView()
}
