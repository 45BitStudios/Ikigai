//
//  ikigaiWidgetsAttributes 2.swift
//  Ikigai
//
//  Created by Vince Davis on 3/24/25.
//


import SwiftUI
import ActivityKit
import IkigaiCore

let startToken = "803df935050968f8ae828b3c416802a3ee25e035702304595d2dd96b7db9e70fb5e144d34dde8116f463a99b8dcf58e37d405d3ec49e29e6e155e26350d0323440295f12da4086e726829f46b685b5ee"
let channglId = "pNEPBwjlEfAAAE7ntXG+ng=="
let pushToken = "80e8d6d4464dcc0f29b25de30d0e379b4f801b85012b86c5ff53a0803cb6198ddc15db9ea591bbad853806e8b6642282520e8e43bcef7d459f5927525984f2bf5f16998b64549687544364fb55e1ed4d"

/// A SwiftUI view to test Live Activities using the LiveActivityManager
@MainActor
struct LiveActivitiesTestView: View {
    // User inputs for testing
    @State private var activityName: String = "Test Activity"
    @State private var emoji: String = "😀"

    // Instance of the live activity manager for ikigaiWidgetsAttributes
    @State private var liveActivityManager = LiveActivityManager<ikigaiWidgetsAttributes>()
    
    // Track the current activity's id, list of active IDs, and push token
    @State private var currentActivityId: String? = nil
    @State private var activeIDs: [String] = []
    @State private var pushToken: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Input fields for activity name and emoji
                TextField("Activity Name", text: $activityName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                TextField("Emoji", text: $emoji)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                // Button to start a new live activity
                Button("Start Activity") {
                    Task {
//                        do {
//                            let attributes = ikigaiWidgetsAttributes(name: activityName)
//                            let contentState = ikigaiWidgetsAttributes.ContentState(emoji: emoji)
//                            
//                            // Start the activity with a stale date 60 seconds in the future and pushType set to .token
//                            let activity = try await liveActivityManager.startActivity(
//                                attributes: attributes,
//                                initialContentState: contentState,
//                                staleDate: nil,
//                                pushType: .channel(channglId)
//                            )
//                            let tokenString = activity.pushToken?.reduce("") { $0 + String(format: "%02x", $1) }
//                            print("Initial push token for activity \(activity.id): \(tokenString)")
//                            currentActivityId = activity.id
//                            activeIDs = liveActivityManager.activeActivityIDs()
//                        } catch {
//                            print("Failed to start activity: \(error)")
//                        }
                    }
                }
                .padding()
                
                // If an activity is active, show options to update, stop, and get its push token
                if let id = currentActivityId {
                    Text("Current Activity ID: \(id)")
                    
                    Button("Update Activity") {
                        Task {
//                            // For demo purposes, append an extra emoji to the current one
//                            let newEmoji = emoji + "✨"
//                            let newContentState = ikigaiWidgetsAttributes.ContentState(emoji: newEmoji)
//                            await liveActivityManager.updateActivity(
//                                id: id,
//                                newContentState: newContentState,
//                                staleDate: Date().addingTimeInterval(120)
//                            )
//                            emoji = newEmoji
                        }
                    }
                    .padding()
                    
                    Button("Get Start Token") {
                        Task {
                             
                            
                        }
                    }
                    .padding()
                    
                    Button("Stop Activity") {
                        Task {
//                            await liveActivityManager.stopActivity(id: id)
//                            currentActivityId = nil
//                            activeIDs = liveActivityManager.activeActivityIDs()
                        }
                    }
                    .padding()
                    
                    Button("Get Push Token") {
                        Task {
//                            if let pushToken = try await liveActivityManager.getPushToken(for: activeIDs.first!) {
//                                let tokenString = pushToken.reduce("") { $0 + String(format: "%02x", $1) }
//                                print("Initial push token for activity \(activeIDs.first!): \(tokenString)")
//                            }
                        }
                    }
                    .padding()
                    
                    if !pushToken.isEmpty {
                        Text("Push Token: \(pushToken)")
                            .padding(.horizontal)
                    }
                }
                
                // Button to stop all active live activities
                Button("Stop All Activities") {
                    Task {
//                        await liveActivityManager.endAllActivities()
//                        currentActivityId = nil
//                        activeIDs = liveActivityManager.activeActivityIDs()
                    }
                }
                .padding()
                
                // Display the list of active activity IDs
                Text("Active Activity IDs:")
                List(activeIDs, id: \.self) { id in
                    Text(id)
                }
                .frame(height: 150)
            }
            .navigationTitle("Live Activities Test")
        }
        .task {
            for await data in Activity<ikigaiWidgetsAttributes>.pushToStartTokenUpdates {
                let token = data.map { String(format: "%02x", $0) }.joined()
                print("Start token updated: \(token)")
           }
        }
    }
}

struct LiveActivitiesTestView_Previews: PreviewProvider {
    static var previews: some View {
        LiveActivitiesTestView()
    }
}

