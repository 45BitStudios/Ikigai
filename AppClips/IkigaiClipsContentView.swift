import SwiftUI

struct IkigaiClipsContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "app.badge")
                    .font(.system(size: 60))
                    .foregroundStyle(.orange)
                    .accessibilityLabel("App Clip Icon")
                
                Text("App Clip")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Quick experience without the full app")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    // Handle quick action
                }) {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .accessibilityLabel("Get Started Button")
                
                Spacer()
            }
            .padding()
            .navigationTitle("App Clip")
        }
    }
}

#Preview {
    IkigaiClipsContentView()
}
