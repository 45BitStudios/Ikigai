# AI Agents Memory for Ikigai Project

This file contains important context and memories for AI agents (Claude, Gemini, GPT, etc.) when working on the Ikigai multi-platform SwiftUI application. This helps maintain consistency and understanding across sessions and different AI assistants.

**Current Path**: `/Users/vince/Dev/Studio45/Ikigai/`
**Repository**: https://github.com/45BitStudios/Ikigai

## Project Overview

Ikigai is a comprehensive SwiftUI application that provides a complete foundation for modern iOS, macOS, watchOS, tvOS, and visionOS app development using Swift 6.2 and advanced routing capabilities.

### Key Technologies
- **Swift 6.2** with full concurrency support
- **SwiftUI only** (no UIKit or Storyboards)
- **XcodeGen** for project generation
- **Swift Package Manager** for modular architecture
- **App Intents** with Swift package integration
- **String Catalogs** (.xcstrings) for localization
- **Apple Style Documentation** throughout

## Project Architecture

### Swift Package Structure
```
Sources/
├── IkigaiCore/              # Business logic, router system, networking
│   ├── Router/              # Advanced SwiftUI Router system
│   │   ├── Router.swift     # Core router implementation
│   │   ├── Route.swift      # Route definitions and deep linking
│   │   ├── NavigationManager.swift  # Enhanced navigation manager
│   │   ├── RouterExtensions.swift   # SwiftUI integration
│   │   └── RouterPlatformSupport.swift  # Multi-platform support
│   ├── Networking/          # Network services
│   ├── Extensions/          # Utility extensions
│   └── Helpers/             # Helper utilities
├── IkigaiUI/                # SwiftUI components and design system
├── IkigaiAI/                # AI and ML integrations
└── IkigaiMacros/            # Swift macros for code generation
```

### Main App Structure
```
Ikigai/
├── IkigaiApp/               # Main app target
│   ├── IkigaiApp.swift
│   ├── ContentView.swift
│   └── RouterDemoViews.swift  # Router demonstration views
├── WatchApp/                # watchOS companion app
├── Resources/               # Assets, color assets for App Shortcuts
└── [Various Extensions]/    # Action, Share, Notification, Widget, etc.
```

## Critical Implementation Details

### App Extensions Configuration

#### NSExtensionActivationRule Setup
**Share Extension (ShareExtension/Info.plist:27-36):**
```xml
<key>NSExtensionActivationRule</key>
<dict>
    <key>NSExtensionActivationDictionaryVersion</key>
    <integer>2</integer>
    <key>NSExtensionActivationSupportsAttachmentsWithMaxCount</key>
    <integer>1</integer>
    <key>NSExtensionActivationSupportsImageWithMaxCount</key>
    <integer>1</integer>
</dict>
```

**Action Extension (ActionExtension/Info.plist:27-36):**
```xml
<key>NSExtensionActivationRule</key>
<dict>
    <key>NSExtensionActivationDictionaryVersion</key>
    <integer>2</integer>
    <key>NSExtensionActivationSupportsAttachmentsWithMaxCount</key>
    <integer>1</integer>
    <key>NSExtensionActivationSupportsImageWithMaxCount</key>
    <integer>1</integer>
</dict>
```

#### NSExtensionActivationRule Examples by Content Type

**Images Only:**
```xml
<key>NSExtensionActivationRule</key>
<dict>
    <key>NSExtensionActivationDictionaryVersion</key>
    <integer>2</integer>
    <key>NSExtensionActivationSupportsImageWithMaxCount</key>
    <integer>5</integer>
</dict>
```

**PDFs and Documents:**
```xml
<key>NSExtensionActivationRule</key>
<dict>
    <key>NSExtensionActivationDictionaryVersion</key>
    <integer>2</integer>
    <key>NSExtensionActivationSupportsFileWithMaxCount</key>
    <integer>1</integer>
    <key>NSExtensionActivationSupportsAttachmentsWithMaxCount</key>
    <integer>1</integer>
</dict>
```

