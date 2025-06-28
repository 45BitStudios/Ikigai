import SwiftUI
import WidgetKit
#if canImport(ActivityKit)
import ActivityKit
#endif
import IkigaiCore

// MARK: - Live Activity Attributes
#if canImport(ActivityKit) && os(iOS)
@available(iOS 16.1, *)
struct LiveActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var currentValue: Int
        var targetValue: Int
        var message: String
        var lastUpdated: Date
    }
    
    var activityName: String
}
#endif

// MARK: - Live Activity Widget
#if canImport(ActivityKit) && os(iOS)
@available(iOS 16.1, *)
struct LiveActivityWidget: Widget {
    let kind: String = "LiveActivityWidget"
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivityAttributes.self) { context in
            // Lock screen/banner UI goes here
            LiveActivityLockScreenView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .foregroundStyle(.blue)
                        Text("\(context.state.currentValue)")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("/ \(context.state.targetValue)")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(spacing: 4) {
                        ProgressView(value: Double(context.state.currentValue), total: Double(context.state.targetValue))
                            .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        
                        Text(context.state.message)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal)
                }
            } compactLeading: {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundStyle(.blue)
            } compactTrailing: {
                Text("\(context.state.currentValue)")
                    .font(.caption2)
                    .fontWeight(.semibold)
            } minimal: {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundStyle(.blue)
            }
        }
        .configurationDisplayName("Live Activity")
        .description("Track real-time progress")
        .supportedFamilies([.accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}
#endif

// MARK: - Live Activity Views
#if canImport(ActivityKit) && os(iOS)
@available(iOS 16.1, *)
struct LiveActivityLockScreenView: View {
    let context: ActivityViewContext<LiveActivityAttributes>
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.title2)
                    .foregroundStyle(.blue)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(context.attributes.activityName)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("Updated \(context.state.lastUpdated, style: .relative) ago")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(context.state.currentValue)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.blue)
                    
                    Text("of \(context.state.targetValue)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            VStack(spacing: 8) {
                ProgressView(value: Double(context.state.currentValue), total: Double(context.state.targetValue))
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                
                Text(context.state.message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .accessibilityLabel("Live Activity: \(context.attributes.activityName)")
        .accessibilityValue("\(context.state.currentValue) of \(context.state.targetValue)")
    }
}
#endif
