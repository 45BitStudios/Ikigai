import SwiftUI
import WidgetKit
import IkigaiCore

// MARK: - Main Widget
struct IkigaiWidget: Widget {
    let kind: String = "YourProjectNameWidget"
    
    static var supportedWidgetFamilies: [WidgetFamily] {
        var families: [WidgetFamily] = [.systemSmall, .systemMedium, .systemLarge]
        #if os(iOS)
        families.append(.systemExtraLarge)
        #endif
        return families
    }
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            IkigaiWidgetView(entry: entry)
        }
        .configurationDisplayName("Project Widget")
        .description("Main widget showing project information")
        .supportedFamilies(Self.supportedWidgetFamilies)
    }
}

// MARK: - Accessory Widgets
struct AccessoryWidget: Widget {
    let kind: String = "AccessoryWidget"
    
    static var supportedAccessoryFamilies: [WidgetFamily] {
        #if os(iOS)
        return [.accessoryCircular, .accessoryRectangular, .accessoryInline]
        #else
        return [.systemSmall]
        #endif
    }
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: AccessoryProvider()) { entry in
            AccessoryWidgetView(entry: entry)
        }
        .configurationDisplayName("Quick Info")
        .description("Compact info for Lock Screen and Apple Watch")
        .supportedFamilies(Self.supportedAccessoryFamilies)
    }
}

// MARK: - Interactive Widget
struct InteractiveWidget: Widget {
    let kind: String = "InteractiveWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            InteractiveWidgetView(entry: entry)
        }
        .configurationDisplayName("Interactive Widget")
        .description("Widget with interactive buttons")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Timeline Providers
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), title: "Placeholder", subtitle: "Loading...")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), title: "Snapshot", subtitle: "Quick preview")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let currentDate = Date()
        for hourOffset in 0..<5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(
                date: entryDate,
                title: "Widget \(hourOffset + 1)",
                subtitle: "Updated at \(DateFormatter.localizedString(from: entryDate, dateStyle: .none, timeStyle: .short))"
            )
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct AccessoryProvider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), title: "Quick", subtitle: "Info")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), title: "Live", subtitle: "Data")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entries = [
            SimpleEntry(date: Date(), title: "Status", subtitle: "Active")
        ]
        let timeline = Timeline(entries: entries, policy: .after(Date().addingTimeInterval(3600)))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let title: String
    let subtitle: String
}
