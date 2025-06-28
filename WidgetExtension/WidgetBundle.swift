import SwiftUI
import WidgetKit

@main
struct YourProjectNameWidgetBundle: WidgetBundle {
    var body: some Widget {
        // Main Widgets
        IkigaiWidget()
        AccessoryWidget()
        InteractiveWidget()
        
        // Live Activities - iOS only
        #if canImport(ActivityKit) && os(iOS)
        LiveActivityWidget()
        #endif
        
        // Control Widgets - Disabled for iOS 26.0 compatibility
        // ToggleControlWidget()
        // ValueDisplayControlWidget()
        // MultiActionControlWidget()
    }
}
