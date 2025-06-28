# Xcode Project Template

This template provides a comprehensive setup for creating Xcode projects with all necessary targets and configurations.

## Requirements

- Xcode 16.0 or later
- XcodeGen (install via `brew install xcodegen`)
- Swift 6.2 or later
- Swift Package Manager (included with Xcode)

## Project Structure

This template creates projects with the following targets:
- **Main App** - Primary application target
- **App Clips** - Lightweight app experiences
- **Action Extension** - Custom actions in system contexts
- **Share Extension** - Sharing content from other apps
- **Notification Extension** - Custom notification content interfaces
- **Notification Service Extension** - Notification content modification and rich media
- **Message Extension** - iMessage app extensions
- **Spotlight Extension** - Custom Spotlight search results
- **Widget Extension** - Home screen, Lock screen widgets, Live Activities, and Control Widgets
- **Watch Extension** - Apple Watch companion app
- **Test Target** - Swift Testing framework tests

## Platform Compatibility

All projects are configured to support:
- iOS 26.0+
- iPadOS 26.0+
- macOS 26.0+
- watchOS 26.0+
- tvOS 26.0+
- visionOS 26.0+

**Swift Version:** 6.2 or later

## Features

- **SwiftUI Only** - Modern declarative UI framework (no UIKit or Storyboards)
- **Liquid Glass Design** - Apple's modern design system with fluid, responsive interfaces
- **Modern Apple Frameworks** - Enhanced App Intents, Vision framework, WidgetKit, ActivityKit
- **System Integration** - Deep integration with iOS system features and frameworks
- **Localization** - Multi-language support using String Catalogs
- **Accessibility** - Built-in accessibility features and support
- **Swift Testing** - Modern testing framework integration
- **Universal Platform Support** - Single codebase for all Apple platforms
- **Swift 6.2** - Modern concurrency with async/await and @Observable
- **Swift Package Manager** - Modular architecture with reusable packages
- **Widget Ecosystem** - Complete widget suite including:
  - **System Widgets** - Home screen widgets (Small, Medium, Large, Extra Large)
  - **Accessory Widgets** - Lock screen and Apple Watch widgets (Circular, Rectangular, Inline)
  - **Interactive Widgets** - Widgets with buttons and App Intents integration
  - **Live Activities** - Real-time updates with Dynamic Island support
  - **Control Widgets** - iOS 18+ Control Center quick actions

## Quick Start

1. Clone this template directory
2. Customize the `project.yml` file with your project details
3. Run the setup script:
   ```bash
   ./setup.sh
   ```

## Manual Setup

1. **Configure Project Settings**
   - Edit `project.yml` and update:
     - `name`: Your project name (this will also be your folder name)
     - `bundleIdPrefix`: Your bundle identifier prefix
     - `deploymentTarget`: Minimum OS versions if different

2. **Generate Xcode Project**
   ```bash
   xcodegen generate
   ```

3. **Open in Xcode**
   ```bash
   # Open the workspace (recommended for Swift Package integration)
   open YourProjectWorkspace.xcworkspace
   
   # Or open just the project
   open YourProjectName.xcodeproj
   ```

**Note**: String Catalog (`.xcstrings`) files and Asset Catalogs are included as templates. You can expand localization by adding more languages in Xcode Project Settings > Localizations.

## Package Management

The template is configured to use the Swift Package hosted on GitHub as a remote dependency:

### Package Configuration:
- **Package Repository**: `https://github.com/vinced45/xcode-template.git`
- **Core Module**: Shared business logic and data models
- **UI Module**: Reusable SwiftUI components and views

### Workspace vs Project:
- **YourProjectWorkspace.xcworkspace** - Recommended for local package development
- **YourProjectName.xcodeproj** - Uses remote GitHub package dependency

### Benefits of Remote Package:
- **Version Control**: Tagged releases and semantic versioning
- **Distribution**: Share common code across multiple projects
- **Team Development**: Collaborative package development
- **CI/CD Integration**: Automated package testing and deployment