**Text Content:**
```xml
<key>NSExtensionActivationRule</key>
<dict>
    <key>NSExtensionActivationDictionaryVersion</key>
    <integer>2</integer>
    <key>NSExtensionActivationSupportsText</key>
    <true/>
</dict>
```

**URLs and Web Content:**
```xml
<key>NSExtensionActivationRule</key>
<dict>
    <key>NSExtensionActivationDictionaryVersion</key>
    <integer>2</integer>
    <key>NSExtensionActivationSupportsWebURLWithMaxCount</key>
    <integer>1</integer>
    <key>NSExtensionActivationSupportsWebPageWithMaxCount</key>
    <integer>1</integer>
</dict>
```

**Video Content:**
```xml
<key>NSExtensionActivationRule</key>
<dict>
    <key>NSExtensionActivationDictionaryVersion</key>
    <integer>2</integer>
    <key>NSExtensionActivationSupportsMovieWithMaxCount</key>
    <integer>1</integer>
</dict>
```

**Multiple Content Types:**
```xml
<key>NSExtensionActivationRule</key>
<dict>
    <key>NSExtensionActivationDictionaryVersion</key>
    <integer>2</integer>
    <key>NSExtensionActivationSupportsImageWithMaxCount</key>
    <integer>3</integer>
    <key>NSExtensionActivationSupportsText</key>
    <true/>
    <key>NSExtensionActivationSupportsWebURLWithMaxCount</key>
    <integer>1</integer>
    <key>NSExtensionActivationSupportsAttachmentsWithMaxCount</key>
    <integer>5</integer>
</dict>
```

**Custom Predicate Rules (Advanced):**
```xml
<key>NSExtensionActivationRule</key>
<string>SUBQUERY (
    extensionItems,
    $extensionItem,
    SUBQUERY (
        $extensionItem.attachments,
        $attachment,
        ANY $attachment.registeredTypeIdentifiers UTI-CONFORMS-TO "com.adobe.pdf"
    ).@count >= 1
).@count >= 1</string>
```

#### Common Activation Rule Keys
- `NSExtensionActivationSupportsAttachmentsWithMaxCount`: Any attachment type
- `NSExtensionActivationSupportsImageWithMaxCount`: Image files
- `NSExtensionActivationSupportsMovieWithMaxCount`: Video files  
- `NSExtensionActivationSupportsFileWithMaxCount`: File attachments
- `NSExtensionActivationSupportsText`: Text content
- `NSExtensionActivationSupportsWebURLWithMaxCount`: Web URLs
- `NSExtensionActivationSupportsWebPageWithMaxCount`: Web pages

#### Best Practices
1. **Use Dictionary Version 2**: Always include `NSExtensionActivationDictionaryVersion` set to 2
2. **Set Reasonable Limits**: Don't set MaxCount too high to avoid performance issues
3. **Be Specific**: Only activate for content types your extension can handle
4. **Test Thoroughly**: Test activation rules across different apps and content types
5. **Consider UX**: Extensions should only appear when they add value to the user's workflow

### App Intents Swift Package Integration
**Pattern Established:**
1. **Package Declaration**: `MyFrameworkPackage: AppIntentsPackage` in Core
2. **Main App Registration**: `MyAppShortcutsProvider: AppShortcutsProvider, @MainActor AppIntentsPackage`
3. **Concurrency Safety**: `@MainActor static let includedPackages` for thread safety
4. **Package Registration**: Include `MyFrameworkPackage.self` in includedPackages array

### Localization Architecture
**Shared System Implemented:**
- **Single Source**: One .xcstrings file in Core package (`Sources/Core/Resources/Localizable.xcstrings`)
- **Clean API**: Extensions hide bundle complexity
  - `Text(localized: "key")` instead of bundle references
  - `.accessibilityLabel(localized: "key")`
  - `String.localized("key", arguments)` for interpolation
