import SwiftUI
import IkigaiCore

struct ActionExtensionView: View {
    @State private var isProcessing = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.blue)
                    .accessibilityLabel("Action Extension Icon")
                
                Text("Action Extension", bundle: .main)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Perform custom actions on selected content", bundle: .main)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                
                if isProcessing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .accessibilityLabel("Processing")
                } else {
                    Button(action: {
                        performAction()
                    }) {
                        Text("Execute Action", bundle: .main)
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .accessibilityLabel("Execute Action Button")
                    .accessibilityHint("Tap to perform the selected action")
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Action")
        }
    }
    
    private func performAction() {
        isProcessing = true
        
        Task {
            try? await Task.sleep(for: .seconds(1))
            
            await MainActor.run {
                isProcessing = false
            }
        }
    }
}
