import SwiftUI
import CoreSpotlight

struct SpotlightExtensionView: View {
    @State private var searchItems: [SpotlightItem] = []
    @State private var isIndexing = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 48))
                    .foregroundStyle(.purple)
                    .accessibilityLabel("Spotlight Extension Icon")
                
                Text("Spotlight Extension", bundle: .main)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Index content for Spotlight search", bundle: .main)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                
                if isIndexing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .accessibilityLabel("Indexing content")
                } else {
                    Button(action: {
                        indexContent()
                    }) {
                        Text("Index Content", bundle: .main)
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.purple)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .accessibilityLabel("Index Content Button")
                    .accessibilityHint("Tap to index content for Spotlight search")
                }
                
                if !searchItems.isEmpty {
                    List(searchItems) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title)
                                .font(.headline)
                            Text(item.description)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                    .listStyle(PlainListStyle())
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Spotlight")
        }
    }
    
    private func indexContent() {
        isIndexing = true
        
        Task {
            // Simulate indexing process
            try? await Task.sleep(for: .seconds(1))
            
            await MainActor.run {
                searchItems = [
                    SpotlightItem(title: "Sample Item 1", description: "Indexed content item"),
                    SpotlightItem(title: "Sample Item 2", description: "Another indexed item"),
                    SpotlightItem(title: "Sample Item 3", description: "Third indexed item")
                ]
                isIndexing = false
            }
        }
    }
}

struct SpotlightItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
}
