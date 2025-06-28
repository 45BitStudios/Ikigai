# AI Assistant Context for Xcode Template Projects

This document contains important context and requirements for AI assistants working with projects created from this Xcode template.

## Project Requirements Overview

### Core Framework Requirements
- **SwiftUI Only**: All UI must use SwiftUI framework
- **No UIKit**: Do not use UIKit components unless explicitly requested
- **No Storyboards**: All UI is programmatically defined in SwiftUI
- **Swift Testing**: Use Swift Testing framework, not XCTest
- **Liquid Glass Design**: Leverage Apple's Liquid Glass design system
- **Modern Apple Frameworks**: Integrate enhanced App Intents, Vision framework, WidgetKit, and ActivityKit

### Platform Compatibility
All code must be compatible with:
- iOS 26.0+
- iPadOS 26.0+ 
- macOS 26.0+
- watchOS 26.0+
- tvOS 26.0+
- visionOS 26.0+

**Swift Version:** 6.2 or later with full concurrency support

Use `#if os()` compiler directives when platform-specific code is needed.

### Required Project Targets
Every project includes these targets:
1. **Main App** - Primary application
2. **App Clips** - Lightweight app experiences
3. **Action Extension** - System-wide custom actions
4. **Share Extension** - Content sharing from other apps
5. **Notification Extension** - Custom notification content UI
6. **Notification Service Extension** - Notification content modification and rich media
7. **Message Extension** - iMessage app integration
8. **Spotlight Extension** - Custom search results
9. **Widget Extension** - Complete widget ecosystem:
   - System Widgets (Home screen: Small, Medium, Large, Extra Large)
   - Accessory Widgets (Lock screen, Apple Watch: Circular, Rectangular, Inline)
   - Interactive Widgets (App Intents integration)
   - Live Activities (Dynamic Island, real-time updates)
   - Control Widgets (iOS 18+ Control Center)
10. **Watch Extension** - Apple Watch companion
11. **Test Target** - Swift Testing tests

### Localization Requirements
- **Shared String Catalog**: Single `Localizable.xcstrings` file in Core package (`Sources/Core/Resources/`)
- **Clean SwiftUI API**: Use unified localization extensions that hide bundle complexity:
  ```swift
  // Text views
  Text(localized: "hello_world")
  
  // Accessibility labels  
  .accessibilityLabel(localized: "star_icon")
  
  // Navigation titles
  .navigationTitle(localized: "my_app_title")
  
  // String interpolation
  Text(String.localized("counter_label", counter))
  ```
- **Single Source of Truth**: One `.xcstrings` file shared across all targets (main app, watch app, extensions)
- Never hardcode user-facing strings
- Base Internationalization enabled for all targets
- **Info.plist Localization**: Use InfoPlist.strings files for privacy descriptions
  - Template includes: English, Spanish, French, German, Japanese
  - Usage descriptions are automatically localized based on device language
- Non-localized string analyzer enabled to catch violations
- Support RTL (Right-to-Left) languages like Arabic and Hebrew
- Localize assets and images in Assets.xcassets when needed
- Test with different locales and text expansion (German text is ~30% longer)

#### Localization Architecture Benefits
- **Consistency**: Same localization keys work across all platforms and targets
- **Maintainability**: Centralized string management in Core package
- **Clean Code**: No bundle references needed in consuming code
- **Scalability**: Easy to add new languages and maintain translations

### Accessibility Requirements
- Always include accessibility modifiers on SwiftUI views
- Use `.accessibilityLabel()`, `.accessibilityHint()`, `.accessibilityValue()`
- Consider VoiceOver, Switch Control, and other assistive technologies
- Test accessibility with Xcode's Accessibility Inspector

### Push Notifications and Background Processing Requirements
- **Push Notifications**: Full APNs integration with development and production support
- **Background Modes**: Configured for `remote-notification`, `background-fetch`, and `background-processing`
- **Notification Categories**: Interactive notifications with reply and action buttons
- **UserNotifications Framework**: Complete notification management with proper permissions
- **Background Task Management**: Proper background execution with task lifecycle management
- **Device Token Management**: Automatic device token registration and server communication
- **Silent Notifications**: Support for content-available background notifications
- **Rich Notifications**: Notification Service Extension for media attachments and content modification

#### Push Notification Setup Instructions
The template includes comprehensive push notification support:

**Entitlements Configuration**:
- `aps-environment`: Set to `development` (change to `production` for App Store)
- `com.apple.developer.usernotifications.communication`: Support for communication notifications
- `com.apple.developer.usernotifications.time-sensitive`: Time-sensitive notifications

