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
#else
import UIKit
import SwiftUI

// Typealiases for iOS (and visionOS)
public typealias PlatformView = UIView
public typealias PlatformViewController = UIViewController
public typealias PlatformHostingController<Content: View> = UIHostingController<Content>
#endif

// An extension to pin any view to its superview.
public extension PlatformView {
    func fillSuperview() {
        guard let superview = self.superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor)
        ])
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