## Customization

### Adding New Targets
Edit `project.yml` and add your target configuration under the `targets` section.

### Localization Setup
1. **Shared String Catalog**: Single `Localizable.xcstrings` file in Core package (`Sources/Core/Resources/`)
2. **Clean SwiftUI API**: Unified localization extensions hide bundle complexity:
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
3. **Base Internationalization**: Enabled for all targets
4. **Info.plist Localization**: Pre-configured InfoPlist.strings files for:
   - English (en.lproj)
   - Spanish (es.lproj)
   - French (fr.lproj)
   - German (de.lproj)
   - Japanese (ja.lproj)
5. **Add More Languages**: In Xcode Project Settings > Localizations, add:
   - Chinese Simplified (zh-Hans)
   - Arabic (ar) - for RTL testing
   - Portuguese (pt)
   - Italian (it)
6. **Asset Localization**: Add language-specific images to Assets.xcassets
7. **Analyzer**: Non-localized strings analyzer enabled to catch hardcoded text

#### Localization Benefits
- **Single Source**: One `.xcstrings` file shared across all targets (main app, watch app, extensions)
- **Clean API**: No bundle references needed in consuming code
- **Consistent**: Same localization keys work across all platforms
- **Maintainable**: Centralized string management in Core package

### Info.plist Localization
Privacy usage descriptions are automatically localized using InfoPlist.strings files:
- Microphone, speech recognition, camera, location permissions
- App display name and bundle name
- All standard iOS permission descriptions

### Accessibility
- Use semantic SwiftUI modifiers (`.accessibilityLabel()`, `.accessibilityHint()`)
- Test with VoiceOver and other assistive technologies
- Follow Apple's accessibility guidelines

### Code Documentation
All code should follow **Apple Style Documentation Comments**:

#### Swift Documentation Standards
```swift
/// Brief description of the class, function, or property
/// 
/// Detailed explanation of what this does, how it works, and when to use it.
/// Use complete sentences and proper punctuation.
///
/// - Parameters:
///   - parameterName: Description of what this parameter does
///   - anotherParam: Another parameter description
/// - Returns: Description of what this function returns
/// - Throws: Description of errors this function might throw
/// - Note: Additional important information
/// - Warning: Critical warnings about usage
/// - Important: Important considerations
/// - SeeAlso: Related functions or documentation
/// - Since: Version when this was introduced
/// - Author: Author information if needed
/// - Version: Version information if needed
public func exampleFunction(parameterName: String, anotherParam: Int) throws -> String {
    // Implementation
}
```

#### Documentation Requirements
- **All public APIs** must have complete documentation
- **All complex private functions** should be documented
- **All classes and structs** must have class-level documentation
- **All properties** should have brief descriptions
- Use **triple slash (`///`)** for documentation comments
- Use **double slash (`//`)** for implementation comments
- Follow Apple's documentation style guide consistently
- Include parameter descriptions, return values, and error conditions
- Document complex algorithms and business logic
- Provide usage examples for non-trivial APIs

#### MARK Comments
Use `// MARK:` to organize code sections:
```swift
// MARK: - Public Interface
// MARK: - Private Helpers  
// MARK: - Protocol Conformance
// MARK: - Extensions
```

### App Shortcuts Integration
The template includes pre-configured support for App Shortcuts with custom tint and background colors and proper Swift Package integration:

#### Info.plist Configuration
```xml
<key>CFBundleIcons</key>
<dict>
    <key>CFBundlePrimaryIcon</key>
    <dict>
        <key>NSAppIconActionTintColorName</key>
        <string>ShortcutsForeground</string>
        <key>NSAppIconComplementingColorNames</key>
        <array>
            <string>ShortcutsBackground1</string>
            <string>ShortcutsBackground2</string>
        </array>
    </dict>
</dict>
```