**Usage in Code**:
```swift
// Request notification permission
let granted = try await NotificationService.shared.requestAuthorization()
if granted {
    NotificationService.shared.registerForRemoteNotifications()
}

// Schedule local notification
await NotificationService.shared.scheduleLocalNotification(
    title: "Test",
    body: "Message",
    timeInterval: 5
)

// Handle background tasks
BackgroundTaskManager.shared.executeBackgroundTask {
    // Perform background work
}
```

**Server Integration**:
- Device tokens are automatically captured and logged
- Implement `NotificationServiceDelegate` to send tokens to your server
- Use provided `PushNotificationPayload` model for structured payloads

### App Shortcuts Integration Requirements
- **Info.plist Configuration**: Main app target includes pre-configured CFBundleIcons with App Shortcuts color settings
- **Color Assets**: Three sample color assets are included:
  - `ShortcutsForeground`: Tint color for Shortcuts app icon actions
  - `ShortcutsBackground1`: Primary gradient background color
  - `ShortcutsBackground2`: Complementary background color
- **Light/Dark Mode**: All color assets include automatic light and dark mode variants
- **Customization**: Colors should be customized to match app branding
- **App Intents Integration**: Use these colors consistently with App Intents for visual coherence
- **Sample Implementation**: Core package includes GreetingIntent as a working example

#### Swift Package App Intents Architecture
The template implements proper App Intents integration across Swift packages:

**Package Declaration Pattern**:
```swift
// In Swift Package (Sources/Core/CoreModule.swift)
public struct MyFrameworkPackage: AppIntentsPackage {
}

public struct YourIntent: AppIntent {
    // Intent implementation
}
```

**Main App Registration Pattern**:
```swift
// In Main App (XcodeTemplate/App/AppShortcutsProvider.swift)
struct MyAppShortcutsProvider: AppShortcutsProvider, @MainActor AppIntentsPackage {
    @MainActor static let includedPackages: [any AppIntentsPackage.Type] = [
        MyFrameworkPackage.self
    ]
    
    static var appShortcuts: [AppShortcut] {
        // AppShortcut definitions using package intents
    }
}
```

**Required Implementation Steps**:
1. Define App Intents in Swift packages with public access
2. Create AppIntentsPackage conforming struct in each package containing intents
3. Main app shortcuts provider must conform to both AppShortcutsProvider and @MainActor AppIntentsPackage
4. Use @MainActor static let for includedPackages array to ensure concurrency safety and immutability
5. Register all package types in includedPackages array
6. Reference package intents in appShortcuts array

**Critical Concurrency Requirements**:
- Use `@MainActor` annotation on AppIntentsPackage conformance for thread safety
- Mark `includedPackages` as `@MainActor static let` to prevent runtime modification
- Ensures App Intents registration happens on the main thread as required by the system

### Code Documentation Requirements
**All code must follow Apple Style Documentation Comments**:

#### Documentation Standards
- **All public APIs** must have complete documentation using `///` 
- **All complex private functions** should be documented
- **All classes and structs** must have class-level documentation
- **All properties** should have brief descriptions
- Use `// MARK:` comments to organize code sections
- Follow Apple's documentation style guide consistently
- Include parameter descriptions, return values, and error conditions

#### Required Documentation Elements
```swift
/// Brief description of the function or class
///
/// Detailed explanation when necessary.
///
/// - Parameters:
///   - parameterName: Description of the parameter
/// - Returns: Description of what this returns
/// - Throws: Description of errors that might be thrown
/// - Note: Additional important information
/// - Warning: Critical warnings about usage
```

#### Documentation Quality Standards
- Use complete sentences with proper punctuation
- Provide clear, concise descriptions
- Document complex algorithms and business logic
- Include usage examples for non-trivial APIs
- Maintain consistency across the codebase

## Code Style Guidelines

### SwiftUI Best Practices
```swift
// Good - Modern SwiftUI approach with @Observable
@Observable
class ContentViewModel {
    var isPresented = false
    var items: [Item] = []
    
    func loadData() async {
        // Use async/await instead of completion handlers
        do {
            items = try await DataService.shared.fetchItems()
        } catch {
            print("Failed to load data: \(error)")
        }
    }
}

struct ContentView: View {
    @State private var viewModel = ContentViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Hello, World!")
                    .accessibilityLabel("Greeting message")
            }
            .navigationTitle("Home")
            .task {
                await viewModel.loadData()
            }
        }
    }
}

// Avoid - UIKit patterns
// Don't use UIViewRepresentable unless absolutely necessary
// Don't use @ObservedObject or @StateObject - use @Observable instead
// Don't use completion handlers - use async/await
```