- **Package Integration**: Uses `CoreModule.bundle` for resource access

### App Shortcuts Color Integration
**Configured in Info.plist:**
```xml
<key>NSAppIconActionTintColorName</key>
<string>ShortcutsForeground</string>
<key>NSAppIconComplementingColorNames</key>
<array>
    <string>ShortcutsBackground1</string>
    <string>ShortcutsBackground2</string>
</array>
```

**Color Assets Created:**
- ShortcutsForeground (white tint)
- ShortcutsBackground1 (orange-blue gradient with dark mode)
- ShortcutsBackground2 (complementary orange with dark mode)

## Build Configuration

### Package Management
**Current Setup:**
- **Local Development**: `path: .` in project.yml for testing
- **Remote Option**: Commented GitHub URL for production use
- **Comment Available**: Switch back to remote with provided URL

### Platform Support
- **Deployment Targets**: iOS 26.0+, macOS 26.0+, watchOS 26.0+, tvOS 26.0+, visionOS 26.0+
- **Multi-platform**: Single codebase with platform-specific conditional compilation
- **Watch Compatibility**: Fixed platform issues with `#if !os(tvOS) && !os(watchOS)`

## Documentation Standards

### Apple Style Documentation Required
**All code must have:**
- `///` documentation comments for public APIs
- Parameter descriptions with `- Parameters:`
- Return value descriptions with `- Returns:`
- Error conditions with `- Throws:`
- `// MARK:` comments for organization

### Code Quality Standards
- **Swift 6.2 Concurrency**: All async operations use async/await
- **@Observable**: Used instead of ObservableObject
- **Thread Safety**: @MainActor for UI and App Intents
- **Accessibility**: All UI elements have proper accessibility labels
- **Localization**: No hardcoded user-facing strings

## Recent Problem Solutions

### Build Issues Resolved
1. **Localization Type Errors**: Fixed with `String.LocalizationValue()` wrappers
2. **App Intent Concurrency**: Fixed with `static let` instead of `var`
3. **Package Discovery**: Implemented proper AppIntentsPackage pattern
4. **Platform Compatibility**: Added proper conditional compilation for watchOS
5. **Swift 6.2 Concurrency Issues**: Comprehensive fixes for NotificationService and AppDelegate
6. **Push Notification Integration**: Complete APNs infrastructure with background modes

### Swift 6.2 Concurrency Fixes Applied
**NotificationService.swift:**
- Added `@MainActor` annotation to NotificationService class for thread safety
- BackgroundTaskManager marked with `@unchecked Sendable` conformance
- Individual methods marked with `@MainActor` where UIApplication.shared is accessed
- Fixed `executeBackgroundTask` to use `@Sendable` closure parameter
- Removed deprecated `.timeSensitive` notification option
- Added proper Sendable conformance to NotificationServiceDelegate protocol

**YourProjectNameApp.swift:**
- Added `@MainActor` annotation to AppDelegate class
- Used `@preconcurrency` for UNUserNotificationCenterDelegate conformance
- Used `@preconcurrency` for NotificationServiceDelegate extension
- Fixed background fetch completion handler to avoid capturing non-Sendable types
- Added automatic push notification permission request on app launch

### Push Notification Infrastructure Implemented
**Complete APNs Integration:**
- NotificationService with comprehensive push notification management
- Background task management for proper lifecycle handling
- Interactive notification categories (reply, mark read actions)
- Device token registration and server communication patterns
- Silent notifications and content-available background processing
- Local notification scheduling for testing
- Proper error handling and delegate patterns

**Entitlements and Configuration:**
- Updated main app entitlements with push notification capabilities
- Added background modes: remote-notification, background-fetch, background-processing
- Created NotificationServiceExtension entitlements file
- Updated Info.plist with background modes and usage descriptions

