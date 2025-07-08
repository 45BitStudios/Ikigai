import SwiftUI
import IkigaiCore

struct WatchContentView: View {
    @State private var counter = 0
    @State private var currentLocale = Locale.current
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Image(systemName: "applewatch")
                    .font(.system(size: 28))
                    .foregroundStyle(.blue)
                    .accessibilityLabel("apple_watch_icon")
                
                Text("watch_app_title")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("\(counter)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                HStack(spacing: 12) {
                    Button(action: {
                        counter -= 1
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.red)
                    }
                    .accessibilityLabel("decrease_counter")
                    
                    Button(action: {
                        counter += 1
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.green)
                    }
                    .accessibilityLabel("increase_counter")
                }
                .buttonStyle(.plain)
                
                Divider()
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        toggleLanguage()
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "globe")
                            .font(.caption)
                        Text("language_toggle")
                            .font(.caption)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("switch_language")
                
                if counter != 0 {
                    Text("Count: \(counter)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .transition(.opacity)
                }
            }
            .padding()
            .navigationTitle("counter_title")
            .environment(\.locale, currentLocale)
        }
    }
    
    private func toggleLanguage() {
        if currentLocale.language.languageCode?.identifier == "es" {
            currentLocale = Locale(identifier: "en")
        } else {
            currentLocale = Locale(identifier: "es")
        }
    }
}

#Preview {
    WatchContentView()
}
