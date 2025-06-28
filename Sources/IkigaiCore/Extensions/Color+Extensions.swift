//
//  AdaptiveForegroundColorModifier.swift
//  IkigaiAPI
//
//  Created by Vince Davis on 3/5/25.
//


//import SwiftUI
//#if canImport(AppKit)
//import AppKit
//#endif
//
//#if canImport(UIKit)
//import UIKit
//#endif
//
//extension Color {
//#if os(macOS)
//    init(
//        light lightModeColor: @escaping @autoclosure () -> Color,
//        dark darkModeColor: @escaping @autoclosure () -> Color
//    ) {
//        
//        self.init(NSColor(
//            light: NSColor(lightModeColor()),
//            dark: NSColor(darkModeColor())
//        ))
//    }
//#endif
//    
//#if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst) || os(watchOS) || os(visonOS)
//    init(
//        light lightModeColor: @escaping @autoclosure () -> Color,
//        dark darkModeColor: @escaping @autoclosure () -> Color
//    ) {
//        
//        self.init(UIColor(
//            light: UIColor(lightModeColor()),
//            dark: UIColor(darkModeColor())
//        ))
//    }
//#endif
//    static var main: Self {
//        Self(light: .black,
//             dark: .white)
//        }
//    
//    static var mainReversed: Self {
//        Self(light: .white,
//             dark: .black)
//        }
//}
//
//extension UIColor {
//    convenience init(
//        light lightModeColor: @escaping @autoclosure () -> UIColor,
//        dark darkModeColor: @escaping @autoclosure () -> UIColor
//     ) {
//        self.init { traitCollection in
//            switch traitCollection.userInterfaceStyle {
//            case .light:
//                return lightModeColor()
//            case .dark:
//                return darkModeColor()
//            case .unspecified:
//                return lightModeColor()
//            @unknown default:
//                return lightModeColor()
//            }
//        }
//    }
//}
//
//struct AdaptiveForegroundColorModifier: ViewModifier {
//    var lightModeColor: Color
//    var darkModeColor: Color
//    
//    @Environment(\.colorScheme) private var colorScheme
//    
//    func body(content: Content) -> some View {
//        content.foregroundColor(resolvedColor)
//    }
//    
//    private var resolvedColor: Color {
//        switch colorScheme {
//        case .light:
//            return lightModeColor
//        case .dark:
//            return darkModeColor
//        @unknown default:
//            return lightModeColor
//        }
//    }
//}
//
//extension View {
//    func foregroundColor(
//        light lightModeColor: Color,
//        dark darkModeColor: Color
//    ) -> some View {
//        modifier(AdaptiveForegroundColorModifier(
//            lightModeColor: lightModeColor,
//            darkModeColor: darkModeColor
//        ))
//    }
//}
