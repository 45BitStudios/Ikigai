import SwiftUI
import IkigaiCore

struct ShareExtensionView: View {
    @State private var isSharing = false
    @State private var sharedContent: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 48))
                    .foregroundStyle(.green)
                    .accessibilityLabel("Share Extension Icon")
                
                Text("Share Content", bundle: .main)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Share content from other apps", bundle: .main)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                
                if !sharedContent.isEmpty {
                    ScrollView {
                        Text(sharedContent)
                            .font(.body)
                            .padding()
                            .background(.quaternary)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .frame(maxHeight: 200)
                }
                
                if isSharing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .accessibilityLabel("Sharing")
                } else {
                    Button(action: {
                        shareContent()
                    }) {
                        Text("Share", bundle: .main)
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.green)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .accessibilityLabel("Share Button")
                    .accessibilityHint("Tap to share the selected content")
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Share")
        }
        .onAppear {
            loadSharedContent()
        }
    }
    
    private func loadSharedContent() {
        sharedContent = "Shared content will appear here"
    }
    
    private func shareContent() {
        isSharing = true
        
        Task {
            try? await Task.sleep(for: .seconds(1))
            
            await MainActor.run {
                isSharing = false
            }
        }
    }
}
