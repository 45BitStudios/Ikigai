//
//  LiveActivityPushType.swift
//  IkigaiAPI
//
//  Created by Vince Davis on 2/26/25.
//


import Foundation
#if canImport(ActivityKit)
import ActivityKit
#endif

#if os(iOS)
// MARK: - Custom Live Activity Errors

/// Errors that can occur during live activity operations.
public enum LiveActivityError: Error {
    /// The device or attributes are not eligible to start a live activity.
    case notEligible
    /// The maximum number of allowed live activities has been reached.
    case maxActivitiesReached
    /// An error occurred while retrieving the push token.
    case pushTokenRetrievalFailed
    /// The live activity request failed with an underlying error.
    case activityRequestFailed(Error)
    /// No live activity was found with the specified identifier.
    case activityNotFound
    
    
    public var errorDescription: String {
        switch self {
        case .notEligible:
            return NSLocalizedString("This activity is not eligible to start.", comment: "")
        case .maxActivitiesReached:
            return NSLocalizedString("You've reached the maximum number of allowed live activities.", comment: "")
        case .pushTokenRetrievalFailed:
            return NSLocalizedString("Unable to retrieve the push token.", comment: "")
        case .activityRequestFailed(let error):
            return String(format: NSLocalizedString("The live activity request failed: %@", comment: ""), error.localizedDescription)
        case .activityNotFound:
            return NSLocalizedString("The requested live activity could not be found.", comment: "")
        }
    }
}

// MARK: - Example ActivityAttributes Conforming Type

/// An example of a custom type conforming to `ActivityAttributes`.
public struct MyActivityAttributes: ActivityAttributes {
    /// The content state for the live activity.
    public struct ContentState: Codable, Hashable {
        public var progress: Double
        public var detail: String
        
        public init(progress: Double, detail: String) {
            self.progress = progress
            self.detail = detail
        }
    }
    
    public var title: String
    
    public init(title: String) {
        self.title = title
    }
}

// MARK: - LiveActivityManager

/// A generic, public live activity manager that supports multiple activities,
/// custom eligibility logic, push type configuration, alert updates, stale dates, limits,
/// and listening for push token, push-to-start token, and status updates.
public class LiveActivityManager<T: ActivityAttributes> where T.ContentState: Codable & Hashable {
    
    public private(set) var activities: [String: Activity<T>] = [:]
    
    private let eligibilityCheck: ((T) -> Bool)?
    private let maxActivities: Int?
    
    /// Initializes the live activity manager with an optional eligibility check and an optional maximum limit.
    ///
    /// - Parameters:
    ///   - eligibilityCheck: A closure that takes an instance of your activity attributes and returns a Boolean value indicating whether the activity is eligible to start.
    ///     - Example:
    ///       ```swift
    ///       // Define an eligibility check for MyActivityAttributes.
    ///       let eligibilityCheck: (MyActivityAttributes) -> Bool = { attributes in
    ///           // Ensure the title isn't empty and that live activities are enabled on the device.
    ///           guard !attributes.title.isEmpty else { return false }
    ///           return ActivityAuthorizationInfo().areActivitiesEnabled
    ///       }
    ///
    ///       // Initialize the manager with the custom eligibility check and a maximum of 3 activities.
    ///       let liveActivityManager = LiveActivityManager<MyActivityAttributes>(
    ///           eligibilityCheck: eligibilityCheck,
    ///           maxActivities: 3
    ///       )
    ///       ```
    ///   - maxActivities: An optional integer specifying the maximum number of live activities allowed.
    ///
    public init(eligibilityCheck: ((T) -> Bool)? = nil, maxActivities: Int? = nil) {
        self.eligibilityCheck = eligibilityCheck
        self.maxActivities = maxActivities
    }
    
    /// Checks if the device and provided attributes are eligible for live activities.
    /// - Parameter attributes: The live activity attributes.
    /// - Returns: `true` if eligible, `false` otherwise.
    /// - Example:
    /// ```swift
    /// let eligible = liveActivityManager.isEligible(for: MyActivityAttributes(title: "Test"))
    /// print("Is eligible? \(eligible)")
    /// ```
    public func isEligible(for attributes: T) -> Bool {
        guard #available(iOS 16.1, *) else { return false }
        if let check = eligibilityCheck {
            return check(attributes)
        }
        return ActivityAuthorizationInfo().areActivitiesEnabled
    }
    
