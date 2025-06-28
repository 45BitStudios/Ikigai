//
//  AppDelegate.swift
//  Demo
//
//  Created by Vince Davis on 4/7/24.
//

import SwiftUI
import UserNotifications

#if os(iOS) || os(visionOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

// MARK: - Protocol Definitions

/// A protocol that converts a system shortcut item into a custom type,
/// and provides all the shortcut items for the application.
public protocol ShortcutProvider {
    #if os(iOS)
    static func from(shortcutItem: UIApplicationShortcutItem) -> Self?
    static func allShortcutItems() -> [UIApplicationShortcutItem]
    #endif
}

/// A protocol that converts an NSUserActivity into a custom type,
/// and provides the supported NSUserActivity types.
public protocol HandoffProvider {
    static func from(userActivity: NSUserActivity) -> Self?
    static func supportedActivityTypes() -> Set<String>
}

/// A protocol that converts a URL into a custom deep link type.
public protocol DeeplinkProvider {
    static func from(url: URL) -> Self?
}

/// A protocol that converts a UNNotificationResponse into a custom push notification type,
/// and provides a set of notification categories to register with UNUserNotificationCenter.
public protocol PushNotificationProvider {
    #if !os(tvOS)
    static func from(notificationResponse: UNNotificationResponse) -> Self?
    static func notificationCategories() -> Set<UNNotificationCategory>
    #endif
    static func requestPermission() async -> (granted: Bool, error: Error?)
}

public extension PushNotificationProvider {
    static func requestPermission() async -> (granted: Bool, error: Error?) {
        await withCheckedContinuation { continuation in
            let center = UNUserNotificationCenter.current()
            center.setNotificationCategories(Self.notificationCategories())
            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                continuation.resume(returning: (granted, error))
            }
        }
    }
}

// MARK: - Notification Name Extensions

public extension Notification.Name {
    static let didReceiveShortcut = Notification.Name("didReceiveShortcut")
    static let didReceiveNotificationResponse = Notification.Name("didReceiveNotificationResponse")
    static let didReceiveDeepLink = Notification.Name("didReceiveDeepLink")
    static let didReceiveUserActivity = Notification.Name("didReceiveUserActivity")
}

// MARK: - Generic AppStateManager

/// A generic state manager that handles shortcuts, deep links, and push notifications.
@Observable
public class AppStateManager<Shortcut, DeepLink, PushNotification, Handoff>
where Shortcut: ShortcutProvider,
      DeepLink: DeeplinkProvider,
      PushNotification: PushNotificationProvider,
      Handoff: HandoffProvider {
    
    public var selectedShortcut: Shortcut?
    public var deepLink: DeepLink?
    public var pushNotification: PushNotification?
    public var userActivity: Handoff?
    
    public init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleShortcutNotification(_:)),
                                               name: .didReceiveShortcut,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleDeepLinkNotification(_:)),
                                               name: .didReceiveDeepLink,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotificationResponse(_:)),
                                               name: .didReceiveNotificationResponse,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleUserActivity(_:)),
                                               name: .didReceiveUserActivity,
                                               object: nil)
    }
    
    @objc private func handleShortcutNotification(_ notification: Notification) {
        guard let item = notification.object as? UIApplicationShortcutItem else { return }
        #if os(iOS)
        selectedShortcut = Shortcut.from(shortcutItem: item)
        #endif
    }
    
    @objc private func handleDeepLinkNotification(_ notification: Notification) {
        guard let url = notification.object as? URL else { return }
        deepLink = DeepLink.from(url: url)
    }
    
    @objc private func handleNotificationResponse(_ notification: Notification) {
        guard let response = notification.object as? UNNotificationResponse else { return }
        #if !os(tvOS)
        pushNotification = PushNotification.from(notificationResponse: response)
        #endif
    }
    
    @objc private func handleUserActivity(_ notification: Notification) {
        guard let activity = notification.object as? NSUserActivity else { return }
        self.userActivity = Handoff.from(userActivity: activity)
    }
}

// MARK: - Generic AppEventsDelegate

#if os(iOS) || os(visionOS)
public class AppDelegate<PushNotification: PushNotificationProvider, Shortcut: ShortcutProvider>: NSObject, UIApplicationDelegate, @preconcurrency UNUserNotificationCenterDelegate {
    
    public override init() {
        super.init()
    }
    
    public func application(_ application: UIApplication,
                            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        // Register push notification categories.
        
        
        // Set the app's shortcut items.
        #if os(iOS)
        UIApplication.shared.shortcutItems = Shortcut.allShortcutItems()
        
        if let shortcutItem = launchOptions?[.shortcutItem] as? UIApplicationShortcutItem {
            NotificationCenter.default.post(name: .didReceiveShortcut, object: shortcutItem)
            return false
        }
        #endif
        
        if let url = launchOptions?[.url] as? URL {
            NotificationCenter.default.post(name: .didReceiveDeepLink, object: url)
        }
        
        return true
    }
    