### Platform-Specific Code
```swift
// Handle platform differences appropriately
var body: some View {
    #if os(macOS)
    MacOSSpecificView()
    #elseif os(watchOS)  
    WatchOSSpecificView()
    #else
    DefaultView()
    #endif
}
```

### Testing with Swift Testing
```swift
import Testing
@testable import YourApp

struct ContentViewTests {
    @Test func exampleTest() {
        // Use Swift Testing syntax, not XCTest
        #expect(true == true)
    }
}
```

## Modern Frameworks Integration

### App Intents (Enhanced)
- Integrate with system experiences and shortcuts
- Implement interactive snippets for immediate actions
- Support hardware interactions (Action button, Apple Pencil)
```swift
import AppIntents

struct CustomIntent: AppIntent {
    static var title: LocalizedStringResource = "Custom Action"
    
    func perform() async throws -> some IntentResult {
        // Implementation with system integration
        return .result()
    }
}
```

### Vision Framework
- Use advanced text recognition capabilities
- Implement body pose tracking for interactions
- Add object detection and classification
```swift
import Vision

@Observable
class VisionViewModel {
    func processImage(_ image: UIImage) async throws -> [String] {
        // Vision framework implementation
        return []
    }
}
```

### WidgetKit & ActivityKit
- Implement comprehensive widget support
- Use Live Activities for real-time updates
- Support all widget families and sizes

## Common Patterns to Follow

### App Architecture
- Use MVVM or similar architecture patterns
- Use `@Observable` macro for view models instead of `ObservableObject`
- Use `@State` for simple view state management
- Use `@Environment` for dependency injection
- Prefer async/await over completion handlers for asynchronous operations
- Implement Swift 6.2 structured concurrency patterns

### Liquid Glass Design System
- Use system frameworks for automatic Liquid Glass adoption
- Reduce custom backgrounds in controls and navigation
- Apply `glassEffect(_:in:isEnabled:)` sparingly for emphasis
- Test with accessibility settings (reduce transparency/motion)
```swift
// Good - System component with automatic Liquid Glass
NavigationStack {
    List {
        // Content
    }
    .navigationTitle("Title")
}

// Avoid - Custom glass effects everywhere
.background(.regularMaterial.opacity(0.8))
```

### Data Management
- Prefer SwiftData over Core Data for new projects
- Use `@Observable` macro for all view models and data classes
- Use async/await for all network requests and data operations
- Implement proper data flow patterns with modern Swift concurrency
- Use Foundation Models for on-device AI processing

### Widget Development Guidelines

#### Widget Architecture
All widgets must follow these patterns:
- Use `TimelineProvider` for data updates and scheduling
- Implement proper `TimelineEntry` with date and content data
- Support all appropriate widget families and sizes
- Include accessibility labels, hints, and values
- Use `@Environment(\.widgetFamily)` for size-specific layouts

#### Widget Types and Requirements

**System Widgets** (Home screen):
```swift
struct YourProjectNameWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            YourProjectNameWidgetView(entry: entry)
        }
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .systemExtraLarge])
    }
}
```

**Accessory Widgets** (Lock screen, Apple Watch):
```swift
struct AccessoryWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: AccessoryProvider()) { entry in
            AccessoryWidgetView(entry: entry)
        }
        .supportedFamilies([.accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}
```

**Interactive Widgets** (App Intents):
```swift
struct InteractiveWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            InteractiveWidgetView(entry: entry)
        }
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// Always include App Intents for interactive elements
struct QuickActionIntent: AppIntent {
    static var title: LocalizedStringResource = "Quick Action"
    func perform() async throws -> some IntentResult {
        return .result()
    }
}
```

**Live Activities** (Dynamic Island, Lock screen):
```swift
struct LiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivityAttributes.self) { context in
            LiveActivityLockScreenView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded regions: .leading, .trailing, .bottom
            } compactLeading: {
                // Compact leading
            } compactTrailing: {
                // Compact trailing  
            } minimal: {
                // Minimal view
            }
        }
    }
}
```

**Control Widgets** (iOS 18+ Control Center):
```swift
@available(iOS 18.0, *)
struct ControlWidget: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: kind) {
            ControlWidgetToggle("Toggle", isOn: state, action: ToggleIntent()) { isOn in
                Label(isOn ? "On" : "Off", systemImage: isOn ? "power.circle.fill" : "power.circle")
            }
        }
    }
}
```

