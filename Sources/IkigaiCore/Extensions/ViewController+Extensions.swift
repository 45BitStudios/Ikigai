//
//  UIKit+Extensions.swift
//  IkigaiAPI
//
//  Created by Vince Davis on 4/4/25.
//

#if os(macOS)
import AppKit
import SwiftUI

// Typealiases for macOS
public typealias PlatformView = NSView
public typealias PlatformViewController = NSViewController
public typealias PlatformHostingController<Content: View> = NSHostingController<Content>
#elseif canImport(UIKit) && !os(watchOS)
import UIKit
import SwiftUI

// Typealiases for iOS, tvOS, visionOS (platforms with UIKit but not watchOS)
public typealias PlatformView = UIView
public typealias PlatformViewController = UIViewController
public typealias PlatformHostingController<Content: View> = UIHostingController<Content>
#endif

#if os(macOS) || (canImport(UIKit) && !os(watchOS))
// An extension to pin any view to its superview.
public extension PlatformView {
    func fillSuperview() {
        guard let superview = self.superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        #if os(macOS)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor)
        ])
        #else
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor)
        ])
        #endif
    }
}

// An extension for adding a SwiftUI view as a child view controller.
public extension PlatformViewController {
    func add<Content: View>(swiftUIView: Content) {
        let childView = PlatformHostingController(rootView: swiftUIView)
        addChild(childView)
        view.addSubview(childView.view)
        childView.didMove(toParent: self)
        childView.view.fillSuperview()
    }
}
#endif

#if canImport(Messages)
import Messages

public extension MSMessagesAppViewController {
    /// Embeds a SwiftUI view into the MSMessagesAppViewController
    func addMessageView<Content: View>(swiftUIView: Content) {
        let hostingController = PlatformHostingController(rootView: swiftUIView)
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)

        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        hostingController.didMove(toParent: self)
    }
}
#endif

