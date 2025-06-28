import SwiftUI
import WidgetKit
import IkigaiCore
//import UI

struct IkigaiWidgetView: View {
    let entry: SimpleEntry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.blue.opacity(0.8), .purple.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 8) {
                Image(systemName: "star.fill")
                    .font(.system(size: iconSize))
                    .foregroundStyle(.white)
                    .accessibilityLabel("Widget Icon")
                
                Text(entry.title)
                    .font(titleFont)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                
                if family != .systemSmall {
                    Text(entry.subtitle)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                
                if family == .systemLarge {
                    Spacer()
                    
                    HStack(spacing: 4) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(.white.opacity(0.6))
                                .frame(width: 8, height: 8)
                        }
                    }
                }
            }
            .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .accessibilityLabel("Project Widget showing \(entry.title)")
        .accessibilityValue(entry.subtitle)
    }
    
    private var iconSize: CGFloat {
        switch family {
        case .systemSmall:
            return 24
        case .systemMedium:
            return 32
        case .systemLarge:
            return 40
        default:
            return 24
        }
    }
    
    private var titleFont: Font {
        switch family {
        case .systemSmall:
            return .caption
        case .systemMedium:
            return .headline
        case .systemLarge:
            return .title2
        default:
            return .caption
        }
    }
}
