import SwiftUI
import UserNotifications
import IkigaiCore

struct NotificationExtensionView: View {
    @State private var notificationTitle: String = "Notification"
    @State private var notificationBody: String = "Custom notification content will appear here"
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "bell.fill")
                    .font(.title2)
                    .foregroundStyle(.orange)
                    .accessibilityLabel("Notification Icon")
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(notificationTitle)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(notificationBody)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
            }
            
            HStack(spacing: 12) {
                Button(action: {
                    // Handle action
                }) {
                    Text("Action 1", bundle: .main)
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .accessibilityLabel("First Action Button")
                
                Button(action: {
                    // Handle action
                }) {
                    Text("Action 2", bundle: .main)
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.green)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .accessibilityLabel("Second Action Button")
                
                Spacer()
            }
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