#### Widget Design Principles
- **Glanceable**: Show key information at a glance
- **Relevant**: Display timely, useful content
- **Contextual**: Adapt content to user context and time
- **Interactive**: Use App Intents for immediate actions (iOS 17+)
- **Accessible**: Full VoiceOver and assistive technology support
- **Consistent**: Follow Apple's design guidelines and Liquid Glass principles

#### Widget Data Management
- Use Core package for business logic and data models
- Use UI package for shared SwiftUI components
- Implement proper error handling in timeline providers
- Cache data appropriately for offline scenarios
- Use UserDefaults or App Groups for widget-app data sharing

#### Widget Refresh Strategies
```swift
// Hourly updates
let timeline = Timeline(entries: entries, policy: .after(Date().addingTimeInterval(3600)))

// End of entries
let timeline = Timeline(entries: entries, policy: .atEnd)

// Never refresh (static content)
let timeline = Timeline(entries: entries, policy: .never)
```

#### Live Activities Best Practices
- Use for ongoing activities with real-time updates
- Implement proper Dynamic Island layouts for all sizes
- Handle activity lifecycle (start, update, end)
- Optimize for battery and performance
- Include meaningful progress indicators

#### Control Widgets Guidelines (iOS 18+)
- Keep controls simple and focused on single actions
- Use appropriate control types (toggle, button, value)
- Implement immediate feedback
- Handle control state properly
- Test in Control Center environment

### Extension Development
- Keep extensions lightweight and focused
- Share code via shared frameworks between targets
- Handle extension lifecycle properly

## Swift Package Manager Architecture

This template uses Swift Package Manager for modular code organization and reusability.

### Package Structure

```
Package.swift            # Swift Package Manager manifest
project.yml              # XcodeGen project configuration
Sources/                 # Swift Package Manager source code only
├── Core/               # Core Swift package (business logic)
├── UI/                 # UI Swift package (SwiftUI components)
├── CoreTests/          # Core package tests
└── UITests/            # UI package tests
XcodeTemplate/          # All Xcode project files (rename per project)
├── App/                # Main app target
├── AppClips/           # App Clips specific code
├── ActionExtension/    # Action extension
├── ShareExtension/     # Share extension
├── NotificationExtension/ # Notification content extension
├── NotificationServiceExtension/ # Notification service extension
├── MessageExtension/   # Message extension
├── SpotlightExtension/ # Spotlight extension
├── WidgetExtension/    # Widget extension
├── WatchApp/           # watchOS app source
├── WatchExtension/     # watchOS extension source
├── Resources/          # Assets, localizations, Info.plist strings
└── Configs/            # Build configurations
```

### Package Dependencies

The project is configured to use a remote GitHub package dependency:

**Remote Package Configuration:**
- **Repository**: `https://github.com/vinced45/xcode-template.git`
- **Package Name**: `YourProjectPackage`
- **Core Product**: Foundation utilities, models, networking, data persistence, and Apple framework wrappers
  - Shared utilities and common functionality
  - HTTP clients and API layer with async/await
  - SwiftData models and persistence layer
  - App Intents, Vision framework, WidgetKit, and ActivityKit integration
  - Extension utilities and protocols

**UI Product**: Reusable SwiftUI components and user interface elements
  - Depends on Core package
  - Liquid Glass design system components
  - Platform-specific SwiftUI views
  - Widget and Watch-specific UI components
  - Accessibility-first SwiftUI modifiers

**Development Approaches:**
- **Local Development**: Use `YourProjectWorkspace.xcworkspace` with local package
- **Production**: Use `YourProjectName.xcodeproj` with versioned remote package

### Benefits of Simplified Architecture

1. **Simplicity**: Two focused packages with clear separation of concerns
2. **Reusability**: Both packages can be used across multiple projects
3. **Testing**: Isolated testing for business logic (Core) and UI components (UI)
4. **Performance**: Faster compilation with minimal dependencies
5. **Team Development**: Backend/logic teams work on Core, UI teams work on UI
6. **External Distribution**: Clean API surface for sharing with other developers

## Development Workflow

### When Adding New Features
1. Determine which targets need the feature
2. Implement in `Shared/` if used across targets
3. Add platform-specific implementations as needed
4. Write Swift Testing tests
5. Verify accessibility compliance
6. Test on multiple platforms

### When Fixing Issues
1. Identify affected targets and platforms
2. Check if issue exists across all supported OS versions
3. Implement fix with proper platform guards if needed
4. Update tests to prevent regression

## AI Assistant Guidelines

