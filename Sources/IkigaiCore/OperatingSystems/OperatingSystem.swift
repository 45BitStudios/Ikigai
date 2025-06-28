//
//  OperatingSystem.swift
//  IkigaiAPI
//
//  Created by Vince Davis on 3/4/25.
//


import Foundation

public enum OperatingSystem : Sendable{
    case macOS
    case iOS
    case tvOS
    case watchOS
    case visionOS
    case server
    case unsupported
    
    #if os(macOS)
    public static let current = macOS
    #elseif os(iOS)
    public static let current = iOS
    #elseif os(tvOS)
    public static let current = tvOS
    #elseif os(watchOS)
    public static let current = watchOS
    #elseif os(visionOS)
    public static let current = visionOS
    #elseif os(Linux) || os(WASI)
    public static let current = server
    #else
    public static let current = unsupported
    #endif
}

public extension OperatingSystem {
    var sfSymbol: String {
        switch self {
        case .macOS:
            return "macbook"
        case .iOS:
            return "iphone"
        case .tvOS:
            return "appletv"
        case .watchOS:
            return "applewatch"
        case .visionOS:
            return "vision.pro"
        case .server:
            return "server.rack"
        case .unsupported:
            return "exclamationmark.triangle"
        }
    }
}
