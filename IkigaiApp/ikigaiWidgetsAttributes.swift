//
//  ikigaiWidgetsAttributes.swift
//  Ikigai
//
//  Created by Vince Davis on 3/24/25.
//
import ActivityKit
import WidgetKit

struct ikigaiWidgetsAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}
