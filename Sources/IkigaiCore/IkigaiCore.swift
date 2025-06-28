/// IkigaiCore - Core functionality and shared components
/// 
/// This module provides essential functionality for the Ikigai application including:
/// - Router: Type-safe navigation system with SwiftUI integration
/// - Networking: Network service utilities
/// - Extensions: Useful extensions for common types
/// - Helpers: Utility functions and classes
/// - Live Activities: Support for iOS Live Activities
/// - External Screen: Multi-display support
/// - And more...

import Foundation

// MARK: - Router Module

// Re-export router functionality for convenient access
// All router types and protocols are available when importing IkigaiCore

/// Router system for type-safe navigation
/// 
/// Usage:
/// ```swift
/// import IkigaiCore
/// 
/// let router = Router<AppRoute>.withStandardMappings()
/// let navigationManager = NavigationManager.standard()
/// ```