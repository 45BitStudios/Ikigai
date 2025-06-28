import SwiftUI

struct MessageExtensionView: View {
    @State private var messageText: String = ""
    @State private var selectedColor: Color = .blue
    
    private let colors: [Color] = [.blue, .green, .orange, .purple, .red, .pink]
    
    var body: some View {
        Text("hello")
    }
    
    private func sendMessage() {
        // Handle message sending
    }
}