    /// Starts a new live activity.
    ///
    /// - Parameters:
    ///   - attributes: The activity attributes.
    ///   - initialContentState: The initial state of the activity.
    ///   - staleDate: An optional date when the content is considered stale.
    ///   - pushType: An optional push type (pass `nil` or `.token`).
    /// - Returns: The started `Activity` instance.
    /// - Throws: A `LiveActivityError` if the activity is not eligible, the limit is reached, or the request fails.
    /// - Example:
    /// ```swift
    /// let activity = try await liveActivityManager.startActivity(
    ///     attributes: MyActivityAttributes(title: "Example Activity"),
    ///     initialContentState: MyActivityAttributes.ContentState(progress: 0.0, detail: "Starting..."),
    ///     staleDate: Date().addingTimeInterval(60),
    ///     pushType: .token
    /// )
    /// print("Started activity with id: \(activity.id)")
    /// ```
    @discardableResult
    public func startActivity(attributes: T,
                              initialContentState: T.ContentState,
                              staleDate: Date? = nil,
                              pushType: PushType) async throws -> Activity<T> {
        guard isEligible(for: attributes) else {
            throw LiveActivityError.notEligible
        }
        
        if let max = maxActivities, activities.count >= max {
            throw LiveActivityError.maxActivitiesReached
        }
        
        do {
            let activity = try Activity<T>.request(
                attributes: attributes,
                content:  .init(
                    state: initialContentState,
                    staleDate: staleDate
                ),
                pushType: .token
            )
            activities[activity.id] = activity
            return activity
        } catch {
            throw LiveActivityError.activityRequestFailed(error)
        }
    }
    
    /// Updates a specific live activity.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the activity.
    ///   - newContentState: The new content state for the activity.
    ///   - staleDate: An optional new stale date.
    ///   - alertConfiguration: An optional alert configuration.
    /// - Example:
    /// ```swift
    /// await liveActivityManager.updateActivity(
    ///     id: activity.id,
    ///     newContentState: MyActivityAttributes.ContentState(progress: 0.5, detail: "Halfway there!"),
    ///     staleDate: Date().addingTimeInterval(120)
    /// )
    /// print("Updated activity \(activity.id)")
    /// ```
    public func updateActivity(id: String,
                               newContentState: T.ContentState,
                               staleDate: Date? = nil,
                               alertConfiguration: AlertConfiguration? = nil) async {
        guard let activity = activities[id] else {
            print("No active live activity found with id: \(id)")
            return
        }
        
        let content = ActivityContent(state: newContentState, staleDate: staleDate)
        if let alertConfig = alertConfiguration {
            //await activity.update(content, alertConfiguration: alertConfig)
        } else {
            await activity.update(content)
        }
    }
    
    /// Stops a specific live activity.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the activity.
    ///   - dismissalPolicy: The dismissal policy (defaults to `.immediate`).
    /// - Example:
    /// ```swift
    /// await liveActivityManager.stopActivity(id: activity.id)
    /// print("Stopped activity \(activity.id)")
    /// ```
    public func stopActivity(id: String,
                             dismissalPolicy: ActivityUIDismissalPolicy = .immediate) async {
        guard let activity = activities[id] else {
            print("No active live activity found with id: \(id)")
            return
        }
        await activity.end(dismissalPolicy: dismissalPolicy)
        activities.removeValue(forKey: id)
    }
    
    /// Ends all active live activities.
    ///
    /// - Parameter dismissalPolicy: The dismissal policy for ending the activities.
    /// - Example:
    /// ```swift
    /// await liveActivityManager.endAllActivities()
    /// print("Ended all activities")
    /// ```
    public func endAllActivities(dismissalPolicy: ActivityUIDismissalPolicy = .immediate) async {
        for (id, activity) in activities {
            await activity.end(dismissalPolicy: dismissalPolicy)
            print("Ended activity with id: \(id)")
        }
        activities.removeAll()
    }
    
