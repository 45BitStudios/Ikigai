import SwiftUI
import UserNotifications
#if canImport(UIKit)
import UIKit
import UserNotificationsUI
#elseif canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
class NotificationHostingController: UIViewController, UNNotificationContentExtension {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hostingController = UIHostingController(rootView: NotificationExtensionView())
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func didReceive(_ notification: UNNotification) {
        // Handle notification content
    }
}
#elseif canImport(AppKit)
class NotificationHostingController: NSViewController {
    override func loadView() {
        let hostingView = NSHostingView(rootView: NotificationExtensionView())
        self.view = hostingView
    }
}
#endif