**Usage Patterns Established:**
```swift
// Request permissions (automatically done in AppDelegate)
let granted = try await NotificationService.shared.requestAuthorization()

// Schedule local notification
await NotificationService.shared.scheduleLocalNotification(
    title: "Test", body: "Message", timeInterval: 5
)

// Handle background tasks
BackgroundTaskManager.shared.executeBackgroundTask {
    // Background work
}
```

### Architecture Decisions Made
1. **Package vs App Target**: App Intents in package, AppShortcutsProvider in main app
2. **Concurrency Pattern**: @MainActor for App Intents package registration
3. **Localization Strategy**: Single shared .xcstrings file in Core package
4. **Documentation Approach**: Comprehensive Apple Style comments throughout
5. **Push Notification Strategy**: NotificationService in Core package for reusability
6. **Concurrency Safety**: @MainActor and @preconcurrency for legacy protocol conformance

## Multi-Platform Compatibility

### Platform Support Matrix
This template supports all Apple platforms with proper feature degradation:

| Platform | Deployment Target | Core Features | Platform-Specific Features |
|----------|------------------|---------------|---------------------------|
| **iOS** | 26.0+ | ✅ Full support | Push notifications, Live Activities, App Clips, Extensions |
| **macOS** | 26.0+ | ✅ Full support | Push notifications, Extensions (Action, Share, Widget, etc.) |
| **watchOS** | 26.0+ | ✅ Core features | Limited to Core package + UI components |
| **tvOS** | 26.0+ | ✅ Core features | Limited to Core package + UI components |
| **visionOS** | 26.0+ | ✅ Core features | Core package + UI components |

### Platform-Specific Conditional Compilation Patterns

#### Critical Patterns to Follow

**1. UIKit Dependencies**
```swift
#if canImport(UIKit) && !os(watchOS)
// UIKit-specific code (iOS, macOS, tvOS)
UIApplication.shared.registerForRemoteNotifications()
#else
// Fallback for platforms without UIKit
print("Feature not available on this platform")
#endif
```

**2. iOS-Specific Features (ActivityKit, App Clips, etc.)**
```swift
#if canImport(ActivityKit) && os(iOS)
@available(iOS 16.1, *)
// Live Activities code
#endif
```

**3. App Delegate Pattern**
```swift
#if canImport(UIKit) && !os(watchOS)
@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
#endif
```

**4. Background Tasks**
```swift
#if canImport(UIKit) && !os(watchOS)
let taskID = UIApplication.shared.beginBackgroundTask { }
#endif
```

### Platform Compatibility Rules

#### MUST Follow Patterns
1. **Always guard UIKit imports**: `#if canImport(UIKit)` for iOS/macOS/tvOS-specific code
2. **Exclude watchOS from UIKit**: Use `&& !os(watchOS)` for UIApplication dependencies
3. **Availability checks**: Use `@available(iOS X.X, *)` for version-specific features
4. **Graceful degradation**: Provide fallbacks or no-ops for unsupported platforms
5. **Import guards**: Wrap framework imports that aren't universal

#### Platform-Specific Import Patterns
```swift
import Foundation          // ✅ Universal
import SwiftUI            // ✅ Universal  
import UserNotifications  // ✅ Universal
#if canImport(UIKit)
import UIKit              // ✅ iOS, macOS, tvOS only
#endif
#if canImport(ActivityKit)
import ActivityKit        // ✅ iOS only
#endif
#if canImport(WatchKit)
import WatchKit           // ✅ watchOS only
#endif
```

### Build Validation

#### Multi-Platform Build Script
A comprehensive build validation script is provided: `./validate-platforms.sh`

**Usage:**
```bash
# Test all platforms
./validate-platforms.sh

# Quick iOS test
xcodebuild -scheme YourProjectName -destination 'platform=iOS Simulator,name=iPhone 16' build

# Quick watchOS test  
xcodebuild -scheme WatchApp -destination 'platform=watchOS Simulator,name=Apple Watch SE (40mm) (2nd generation)' build
```

