import SwiftUI
#if canImport(UIKit)
import UIKit
import Messages
#endif

#if canImport(UIKit)
class MessageHostingController: MSMessagesAppViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var messageView = MessageExtensionView()
        //self.addMessageView(swiftUIView: messageView)

    }
    
    override func willBecomeActive(with conversation: MSConversation) {
        super.willBecomeActive(with: conversation)
    }
    
    override func didBecomeActive(with conversation: MSConversation) {
        super.didBecomeActive(with: conversation)
    }
    
    override func willSelect(_ message: MSMessage, conversation: MSConversation) {
        super.willSelect(message, conversation: conversation)
    }
    
    override func didSelect(_ message: MSMessage, conversation: MSConversation) {
        super.didSelect(message, conversation: conversation)
    }
}
#endif