#### Color Assets
Three sample color assets are included in `Assets.xcassets`:
- **ShortcutsForeground**: White tint color for Shortcuts app icon actions
- **ShortcutsBackground1**: Orange-blue gradient background color (light/dark variants)
- **ShortcutsBackground2**: Complementary orange background color (light/dark variants)

#### Swift Package App Intents Integration
The template demonstrates proper App Intents implementation across Swift packages:

**Step 1: Define App Intents in Swift Package**
```swift
// In Sources/Core/CoreModule.swift
public struct GreetingIntent: AppIntent {
    public static let title: LocalizedStringResource = "Generate Greeting"
    // ... intent implementation
}

// Package declaration for App Intents discovery
public struct MyFrameworkPackage: AppIntentsPackage {
}
```

**Step 2: Register Package in Main App**
```swift
// In XcodeTemplate/App/AppShortcutsProvider.swift
struct MyAppShortcutsProvider: AppShortcutsProvider, @MainActor AppIntentsPackage {
    @MainActor static let includedPackages: [any AppIntentsPackage.Type] = [
        MyFrameworkPackage.self
    ]
    
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: GreetingIntent(),
            phrases: ["Generate greeting with \(.applicationName)"],
            shortTitle: "Greeting",
            systemImageName: "hand.wave"
        )
    }
}
```

#### Architecture Benefits
- **Package Intents**: App Intents defined in reusable Swift packages
- **Automatic Discovery**: AppIntentsPackage protocol enables intent discovery
- **Centralized Registration**: MyAppShortcutsProvider in main app registers all package intents
- **Proper Isolation**: Swift package intents remain modular and testable
- **Concurrency Safety**: @MainActor ensures thread-safe package registration
- **Immutable Configuration**: `let` ensures includedPackages cannot be modified at runtime

#### Customization
- Replace color values in the `.colorset` files to match your app's brand
- Colors automatically adapt to light/dark mode
- Used by the Shortcuts app when displaying your app's actions and intents
- Provides visual consistency between your app and the Shortcuts ecosystem
- Add new intents to Swift packages and register them via includedPackages array

### Widget Development
The template includes comprehensive widget support:

#### Widget Types
1. **System Widgets** (`YourProjectNameWidget`)
   - Home screen widgets in all sizes (Small, Medium, Large, Extra Large)
   - Timeline-based updates
   - Static configuration

2. **Accessory Widgets** (`AccessoryWidget`)
   - Lock screen widgets (Circular, Rectangular, Inline)
   - Apple Watch complications
   - Compact information display
   - Widget accent color support

3. **Interactive Widgets** (`InteractiveWidget`)
   - Buttons with App Intents integration
   - Immediate actions without opening the app
   - Available in Small and Medium sizes

4. **Live Activities** (`LiveActivityWidget`)
   - Real-time updates on Lock screen and Dynamic Island
   - Progress tracking and status updates
   - Custom Dynamic Island layouts (compact, minimal, expanded)
   - ActivityKit integration

5. **Control Widgets** (`ControlWidget`, `ValueControlWidget`, `MultiActionControlWidget`)
   - iOS 18+ Control Center integration
   - Quick toggle controls
   - Value increment/decrement controls
   - Multi-action controls

#### Widget Features
- **Timeline Providers**: Automatic refresh scheduling
- **App Intents**: Interactive widget actions
- **Dynamic Island**: Live Activities with custom layouts
- **Accessibility**: Full VoiceOver and assistive technology support
- **Material Design**: Modern Liquid Glass visual effects
- **Package Integration**: Uses Core and UI packages for shared functionality

#### Usage Examples
```swift
// Timeline Provider
struct Provider: TimelineProvider {
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // Update widget data every hour
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

// Interactive Widget with App Intent
Button(intent: QuickActionIntent()) {
    Text("Action")
}

// Live Activity
LiveActivityAttributes.ContentState(
    currentValue: progress,
    targetValue: target,
    message: "In Progress..."
)
```

## Swift Package Manager Architecture

