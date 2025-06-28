import SwiftUI
import WidgetKit
import IkigaiCore

struct AccessoryWidgetView: View {
    let entry: SimpleEntry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        #if os(iOS)
        case .accessoryCircular:
            CircularAccessoryView(entry: entry)
        case .accessoryRectangular:
            RectangularAccessoryView(entry: entry)
        case .accessoryInline:
            InlineAccessoryView(entry: entry)
        #endif
        default:
            CircularAccessoryView(entry: entry)
        }
    }
}

// MARK: - Accessory View Variants
struct CircularAccessoryView: View {
    let entry: SimpleEntry
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.blue.gradient)
                .overlay(
                    Circle()
                        .stroke(.white.opacity(0.3), lineWidth: 1)
                )
            
            VStack(spacing: 2) {
                Image(systemName: "star.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                
                Text(entry.title)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(.white)
                    .lineLimit(1)
            }
        }
        .widgetAccentable()
        .accessibilityLabel("Circular widget: \(entry.title)")
    }
}

struct RectangularAccessoryView: View {
    let entry: SimpleEntry
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "star.fill")
                .font(.system(size: 16))
                .foregroundStyle(.blue)
                .widgetAccentable()
            
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.primary)
                
                Text(entry.subtitle)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 4)
        .accessibilityLabel("Rectangular widget: \(entry.title), \(entry.subtitle)")
    }
}

struct InlineAccessoryView: View {
    let entry: SimpleEntry
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .font(.system(size: 12))
                .foregroundStyle(.blue)
                .widgetAccentable()
            
            Text(entry.title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.primary)
        }
        .accessibilityLabel("Inline widget: \(entry.title)")
    }
}