### What TO Do
- Always ask about target platform requirements if unclear
- Suggest SwiftUI-native solutions first with Liquid Glass design principles
- Use `@Observable` macro for view models and data classes
- Use async/await for all asynchronous operations with Swift 6.2 concurrency
- Organize code into Core and UI packages for modularity and reusability
- Place business logic, models, networking, and data in Core package
- Place SwiftUI components and views in UI package
- Use package imports in app targets (e.g., `import Core`, `import UI`)
- **Use shared localization system**: Always use clean SwiftUI localization extensions
  - `Text(localized: "key")` instead of `Text("key", bundle: CoreModule.bundle)`
  - `.accessibilityLabel(localized: "key")` instead of bundle-based APIs
  - `String.localized("key", arguments)` for string interpolation
- **Leverage App Shortcuts integration**: Use pre-configured color assets for consistent branding
  - Reference `ShortcutsForeground`, `ShortcutsBackground1`, `ShortcutsBackground2` in App Intents
  - Ensure App Intents use matching visual styling for Shortcuts app integration
  - Follow the GreetingIntent example for implementing new App Intents
  - **Implement proper Swift Package App Intents architecture**:
    - Create AppIntentsPackage conforming struct in each package with intents
    - Register package types in main app's MyAppShortcutsProvider.includedPackages
    - Always conform shortcuts provider to both AppShortcutsProvider and @MainActor AppIntentsPackage
    - Use @MainActor static let for includedPackages to ensure concurrency safety
- **Always include Apple Style documentation**: Every function, class, and public API must be documented
  - Use `///` for documentation comments with proper parameter descriptions
  - Include return values, error conditions, and usage examples
  - Use `// MARK:` comments to organize code sections
- Integrate modern Apple frameworks (AlarmKit, App Intents, Foundation Models, Vision)
- Include accessibility considerations in all UI code
- Recommend Swift Testing for new tests
- Consider multi-platform compatibility in all suggestions
- Use system integration integration where appropriate
- Apply Liquid Glass design system principles
- Test with reduce transparency/motion accessibility settings
- Implement all widget types when widget functionality is requested:
  - System Widgets for home screen display
  - Accessory Widgets for Lock screen and Apple Watch
  - Interactive Widgets for immediate actions
  - Live Activities for real-time updates
  - Control Widgets for iOS 18+ Control Center integration
- Use proper Timeline Providers for widget data updates
- Include App Intents for interactive widget elements
- Design widgets to be glanceable and contextually relevant
- Implement proper widget refresh strategies based on content type

### What NOT To Do
- Don't suggest UIKit unless explicitly requested
- Don't use `@ObservedObject` or `@StateObject` - use `@Observable` instead
- Don't use completion handlers - use async/await instead
- Don't put shared code directly in app targets - use Swift packages
- Don't create monolithic packages - separate concerns appropriately
- Don't forget to add package dependencies in project.yml
- **Don't use bundle-based localization APIs** - always use clean SwiftUI extensions:
  - ❌ `Text("key", bundle: CoreModule.bundle)`
  - ✅ `Text(localized: "key")`  
  - ❌ `.accessibilityLabel(String(localized: "key", bundle: CoreModule.bundle))`
  - ✅ `.accessibilityLabel(localized: "key")`
- Don't overuse Liquid Glass effects - apply sparingly
- Don't create custom glass backgrounds when system components exist
- Don't ignore accessibility requirements
- Don't hardcode strings that should be localized - always use String Catalogs
- Don't assume single-platform deployment
- Don't use deprecated APIs when modern alternatives exist
- Don't ignore system integration capabilities for appropriate use cases
- Don't forget to add required Info.plist descriptions for new frameworks
- Don't ignore RTL language support in UI layouts
- Don't assume text length - test with longer languages like German
- **Don't write undocumented code** - all public APIs and complex functions must have Apple Style documentation
  - ❌ `func processData() { ... }` 
  - ✅ `/// Processes user data and returns formatted results`
- Don't create widgets without proper Timeline Providers
- Don't implement interactive widgets without App Intents
- Don't ignore widget accessibility requirements
- Don't create overly complex widgets - keep them glanceable
- Don't forget to support appropriate widget families for each widget type
- Don't implement Live Activities without proper Dynamic Island layouts
- Don't create Control Widgets without iOS 18+ availability checks

### When Uncertain
- Ask about specific platform requirements
- Clarify which targets need the feature
- Confirm accessibility requirements
- Verify localization needs

## Project Maintenance

### Regular Updates
- Keep deployment targets current with Apple's recommendations
- Update to latest Swift and SwiftUI APIs
- Monitor and update extension capabilities
- Review accessibility compliance regularly

### Performance Considerations
- Optimize for all target platforms
- Consider watchOS memory constraints
- Minimize App Clips bundle size
- Profile extension performance impact

This context ensures consistent, high-quality development across all projects created from this template.