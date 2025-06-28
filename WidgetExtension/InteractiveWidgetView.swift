import SwiftUI
import WidgetKit
import AppIntents
import IkigaiCore

struct InteractiveWidgetView: View {
    let entry: SimpleEntry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            SmallInteractiveView(entry: entry)
        case .systemMedium:
            MediumInteractiveView(entry: entry)
        default:
            SmallInteractiveView(entry: entry)
        }
    }
}

// MARK: - Interactive Widget Views
struct SmallInteractiveView: View {
    let entry: SimpleEntry
    
    var body: some View {
        VStack(spacing: 12) {
            VStack(spacing: 4) {
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(.blue)
                
                Text(entry.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
            }
            
            Button(intent: QuickActionIntent()) {
                Text("Action")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .accessibilityLabel("Interactive widget: \(entry.title)")
    }
}

struct MediumInteractiveView: View {
    let entry: SimpleEntry
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "star.fill")
                        .font(.title2)
                        .foregroundStyle(.blue)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(entry.title)
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text(entry.subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                }
                
                Spacer()
            }
            
            VStack(spacing: 8) {
                Button(intent: QuickActionIntent()) {
                    Label("Start", systemImage: "play.fill")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(.green)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)
                
                Button(intent: SecondaryActionIntent()) {
                    Label("Stop", systemImage: "stop.fill")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(.red)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .accessibilityLabel("Interactive widget: \(entry.title) with start and stop actions")
    }
}

// MARK: - Widget Intents
struct QuickActionIntent: AppIntent {
    static let title: LocalizedStringResource = "Quick Action"
    static let description = IntentDescription("Perform a quick action from the widget")
    
    func perform() async throws -> some IntentResult {
        // Handle the quick action here
        return .result()
    }
}

struct SecondaryActionIntent: AppIntent {
    static let title: LocalizedStringResource = "Secondary Action"
    static let description = IntentDescription("Perform a secondary action from the widget")
    
    func perform() async throws -> some IntentResult {
        // Handle the secondary action here
        return .result()
    }
}
