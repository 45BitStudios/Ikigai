import SwiftUI
import IkigaiCore
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
class ActionHostingController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        var actionView = ActionExtensionView()
        self.add(swiftUIView: actionView)
    }
}
#elseif canImport(AppKit)
class ActionHostingController: NSViewController {
    override func loadView() {
        var actionView = ActionExtensionView()
        self.add(swiftUIView: actionView)
    }
}
#endif
