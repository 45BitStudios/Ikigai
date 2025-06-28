import Observation
import SwiftUI

//struct ExternalScreenToolBarModifier: ViewModifier {
//    var screenManager: ScreenManager
//    @Binding var showingSheet: Bool
//
//    func body(content: Content) -> some View {
//        #if os(iOS)
//        return content
//            .toolbar {
//                ExternalScreenToolBar(screenManager: screenManager, showingSheet: $showingSheet)
//            }
//        #else
//        return content
//        #endif
//    }
//}

public extension View {
    func externalScreen<ScreenContent>(_ showingExternalScreen: Binding<Bool>, screenContent: @escaping () -> ScreenContent) -> some View where ScreenContent: View {
        modifier(ExternalScreenViewModifier(showingExternalScreen: showingExternalScreen,  screenContent: screenContent))
    }
    
//    func externalScreenToolbar(screenManager: ScreenManager, showingSheet: Binding<Bool>) -> some View {
//        return self.modifier(ExternalScreenToolBarModifier(screenManager: screenManager, showingSheet: showingSheet))
//    }
}



@Observable
public class ScreenManager {
    public init() {}
    
    public var showScreen = false
    
}