This template uses Swift Package Manager for modular, reusable code organization:

### File Structure

```
YourProject/
├── Package.swift              # Swift Package Manager manifest
├── Sources/
│   ├── App/                   # Main app source
│   ├── AppClips/              # App Clips source
│   ├── Extensions/            # All extension sources
│   │   ├── ActionExtension/
│   │   ├── ShareExtension/
│   │   ├── NotificationExtension/
│   │   ├── MessageExtension/
│   │   ├── SpotlightExtension/
│   │   └── WidgetExtension/
│   ├── WatchApp/              # Watch app source
│   ├── WatchExtension/        # Watch extension source
├── Sources/                   # Swift Package Manager source code only
│   ├── Core/                  # Core Swift package (business logic)
│   ├── UI/                    # UI Swift package (SwiftUI components)
│   ├── CoreTests/             # Core package tests
│   └── UITests/               # UI package tests
├── XcodeTemplate/             # All Xcode project files (rename per project)
│   ├── App/                   # Main app source
│   ├── AppClips/              # App Clips source
│   ├── ActionExtension/       # Action extension source
│   ├── ShareExtension/        # Share extension source
│   ├── NotificationExtension/ # Notification content extension source
│   ├── NotificationServiceExtension/ # Notification service extension source
│   ├── MessageExtension/      # Message extension source
│   ├── SpotlightExtension/    # Spotlight extension source
│   ├── WidgetExtension/       # Widget extension source
│   ├── WatchApp/              # Watch app source
│   ├── WatchExtension/        # Watch extension source
│   ├── Resources/             # Assets, localizations, Info.plist strings
│   └── Configs/               # Build configuration files
├── project.yml                # XcodeGen project configuration
└── Package.swift              # Swift Package Manager manifest
```

### Package Benefits

- **Clean Separation**: Swift packages in `Sources/`, Xcode project files in `XcodeTemplate/`
- **Modularity**: Business logic (Core) separate from UI components (UI)
- **Reusability**: Swift packages can be used across multiple projects
- **Testing**: Isolated testing for Core logic and UI components with `swift test`
- **Performance**: Faster incremental builds with minimal dependencies
- **Team Development**: Backend teams work on Core, UI teams work on UI
- **External Distribution**: Clean API surface for sharing packages with other developers

### Sources/ Directory (Swift Packages Only)

**Core Package** - Business logic and data management:
- Shared utilities and models with @Observable
- Networking with async/await
- SwiftData persistence
- AlarmKit, App Intents, Foundation Models, Vision framework wrappers
- Extension utilities

**UI Package** - SwiftUI components and design system:
- Depends on Core package
- Liquid Glass design system components
- Platform-specific SwiftUI views
- Widget and Watch UI components
- Accessibility-first design

### XcodeTemplate/ Directory (Xcode Project Files)

Contains all Xcode-specific project files that get customized per project:
- App targets (main app, extensions, watch)
- Info.plist files
- Entitlements files
- Build configuration files
- Project-specific source code

## Testing

Run tests using:
```bash
# All app tests
xcodebuild test -scheme YourProjectName -destination 'platform=iOS Simulator,name=iPhone 15'

# Package tests
swift test

# Specific package tests
swift test --filter CoreTests
swift test --filter UITests
```

## Build and Archive

```bash
# Build for simulator
xcodebuild -scheme YourProjectName -destination 'platform=iOS Simulator,name=iPhone 15'

# Archive for distribution
xcodebuild archive -scheme YourProjectName -archivePath ./build/YourProjectName.xcarchive
```

## Common Issues

1. **XcodeGen not found**: Install via `brew install xcodegen`
2. **Build errors**: Ensure all deployment targets match your requirements
3. **Signing issues**: Configure your development team in `project.yml`

## Next Steps

After project creation:
1. Configure your development team and signing
2. Set up your app's core functionality
3. Add app-specific assets and resources
4. Configure any additional dependencies
5. Set up CI/CD if needed