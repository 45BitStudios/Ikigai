//
//  AppVersion.swift
//  IkigaiAPI
//
//  Created by Vince Davis on 3/5/25.
//


import Foundation

public class AppVersion {
    let appShortVersionString: String
    let appBundleVersionString: String
    
    public var major: Int {
        if let major = appShortVersionString.split(separator: ".").first {
            return Int(major) ?? 0
        }
        return 0
    }
    
    public var minor: Int {
        let splat = appShortVersionString.split(separator: ".")
        if splat.count > 1 {
            return Int(splat[1]) ?? 0
        }
        return 0
    }
    
    public var patch: Int {
        let versions = appShortVersionString.split(separator: ".")
        if let patch = versions.last, versions.count > 2 {
            return Int(patch) ?? 0
        }
        return 0
    }
    
    public var buildNumber: Int {
        return Int(appBundleVersionString) ?? 0
    }
    
    init(shortVersionString: String, bundleVersionString: String) {
        appShortVersionString = shortVersionString
        appBundleVersionString = bundleVersionString
    }
    
    @MainActor static let shared = AppVersion(
        shortVersionString: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "",
        bundleVersionString: Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
    )
    
    var appShortVersion: String {
        appShortVersionString
    }
    
    var appBundleVersion: String {
        appBundleVersionString
    }
}

extension AppVersion: Equatable {
    public static func == (lhs: AppVersion, rhs: AppVersion) -> Bool {
        lhs.major == rhs.major &&
        lhs.minor == lhs.minor &&
        lhs.patch == lhs.patch
    }
    
    public static func === (lhs: AppVersion, rhs: AppVersion) -> Bool {
        lhs.major == rhs.major &&
        lhs.minor == rhs.minor &&
        lhs.patch == rhs.patch &&
        lhs.buildNumber == rhs.buildNumber
    }
}

extension AppVersion: Comparable {
    public static func < (lhs: AppVersion, rhs: AppVersion) -> Bool {
        if lhs.major == rhs.major {
            if lhs.minor == rhs.minor {
                if lhs.patch == rhs.patch {
                    return false
                }
                return lhs.patch < rhs.patch
            }
            return lhs.minor < rhs.minor
        }
        return lhs.major < rhs.major
    }
}