    /// Retrieves a live activity by its unique identifier.
    ///
    /// - Parameter id: The unique identifier of the activity.
    /// - Returns: The live activity if found, otherwise `nil`.
    /// - Example:
    /// ```swift
    /// if let retrievedActivity = liveActivityManager.getLiveActivity(id: activity.id) {
    ///     print("Retrieved activity with id: \(retrievedActivity.id)")
    /// }
    /// ```
    public func getLiveActivity(id: String) -> Activity<T>? {
        return activities[id]
    }
    
    /// Returns a list of all currently active activity IDs.
    ///
    /// - Returns: An array of activity IDs.
    /// - Example:
    /// ```swift
    /// let activeIDs = liveActivityManager.activeActivityIDs()
    /// print("Active activity IDs: \(activeIDs)")
    /// ```
    public func activeActivityIDs() -> [String] {
        return Array(activities.keys)
    }
    
    /// Retrieves the push token for a given live activity.
    ///
    /// - Parameter id: The unique identifier of the activity.
    /// - Returns: The push token as `Data` if available.
    /// - Throws: `LiveActivityError.activityNotFound` if no activity exists with the provided ID.
    /// - Example:
    /// ```swift
    /// if let pushToken = try await liveActivityManager.getPushToken(for: activity.id) {
    ///     let tokenString = pushToken.reduce("") { $0 + String(format: "%02x", $1) }
    ///     print("Initial push token for activity \(activity.id): \(tokenString)")
    /// }
    /// ```
    public func getPushToken(for id: String) async throws -> Data? {
        guard let activity = activities[id] else {
            throw LiveActivityError.activityNotFound
        }
        return try await activity.pushToken
    }
    
    /// Listens for push token updates on a specific live activity.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the activity.
    ///   - tokenHandler: A closure that is called each time a new push token is received.
    /// - Throws: `LiveActivityError.activityNotFound` if no activity exists with the provided ID.
    /// - Example:
    /// ```swift
    /// try liveActivityManager.listenForPushTokenUpdates(id: activity.id) { tokenData in
    ///     let tokenString = tokenData.reduce("") { $0 + String(format: "%02x", $1) }
    ///     print("Push token update for activity \(activity.id): \(tokenString)")
    /// }
    /// ```
//    public func listenForPushTokenUpdates(for activity: Activity<T>,
//                                          tokenHandler: @MainActor @escaping (String) -> Void) {
//        Task { @MainActor in
//            for await token in activity.pushTokenUpdates {
//                let tokenString = token.reduce("") { $0 + String(format: "%02x", $1) }
//                tokenHandler(tokenString)
//            }
//        }
//    }
    
    /// Listens for push-to-start token updates.
    ///
    /// ActivityKit provides a static asynchronous sequence `Activity<T>.pushToStartTokenUpdates`
    /// that emits push-to-start token changes. This method calls the provided handler with each new token.
    ///
    /// - Parameter tokenHandler: A closure that is called each time a new push-to-start token is received.
    /// - Example:
    /// ```swift
    /// liveActivityManager.listenForPushToStartTokenUpdates { tokenData in
    ///     let tokenString = tokenData.reduce("") { $0 + String(format: "%02x", $1) }
    ///     print("Received push-to-start token update: \(tokenString)")
    /// }
    /// ```
    public func listenForPushToStartTokenUpdates(tokenHandler: @MainActor @escaping (String) -> Void) {
        Task { @MainActor in
            for await token in Activity<T>.pushToStartTokenUpdates {
                let tokenString = token.reduce("") { $0 + String(format: "%02x", $1) }
                tokenHandler(tokenString)
            }
        }
    }
    
    /// Listens for status updates for a specific live activity.
    ///
    /// This method filters the static asynchronous sequence `Activity<T>.activityUpdates`
    /// for events related to the activity with the specified identifier.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the live activity.
    ///   - statusHandler: A closure that is called with each status update.
    /// - Example:
    /// ```swift
    /// liveActivityManager.listenForActivityStatusUpdates(id: activity.id) { update in
    ///     print("Status update for activity \(update.id): \(update)")
    /// }
    /// ```
    public func listenForActivityStatusUpdates(id: String,
                                               statusHandler: @MainActor @escaping (Activity<T>) -> Void) {
        Task { @MainActor in
            for await update in Activity<T>.activityUpdates {
                if update.id == id {
                    statusHandler(update)
                }
            }
        }
    }
}
#endif