    #if os(iOS)
    public func application(_ application: UIApplication,
                            performActionFor shortcutItem: UIApplicationShortcutItem,
                            completionHandler: @escaping (Bool) -> Void) {
        NotificationCenter.default.post(name: .didReceiveShortcut, object: shortcutItem)
        completionHandler(true)
    }
    
    public func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        if let shortcutItem = options.shortcutItem {
            print("App delegate quick action")
            NotificationCenter.default.post(name: .didReceiveShortcut, object: shortcutItem)
        }
        
        let sceneConfiguration = UISceneConfiguration(name: "Custom Configuration", sessionRole: connectingSceneSession.role)
        sceneConfiguration.delegateClass = SceneDelegate.self

        return sceneConfiguration
    }
    #endif
    
    public func application(_ application: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Registered for remote notifications with token: \(deviceToken)")
    }
    
    public func application(_ application: UIApplication,
                            didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error)")
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
        NotificationCenter.default.post(name: .didReceiveNotificationResponse, object: response)
        completionHandler()
    }
    
    public func application(_ app: UIApplication,
                            open url: URL,
                            options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        NotificationCenter.default.post(name: .didReceiveDeepLink, object: url)
        return true
    }
    
    public func application(_ application: UIApplication,
                            continue userActivity: NSUserActivity,
                            restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // Post notification so that the state manager can update.
        NotificationCenter.default.post(name: .didReceiveUserActivity, object: userActivity)
        return true
    }
}
#elseif os(macOS)
public class AppDelegate<PushNotification: PushNotificationProvider, Shortcut: ShortcutProvider>: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate {
    
    public override init() {
        super.init()
    }
    
    public func applicationDidFinishLaunching(_ notification: Notification) {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        // Register push notification categories.
        center.setNotificationCategories(PushNotification.notificationCategories())
        
        // macOS doesn't use remote notifications in the same way,
        // but you can perform any additional setup here.
        
        // For deep links, NSApplicationDelegate has its own open URL method.
    }
    
    public func application(_ sender: NSApplication, open urls: [URL]) {
        for url in urls {
            NotificationCenter.default.post(name: .didReceiveDeepLink, object: url)
        }
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
        NotificationCenter.default.post(name: .didReceiveNotificationResponse, object: response)
        completionHandler()
    }
    
    public func application(_ application: NSApplication,
                            continue userActivity: NSUserActivity,
                            restorationHandler: @escaping ([NSUserActivityRestoring]?) -> Void) -> Bool {
        NotificationCenter.default.post(name: .didReceiveUserActivity, object: userActivity)
        return true
    }
}
#endif

// MARK: - SwiftUI View Modifiers

extension View {
    /// Modifier for listening to shortcut events.
    public func onShortcut<Shortcut: ShortcutProvider>(
        perform action: @escaping (Shortcut) -> Void
    ) -> some View {
        self.onReceive(NotificationCenter.default.publisher(for: .didReceiveShortcut)) { notification in
            if let shortcutItem = notification.object as? UIApplicationShortcutItem,
               let event = Shortcut.from(shortcutItem: shortcutItem) {
                action(event)
            }
        }
    }
    
    /// Modifier for listening to deep link events.
    public func onDeepLink<DeepLink: DeeplinkProvider>(
        perform action: @escaping (DeepLink) -> Void
    ) -> some View {
        self.onReceive(NotificationCenter.default.publisher(for: .didReceiveDeepLink)) { notification in
            if let url = notification.object as? URL,
               let event = DeepLink.from(url: url) {
                action(event)
            }
        }
    }
    
    /// Modifier for listening to push notification events.
    public func onPushNotification<PushNotification: PushNotificationProvider>(
        perform action: @escaping (PushNotification) -> Void
    ) -> some View {
        self.onReceive(NotificationCenter.default.publisher(for: .didReceiveNotificationResponse)) { notification in
            if let response = notification.object as? UNNotificationResponse,
               let event = PushNotification.from(notificationResponse: response) {
                action(event)
            }
        }
    }
    
    /// A SwiftUI view modifier that listens for NSUserActivity (handoff) events using the native
    /// `onContinueUserActivity` modifier, converts the activity into your custom type (conforming to `UserActivityProvider`),
    /// and invokes the provided closure.
    ///
    /// - Parameters:
    ///   - activityType: The NSUserActivity type to listen for.
    ///   - action: A closure that receives your custom user activity type.
    /// - Returns: A view modified to continue the specified user activity.
    public func onHandoff<Handoff: HandoffProvider>(
        _ activityType: String,
        perform action: @escaping (Handoff) -> Void
    ) -> some View {
        self.onContinueUserActivity(activityType, perform: { userActivity in
            if let event = Handoff.from(userActivity: userActivity) {
                action(event)
            }
        })
    }
}

#if os(iOS)
import UIKit
public class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    @Environment(\.openURL) var openURL
    
    public func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        NotificationCenter.default.post(name: .didReceiveShortcut, object: shortcutItem)
        print("scene delegate with item \(shortcutItem.type)")
    }
}
#endif