#### Pre-Commit Validation
**ALWAYS run platform validation before committing:**
1. Run `./validate-platforms.sh` to test all platforms
2. Fix any platform-specific compilation errors
3. Ensure graceful feature degradation on all platforms
4. Test that shared packages work across platforms

### Platform-Specific Gotchas

#### watchOS Limitations
- **No UIKit**: Use SwiftUI-only approaches
- **No background tasks**: Background processing very limited
- **No push notifications**: Local notifications only
- **Memory constraints**: Keep data structures lightweight

#### tvOS Limitations  
- **No touch input**: Design for remote/keyboard input
- **No camera/photos**: Remove camera-dependent features
- **Focus-driven UI**: Ensure proper focus management
- **Limited background**: Minimal background processing

#### macOS Considerations
- **Window management**: Handle window lifecycle properly
- **Menu bar integration**: Consider menu bar apps
- **File system access**: Handle sandboxing correctly
- **Keyboard shortcuts**: Implement proper key handling

### Code Review Checklist

When adding new code, ensure:
- [ ] Platform guards around platform-specific APIs
- [ ] Imports are properly guarded
- [ ] Graceful degradation for unsupported features
- [ ] Build validation passes on all platforms
- [ ] Documentation updated for platform-specific behavior

## Development Workflow

### Commands to Remember
- **Project Generation**: `xcodegen generate`
- **Build Test**: `xcodebuild -scheme YourProjectName -destination 'platform=iOS Simulator,name=iPhone 16' build`
- **Watch Build**: `xcodebuild -scheme WatchApp -destination 'platform=watchOS Simulator,name=Apple Watch SE (40mm) (2nd generation)' build`

### Files That Change Together
- When adding App Intents: Update Core package + MyAppShortcutsProvider.includedPackages
- When adding localization: Update .xcstrings + consuming views
- When updating project structure: Run xcodegen generate

## Audio alert when tasks are complete
run afplay /System/Library/Sounds/Glass.aiff (or any other system sound) at the end of tasks, or when my input to proceed with a task.

## Important Notes

### Never Do
- Don't commit without user review (user explicitly requested this)
- Don't use UIKit unless specifically requested
- Don't use @ObservedObject/@StateObject (use @Observable instead)
- Don't hardcode user-facing strings (use localization)
- Don't write undocumented public APIs

### Always Do
- Use clean localization API extensions
- Follow Swift 6.2 concurrency patterns
- Maintain Apple Style documentation
- Test builds after significant changes
- Keep packages modular and focused

## Project Status

**Current State:**
- ✅ Builds successfully on iOS and watchOS with Swift 6.2 concurrency
- ✅ Complete shared localization system working
- ✅ App Intents Swift package integration functional
- ✅ App Shortcuts color customization configured
- ✅ Comprehensive push notification infrastructure implemented
- ✅ Swift 6.2 concurrency issues resolved throughout codebase
- ✅ Background modes and entitlements properly configured
- ✅ Automatic push notification permission request on app launch
- ✅ Interactive notifications with reply and action buttons
- ✅ Background task management for proper app lifecycle
- ✅ Comprehensive documentation in README.md and AI.md
- ✅ All targets properly configured with XcodeGen

- ✅ Multi-platform compatibility with proper conditional compilation
- ✅ Platform-specific feature degradation across iOS, macOS, watchOS, tvOS, visionOS
- ✅ Comprehensive platform validation script (validate-platforms.sh)
- ✅ Platform compatibility guidelines and patterns documented

**Ready for:**
- Adding new App Intents to packages
- Expanding localization to more languages
- Creating additional Swift packages
- Testing App Shortcuts functionality in Shortcuts app
- Server-side push notification integration
- Testing notification extensions with rich media content
- Adding Live Activities and Control Widgets (iOS 18+)
- Full multi-platform deployment and testing
