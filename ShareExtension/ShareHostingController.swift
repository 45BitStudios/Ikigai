import SwiftUI
#if canImport(UIKit)
import UIKit
import Social
#elseif canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
class ShareHostingController: SLComposeServiceViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hostingController = UIHostingController(rootView: ShareExtensionView())
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
    
    override func isContentValid() -> Bool {
        return true
    }
    
    override func didSelectPost() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}
#elseif canImport(AppKit)
class ShareHostingController: NSViewController {
    override func loadView() {
        let hostingView = NSHostingView(rootView: ShareExtensionView())
        self.view = hostingView
    }
}
#endif
